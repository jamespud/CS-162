#include "filesys/inode.h"
#include "filesys/filesys.h"
#include "filesys/free-map.h"
#include "threads/malloc.h"
#include "threads/synch.h"
#include <debug.h>
#include <list.h>
#include <round.h>
#include <string.h>

/* Identifies an inode. */
#define INODE_MAGIC 0x494e4f44

#define BUFFER_SIZE 64

/* On-disk inode.
   Must be exactly BLOCK_SECTOR_SIZE bytes long. */
struct inode_disk {
  block_sector_t start; /* First data sector. */
  off_t length;         /* File size in bytes. */
  unsigned magic;       /* Magic number. */
  uint32_t unused[125]; /* Not used. */
};

/* Returns the number of sectors to allocate for an inode SIZE
   bytes long. */
static inline size_t bytes_to_sectors(off_t size) { return DIV_ROUND_UP(size, BLOCK_SECTOR_SIZE); }

/* In-memory inode. */
struct inode {
  struct list_elem elem;  /* Element in inode list. */
  block_sector_t sector;  /* Sector number of disk location. */
  int open_cnt;           /* Number of openers. */
  bool removed;           /* True if deleted, false otherwise. */
  int deny_write_cnt;     /* 0: writes ok, >0: deny writes. */
  struct inode_disk data; /* Inode content. */
};

/* A single entry in the buffer cache. */
struct cache_entry {
  uint8_t data[BLOCK_SECTOR_SIZE]; /* Cached block data. */
  block_sector_t sector_num;       /* Sector this entry caches. */
  bool dirty;                      /* True if modified, needs writeback. */
  bool valid;                      /* True if entry holds valid data. */
  bool accessed;                   /* Reference bit for clock algorithm. */
  int pin_count;                   /* Number of active readers/writers. */
  struct lock lock;                /* Protects this entry's data. */
};

/* The buffer cache: 64 cache entries plus metadata. */
struct buffer_cache {
  struct cache_entry entries[BUFFER_SIZE]; /* Cached blocks. */
  struct lock lock;                        /* Protects cache metadata. */
  uint32_t clock_hand;                     /* Clock hand for replacement. */
};

static struct buffer_cache cache;

static int cache_lookup(block_sector_t sector);
static int cache_select_victim(void);
static void cache_evict(int index);
static void cache_flush_entry(int index);
static void cache_read(block_sector_t sector, void* buf, int sector_ofs, int chunk_size);
static void cache_write(block_sector_t sector, const void* buf, int sector_ofs, int chunk_size);

/* Returns the block device sector that contains byte offset POS
   within INODE.
   Returns -1 if INODE does not contain data for a byte at offset
   POS. */
static block_sector_t byte_to_sector(const struct inode* inode, off_t pos) {
  ASSERT(inode != NULL);
  if (pos < inode->data.length)
    return inode->data.start + pos / BLOCK_SECTOR_SIZE;
  else
    return -1;
}

/* List of open inodes, so that opening a single inode twice
   returns the same `struct inode'. */
static struct list open_inodes;

/* Initializes the inode module. */
void inode_init(void) { list_init(&open_inodes); }

/* Initializes an inode with LENGTH bytes of data and
   writes the new inode to sector SECTOR on the file system
   device.
   Returns true if successful.
   Returns false if memory or disk allocation fails. */
bool inode_create(block_sector_t sector, off_t length) {
  struct inode_disk* disk_inode = NULL;
  bool success = false;

  ASSERT(length >= 0);

  /* If this assertion fails, the inode structure is not exactly
     one sector in size, and you should fix that. */
  ASSERT(sizeof *disk_inode == BLOCK_SECTOR_SIZE);

  disk_inode = calloc(1, sizeof *disk_inode);
  if (disk_inode != NULL) {
    size_t sectors = bytes_to_sectors(length);
    disk_inode->length = length;
    disk_inode->magic = INODE_MAGIC;
    if (free_map_allocate(sectors, &disk_inode->start)) {
      cache_write(sector, disk_inode, 0, BLOCK_SECTOR_SIZE);
      if (sectors > 0) {
        static char zeros[BLOCK_SECTOR_SIZE];
        size_t i;

        for (i = 0; i < sectors; i++)
          cache_write(disk_inode->start + i, zeros, 0, BLOCK_SECTOR_SIZE);
      }
      success = true;
    }
    free(disk_inode);
  }
  return success;
}

/* Reads an inode from SECTOR
   and returns a `struct inode' that contains it.
   Returns a null pointer if memory allocation fails. */
struct inode* inode_open(block_sector_t sector) {
  struct list_elem* e;
  struct inode* inode;

  /* Check whether this inode is already open. */
  for (e = list_begin(&open_inodes); e != list_end(&open_inodes); e = list_next(e)) {
    inode = list_entry(e, struct inode, elem);
    if (inode->sector == sector) {
      inode_reopen(inode);
      return inode;
    }
  }

  /* Allocate memory. */
  inode = malloc(sizeof *inode);
  if (inode == NULL)
    return NULL;

  /* Initialize. */
  list_push_front(&open_inodes, &inode->elem);
  inode->sector = sector;
  inode->open_cnt = 1;
  inode->deny_write_cnt = 0;
  inode->removed = false;
  cache_read(inode->sector, &inode->data, 0, BLOCK_SECTOR_SIZE);
  return inode;
}

/* Reopens and returns INODE. */
struct inode* inode_reopen(struct inode* inode) {
  if (inode != NULL)
    inode->open_cnt++;
  return inode;
}

/* Returns INODE's inode number. */
block_sector_t inode_get_inumber(const struct inode* inode) { return inode->sector; }

/* Closes INODE and writes it to disk.
   If this was the last reference to INODE, frees its memory.
   If INODE was also a removed inode, frees its blocks. */
void inode_close(struct inode* inode) {
  /* Ignore null pointer. */
  if (inode == NULL)
    return;

  /* Release resources if this was the last opener. */
  if (--inode->open_cnt == 0) {
    /* Remove from inode list and release lock. */
    list_remove(&inode->elem);

    /* Deallocate blocks if removed. */
    if (inode->removed) {
      free_map_release(inode->sector, 1);
      free_map_release(inode->data.start, bytes_to_sectors(inode->data.length));
    }

    free(inode);
  }
}

/* Marks INODE to be deleted when it is closed by the last caller who
   has it open. */
void inode_remove(struct inode* inode) {
  ASSERT(inode != NULL);
  inode->removed = true;
}

/* Reads SIZE bytes from INODE into BUFFER, starting at position OFFSET.
   Returns the number of bytes actually read, which may be less
   than SIZE if an error occurs or end of file is reached. */
off_t inode_read_at(struct inode* inode, void* buffer_, off_t size, off_t offset) {
  uint8_t* buffer = buffer_;
  off_t bytes_read = 0;

  while (size > 0) {
    /* Disk sector to read, starting byte offset within sector. */
    block_sector_t sector_idx = byte_to_sector(inode, offset);
    int sector_ofs = offset % BLOCK_SECTOR_SIZE;

    /* Bytes left in inode, bytes left in sector, lesser of the two. */
    off_t inode_left = inode_length(inode) - offset;
    int sector_left = BLOCK_SECTOR_SIZE - sector_ofs;
    int min_left = inode_left < sector_left ? inode_left : sector_left;

    /* Number of bytes to actually copy out of this sector. */
    int chunk_size = size < min_left ? size : min_left;
    if (chunk_size <= 0)
      break;

    cache_read(sector_idx, buffer + bytes_read, sector_ofs, chunk_size);

    /* Advance. */
    size -= chunk_size;
    offset += chunk_size;
    bytes_read += chunk_size;
  }

  return bytes_read;
}

/* Writes SIZE bytes from BUFFER into INODE, starting at OFFSET.
   Returns the number of bytes actually written, which may be
   less than SIZE if end of file is reached or an error occurs.
   (Normally a write at end of file would extend the inode, but
   growth is not yet implemented.) */
off_t inode_write_at(struct inode* inode, const void* buffer_, off_t size, off_t offset) {
  const uint8_t* buffer = buffer_;
  off_t bytes_written = 0;

  if (inode->deny_write_cnt)
    return 0;

  while (size > 0) {
    /* Sector to write, starting byte offset within sector. */
    block_sector_t sector_idx = byte_to_sector(inode, offset);
    int sector_ofs = offset % BLOCK_SECTOR_SIZE;

    /* Bytes left in inode, bytes left in sector, lesser of the two. */
    off_t inode_left = inode_length(inode) - offset;
    int sector_left = BLOCK_SECTOR_SIZE - sector_ofs;
    int min_left = inode_left < sector_left ? inode_left : sector_left;

    /* Number of bytes to actually write into this sector. */
    int chunk_size = size < min_left ? size : min_left;
    if (chunk_size <= 0)
      break;

    cache_write(sector_idx, buffer + bytes_written, sector_ofs, chunk_size);

    /* Advance. */
    size -= chunk_size;
    offset += chunk_size;
    bytes_written += chunk_size;
  }

  return bytes_written;
}

/* Disables writes to INODE.
   May be called at most once per inode opener. */
void inode_deny_write(struct inode* inode) {
  inode->deny_write_cnt++;
  ASSERT(inode->deny_write_cnt <= inode->open_cnt);
}

/* Re-enables writes to INODE.
   Must be called once by each inode opener who has called
   inode_deny_write() on the inode, before closing the inode. */
void inode_allow_write(struct inode* inode) {
  ASSERT(inode->deny_write_cnt > 0);
  ASSERT(inode->deny_write_cnt <= inode->open_cnt);
  inode->deny_write_cnt--;
}

/* Returns the length, in bytes, of INODE's data. */
off_t inode_length(const struct inode* inode) { return inode->data.length; }

/* Initializes the buffer cache. Must be called before any cache use. */
void cache_init(void) {
  lock_init(&cache.lock);
  cache.clock_hand = 0;

  for (size_t i = 0; i < BUFFER_SIZE; i++) {
    struct cache_entry* e = &cache.entries[i];
    lock_init(&e->lock);
    e->sector_num = 0;
    e->dirty = false;
    e->valid = false;
    e->accessed = false;
    e->pin_count = 0;
    memset(e->data, 0, BLOCK_SECTOR_SIZE);
  }
}

/* Looks up SECTOR in the cache. Caller must hold cache.lock.
   Returns the cache index, or -1 if not present. */
static int cache_lookup(block_sector_t sector) {
  for (size_t i = 0; i < BUFFER_SIZE; i++) {
    if (cache.entries[i].valid && cache.entries[i].sector_num == sector)
      return (int)i;
  }
  return -1;
}

/* Selects a cache entry to evict using the clock algorithm.
   Caller must hold cache.lock. Returns the index of the victim. */
static int cache_select_victim(void) {
  for (int pass = 0; pass < 2; pass++) {
    for (size_t i = 0; i < BUFFER_SIZE; i++) {
      uint32_t idx = (cache.clock_hand + i) % BUFFER_SIZE;
      struct cache_entry* e = &cache.entries[idx];
      if (e->pin_count > 0)
        continue;
      if (e->accessed) {
        e->accessed = false;
        continue;
      }
      cache.clock_hand = (idx + 1) % BUFFER_SIZE;
      return (int)idx;
    }
  }
  NOT_REACHED();
}

/* Evicts the entry at INDEX, writing it back to disk if dirty.
   Caller must hold cache.lock. */
static void cache_evict(int index) {
  struct cache_entry* e = &cache.entries[index];
  if (e->dirty)
    block_write(fs_device, e->sector_num, e->data);
  e->valid = false;
  e->dirty = false;
  e->accessed = false;
  e->sector_num = 0;
}

/* Writes the entry at INDEX back to disk if it is dirty, then clears
   the dirty bit. Keeps the entry cached. Caller must hold cache.lock. */
static void cache_flush_entry(int index) {
  struct cache_entry* e = &cache.entries[index];
  lock_acquire(&e->lock);
  if (e->valid && e->dirty) {
    block_write(fs_device, e->sector_num, e->data);
    e->dirty = false;
  }
  lock_release(&e->lock);
}

/* Writes all dirty cache entries back to disk. Called at shutdown. */
void cache_flush_all(void) {
  lock_acquire(&cache.lock);
  for (size_t i = 0; i < BUFFER_SIZE; i++)
    cache_flush_entry(i);
  lock_release(&cache.lock);
}

/* Reads CHUNK_SIZE bytes starting at SECTOR_OFS within SECTOR into BUF,
   through the buffer cache. */
static void cache_read(block_sector_t sector, void* buf, int sector_ofs, int chunk_size) {
  struct cache_entry* e;

  lock_acquire(&cache.lock);
  int index = cache_lookup(sector);
  if (index == -1) {
    index = cache_select_victim();
    cache_evict(index);
    e = &cache.entries[index];
    lock_acquire(&e->lock);
    e->sector_num = sector;
    e->valid = true;
    e->dirty = false;
    e->accessed = true;
    e->pin_count = 1;
    lock_release(&cache.lock);
    block_read(fs_device, sector, e->data);
    memcpy(buf, e->data + sector_ofs, chunk_size);
    lock_release(&e->lock);
    lock_acquire(&cache.lock);
    e->pin_count--;
    lock_release(&cache.lock);
  } else {
    e = &cache.entries[index];
    e->pin_count++;
    e->accessed = true;
    lock_acquire(&e->lock);
    lock_release(&cache.lock);
    memcpy(buf, e->data + sector_ofs, chunk_size);
    lock_release(&e->lock);
    lock_acquire(&cache.lock);
    e->pin_count--;
    lock_release(&cache.lock);
  }
}

/* Writes CHUNK_SIZE bytes from BUF starting at SECTOR_OFS within SECTOR,
   through the buffer cache. Marks the cached block dirty. */
static void cache_write(block_sector_t sector, const void* buf, int sector_ofs, int chunk_size) {
  struct cache_entry* e;

  lock_acquire(&cache.lock);
  int index = cache_lookup(sector);
  if (index == -1) {
    index = cache_select_victim();
    cache_evict(index);
    e = &cache.entries[index];
    lock_acquire(&e->lock);
    e->sector_num = sector;
    e->valid = true;
    e->dirty = false;
    e->accessed = true;
    e->pin_count = 1;
    lock_release(&cache.lock);
    if (!(sector_ofs == 0 && chunk_size == BLOCK_SECTOR_SIZE))
      block_read(fs_device, sector, e->data);
    memcpy(e->data + sector_ofs, buf, chunk_size);
    lock_release(&e->lock);
    lock_acquire(&cache.lock);
    e->dirty = true;
    e->pin_count--;
    lock_release(&cache.lock);
  } else {
    e = &cache.entries[index];
    e->pin_count++;
    e->accessed = true;
    lock_acquire(&e->lock);
    lock_release(&cache.lock);
    memcpy(e->data + sector_ofs, buf, chunk_size);
    lock_release(&e->lock);
    lock_acquire(&cache.lock);
    e->dirty = true;
    e->pin_count--;
    lock_release(&cache.lock);
  }
}

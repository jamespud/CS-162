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

#define DIRECT_PTRS 122
#define INDIR_PTRS (BLOCK_SECTOR_SIZE / sizeof(block_sector_t))              /* 128 */
#define DBL_RANGE (DIRECT_PTRS + INDIR_PTRS)                                 /* 252 */
#define MAX_FILE_BLOCKS (DIRECT_PTRS + INDIR_PTRS + INDIR_PTRS * INDIR_PTRS) /* 16636 */

/* On-disk inode.
   Must be exactly BLOCK_SECTOR_SIZE bytes long. */
struct inode_disk {
  off_t length;                       /* File size in bytes. */
  unsigned magic;                     /* Magic number. */
  block_sector_t direct[DIRECT_PTRS]; /* 488 */
  block_sector_t indirect;            /* 4 */
  block_sector_t doubly_indirect;     /* 4 */
  block_sector_t parent;
  uint32_t is_dir;
};

/* Returns the number of sectors to allocate for an inode SIZE
   bytes long. */
static inline size_t bytes_to_sectors(off_t size) { return DIV_ROUND_UP(size, BLOCK_SECTOR_SIZE); }

/* All-zero sector, used to zero newly allocated data and index blocks. */
static char zero_sector[BLOCK_SECTOR_SIZE];

/* In-memory inode. */
struct inode {
  struct list_elem elem;  /* Element in inode list. */
  block_sector_t sector;  /* Sector number of disk location. */
  int open_cnt;           /* Number of openers. */
  bool removed;           /* True if deleted, false otherwise. */
  int deny_write_cnt;     /* 0: writes ok, >0: deny writes. */
  struct inode_disk data; /* Inode content. */
  struct lock lock;       /* Per-inode metadata lock (extension, dir entries). */
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
static void cache_flush_entry(int index);
static void cache_read(block_sector_t sector, void* buf, int sector_ofs, int chunk_size);
static void cache_write(block_sector_t sector, const void* buf, int sector_ofs, int chunk_size);
static block_sector_t index_lookup(const struct inode_disk* id, size_t block_idx);
static bool index_allocate(struct inode_disk* id, size_t block_idx, block_sector_t sector);
static bool disk_inode_allocate_block(struct inode_disk* id, size_t block_idx, bool* grew);
static void index_free_all(const struct inode_disk* id);

/* Returns the block device sector that contains byte offset POS
   within INODE.
   Returns -1 if INODE does not contain data for a byte at offset
   POS. */
static block_sector_t byte_to_sector(const struct inode* inode, off_t pos) {
  ASSERT(inode != NULL);
  if (pos < inode->data.length) {
    int block_idx = pos / BLOCK_SECTOR_SIZE;
    block_sector_t sec = index_lookup(&inode->data, block_idx);
    return sec != 0 ? sec : (block_sector_t)-1;
  } else
    return -1;
}

/* List of open inodes, so that opening a single inode twice
   returns the same `struct inode'. */
static struct list open_inodes;

/* Protects the open_inodes list.  Never held across I/O. */
static struct lock open_inodes_lock;

/* Initializes the inode module. */
void inode_init(void) {
  list_init(&open_inodes);
  lock_init(&open_inodes_lock);
}

/* Returns the data sector that stores logical block BLOCK_IDX of the
   inode whose on-disk image is ID, or 0 if that block is not
   allocated (a sparse hole). */
static block_sector_t index_lookup(const struct inode_disk* id, size_t block_idx) {
  ASSERT(id != NULL);
  ASSERT(block_idx < MAX_FILE_BLOCKS);

  if (block_idx < DIRECT_PTRS)
    return id->direct[block_idx];

  if (block_idx < DBL_RANGE) {
    if (id->indirect == 0)
      return 0;
    block_sector_t block[INDIR_PTRS];
    cache_read(id->indirect, block, 0, BLOCK_SECTOR_SIZE);
    return block[block_idx - DIRECT_PTRS];
  }

  /* Doubly-indirect range. */
  if (id->doubly_indirect == 0)
    return 0;
  block_sector_t dbl_block[INDIR_PTRS];
  cache_read(id->doubly_indirect, dbl_block, 0, BLOCK_SECTOR_SIZE);
  size_t di = (block_idx - DBL_RANGE) / INDIR_PTRS;
  size_t inner = (block_idx - DBL_RANGE) % INDIR_PTRS;
  if (dbl_block[di] == 0)
    return 0;
  block_sector_t ind_block[INDIR_PTRS];
  cache_read(dbl_block[di], ind_block, 0, BLOCK_SECTOR_SIZE);
  return ind_block[inner];
}

/* Links SECTOR as the data block for logical block BLOCK_IDX in ID,
   allocating and zeroing index blocks as needed.  Returns true on
   success.  On failure returns false and leaves any index block
   allocated in this call linked into ID (it will be reclaimed by
   index_free_all); the caller retains ownership of SECTOR. */
static bool index_allocate(struct inode_disk* id, size_t block_idx, block_sector_t sector) {
  ASSERT(id != NULL);
  ASSERT(block_idx < MAX_FILE_BLOCKS);
  ASSERT(sector != 0);

  if (block_idx < DIRECT_PTRS) {
    id->direct[block_idx] = sector;
    return true;
  }

  if (block_idx < DBL_RANGE) {
    if (id->indirect == 0) {
      if (!free_map_allocate_one(&id->indirect))
        return false;
      cache_write(id->indirect, zero_sector, 0, BLOCK_SECTOR_SIZE);
    }
    block_sector_t block[INDIR_PTRS];
    cache_read(id->indirect, block, 0, BLOCK_SECTOR_SIZE);
    block[block_idx - DIRECT_PTRS] = sector;
    cache_write(id->indirect, block, 0, BLOCK_SECTOR_SIZE);
    return true;
  }

  /* Doubly-indirect range. */
  if (id->doubly_indirect == 0) {
    if (!free_map_allocate_one(&id->doubly_indirect))
      return false;
    cache_write(id->doubly_indirect, zero_sector, 0, BLOCK_SECTOR_SIZE);
  }
  size_t di = (block_idx - DBL_RANGE) / INDIR_PTRS;
  size_t inner = (block_idx - DBL_RANGE) % INDIR_PTRS;

  block_sector_t dbl_block[INDIR_PTRS];
  cache_read(id->doubly_indirect, dbl_block, 0, BLOCK_SECTOR_SIZE);
  if (dbl_block[di] == 0) {
    if (!free_map_allocate_one(&dbl_block[di]))
      return false;
    cache_write(dbl_block[di], zero_sector, 0, BLOCK_SECTOR_SIZE);
    cache_write(id->doubly_indirect, dbl_block, 0, BLOCK_SECTOR_SIZE);
  }
  block_sector_t ind_block[INDIR_PTRS];
  cache_read(dbl_block[di], ind_block, 0, BLOCK_SECTOR_SIZE);
  ind_block[inner] = sector;
  cache_write(dbl_block[di], ind_block, 0, BLOCK_SECTOR_SIZE);
  return true;
}

/* Ensures logical block BLOCK_IDX of ID is allocated and zeroed.
   Returns true if the block already existed or was just allocated,
   false if BLOCK_IDX is out of range or disk space is exhausted.
   *GREW (if non-NULL) is set true when a new block was allocated.
   On failure no partial state is left for this block: a freshly
   allocated data sector is released. */
static bool disk_inode_allocate_block(struct inode_disk* id, size_t block_idx, bool* grew) {
  ASSERT(id != NULL);

  if (block_idx >= MAX_FILE_BLOCKS)
    return false;

  if (index_lookup(id, block_idx) != 0)
    return true;

  block_sector_t sector;
  if (!free_map_allocate_one(&sector))
    return false;

  /* Zero the new data block so partial writes and sparse reads are
     correct. */
  cache_write(sector, zero_sector, 0, BLOCK_SECTOR_SIZE);

  if (!index_allocate(id, block_idx, sector)) {
    free_map_release_one(sector);
    return false;
  }
  if (grew != NULL)
    *grew = true;
  return true;
}

/* Frees every data block and index block referenced by ID through the
   deferred free-map interface.  The caller must free_map_flush()
   afterwards to persist the bitmap. */
static void index_free_all(const struct inode_disk* id) {
  ASSERT(id != NULL);
  size_t i;

  for (i = 0; i < DIRECT_PTRS; i++)
    if (id->direct[i] != 0)
      free_map_release_one(id->direct[i]);

  if (id->indirect != 0) {
    block_sector_t block[INDIR_PTRS];
    cache_read(id->indirect, block, 0, BLOCK_SECTOR_SIZE);
    for (i = 0; i < INDIR_PTRS; i++)
      if (block[i] != 0)
        free_map_release_one(block[i]);
    free_map_release_one(id->indirect);
  }

  if (id->doubly_indirect != 0) {
    block_sector_t dbl_block[INDIR_PTRS];
    cache_read(id->doubly_indirect, dbl_block, 0, BLOCK_SECTOR_SIZE);
    for (i = 0; i < INDIR_PTRS; i++) {
      if (dbl_block[i] != 0) {
        block_sector_t ind_block[INDIR_PTRS];
        cache_read(dbl_block[i], ind_block, 0, BLOCK_SECTOR_SIZE);
        for (size_t j = 0; j < INDIR_PTRS; j++)
          if (ind_block[j] != 0)
            free_map_release_one(ind_block[j]);
        free_map_release_one(dbl_block[i]);
      }
    }
    free_map_release_one(id->doubly_indirect);
  }
}

/* Initializes an inode with LENGTH bytes of data and
   writes the new inode to sector SECTOR on the file system
   device.
   Returns true if successful.
   Returns false if memory or disk allocation fails. */
bool inode_create(block_sector_t sector, off_t length, bool is_dir, block_sector_t parent) {
  struct inode_disk* disk_inode;
  bool success = true;

  ASSERT(length >= 0);

  /* If this assertion fails, the inode structure is not exactly
     one sector in size, and you should fix that. */
  ASSERT(sizeof *disk_inode == BLOCK_SECTOR_SIZE);

  disk_inode = calloc(1, sizeof *disk_inode);
  if (disk_inode == NULL)
    return false;

  disk_inode->length = length;
  disk_inode->magic = INODE_MAGIC;
  disk_inode->is_dir = is_dir;
  disk_inode->parent = parent;

  size_t sectors = bytes_to_sectors(length);
  for (size_t i = 0; i < sectors; i++) {
    if (!disk_inode_allocate_block(disk_inode, i, NULL)) {
      success = false;
      break;
    }
  }

  if (success) {
    cache_write(sector, disk_inode, 0, BLOCK_SECTOR_SIZE);
    free_map_flush();
  } else {
    /* Roll back every block allocated so far. */
    index_free_all(disk_inode);
    free_map_flush();
  }
  free(disk_inode);
  return success;
}

/* Reads an inode from SECTOR
   and returns a `struct inode' that contains it.
   Returns a null pointer if memory allocation fails. */
struct inode* inode_open(block_sector_t sector) {
  struct list_elem* e;
  struct inode* inode;

  /* Check whether this inode is already open. */
  lock_acquire(&open_inodes_lock);
  for (e = list_begin(&open_inodes); e != list_end(&open_inodes); e = list_next(e)) {
    inode = list_entry(e, struct inode, elem);
    if (inode->sector == sector) {
      inode_reopen(inode);
      lock_release(&open_inodes_lock);
      return inode;
    }
  }
  lock_release(&open_inodes_lock);

  /* Allocate memory and load the inode image from disk outside the list
     lock, so concurrent opens of different inodes issue I/O concurrently. */
  inode = malloc(sizeof *inode);
  if (inode == NULL)
    return NULL;

  inode->sector = sector;
  inode->open_cnt = 1;
  inode->deny_write_cnt = 0;
  inode->removed = false;
  lock_init(&inode->lock);
  cache_read(inode->sector, &inode->data, 0, BLOCK_SECTOR_SIZE);

  /* Re-check: another thread may have opened the same sector while we
     loaded the image from disk.  If so, discard ours and reuse theirs. */
  lock_acquire(&open_inodes_lock);
  for (e = list_begin(&open_inodes); e != list_end(&open_inodes); e = list_next(e)) {
    struct inode* other = list_entry(e, struct inode, elem);
    if (other->sector == sector) {
      inode_reopen(other);
      lock_release(&open_inodes_lock);
      free(inode);
      return other;
    }
  }
  list_push_front(&open_inodes, &inode->elem);
  lock_release(&open_inodes_lock);
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

  /* Decrement open count and unlink from the open list under the list lock.
     The block deallocation (which does I/O) is done outside the lock so the
     list lock is never held across I/O. */
  lock_acquire(&open_inodes_lock);
  if (--inode->open_cnt > 0) {
    lock_release(&open_inodes_lock);
    return;
  }
  list_remove(&inode->elem);
  lock_release(&open_inodes_lock);

  /* Deallocate blocks if removed.  No other thread can reach this inode now:
     it is unlinked and open_cnt == 0. */
  if (inode->removed) {
    index_free_all(&inode->data);
    free_map_release(inode->sector, 1);
    free_map_flush();
  }
  free(inode);
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

    if (sector_idx == (block_sector_t)-1) {
      memset(buffer + bytes_read, 0, chunk_size);
    } else {
      cache_read(sector_idx, buffer + bytes_read, sector_ofs, chunk_size);
    }

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
   Acquires INODE's metadata lock; callers that already hold it
   (e.g. directory entry modification) should call
   inode_write_at_nolock() instead. */
off_t inode_write_at(struct inode* inode, const void* buffer_, off_t size, off_t offset) {
  off_t bytes_written;
  lock_acquire(&inode->lock);
  bytes_written = inode_write_at_nolock(inode, buffer_, size, offset);
  lock_release(&inode->lock);
  return bytes_written;
}

/* Core write logic without acquiring the inode lock.  The caller must
   hold INODE->lock if concurrent writers are possible. */
off_t inode_write_at_nolock(struct inode* inode, const void* buffer_, off_t size, off_t offset) {
  const uint8_t* buffer = buffer_;
  off_t bytes_written = 0;
  bool grew = false;
  bool length_changed = false;

  if (inode->deny_write_cnt)
    return 0;

  while (size > 0) {
    /* Sector to write, starting byte offset within sector. */
    size_t block_idx = offset / BLOCK_SECTOR_SIZE;
    int sector_ofs = offset % BLOCK_SECTOR_SIZE;
    int sector_left = BLOCK_SECTOR_SIZE - sector_ofs;
    int chunk_size = size < sector_left ? size : sector_left;

    /* Grow the file to cover this block.  On disk-full, stop and
       keep whatever has been written so far. */
    if (!disk_inode_allocate_block(&inode->data, block_idx, &grew))
      break;

    /* The block may have just been allocated, so re-resolve the sector
       after growth (byte_to_sector would return -1 past old EOF). */
    block_sector_t sector_idx = index_lookup(&inode->data, block_idx);
    cache_write(sector_idx, buffer + bytes_written, sector_ofs, chunk_size);

    /* Advance. */
    size -= chunk_size;
    offset += chunk_size;
    bytes_written += chunk_size;

    if (offset > inode->data.length) {
      inode->data.length = offset;
      length_changed = true;
    }
  }

  /* Persist the inode (length/pointers) and, only when blocks were
     allocated, the free map. */
  if (grew || length_changed) {
    cache_write(inode->sector, &inode->data, 0, BLOCK_SECTOR_SIZE);
    if (grew)
      free_map_flush();
  }

  return bytes_written;
}

/* Disables writes to INODE.
   May be called at most once per inode opener. */
void inode_deny_write(struct inode* inode) {
  lock_acquire(&inode->lock);
  inode->deny_write_cnt++;
  ASSERT(inode->deny_write_cnt <= inode->open_cnt);
  lock_release(&inode->lock);
}

/* Re-enables writes to INODE.
   Must be called once by each inode opener who has called
   inode_deny_write() on the inode, before closing the inode. */
void inode_allow_write(struct inode* inode) {
  lock_acquire(&inode->lock);
  ASSERT(inode->deny_write_cnt > 0);
  ASSERT(inode->deny_write_cnt <= inode->open_cnt);
  inode->deny_write_cnt--;
  lock_release(&inode->lock);
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
   through the buffer cache.  Blocking I/O is performed under the
   per-entry lock only, never under the global cache lock. */
static void cache_read(block_sector_t sector, void* buf, int sector_ofs, int chunk_size) {
  while (true) {
    struct cache_entry* e;
    int index;

    lock_acquire(&cache.lock);
    index = cache_lookup(sector);
    if (index != -1) {
      e = &cache.entries[index];
      e->pin_count++;
      lock_acquire(&e->lock);
      lock_release(&cache.lock);
      if (e->valid && e->sector_num == sector) {
        e->accessed = true;
        memcpy(buf, e->data + sector_ofs, chunk_size);
        lock_release(&e->lock);
        lock_acquire(&cache.lock);
        e->pin_count--;
        lock_release(&cache.lock);
        return;
      }
      /* Entry was repurposed while we waited on e->lock; retry. */
      lock_release(&e->lock);
      lock_acquire(&cache.lock);
      e->pin_count--;
      lock_release(&cache.lock);
      continue;
    }

    /* Miss: pick a victim, pin it (keeping it valid so concurrent hits on
       its old sector still read correct data during writeback), then do
       writeback and the new-sector load under e->lock only. */
    index = cache_select_victim();
    e = &cache.entries[index];
    e->pin_count = 1;
    lock_acquire(&e->lock);
    lock_release(&cache.lock);

    if (e->dirty) {
      block_sector_t old_sector = e->sector_num;
      e->dirty = false;
      block_write(fs_device, old_sector, e->data);
    }

    e->sector_num = sector;
    e->valid = true;
    e->dirty = false;
    e->accessed = true;
    block_read(fs_device, sector, e->data);
    memcpy(buf, e->data + sector_ofs, chunk_size);
    lock_release(&e->lock);

    /* Double-check: another thread may have installed SECTOR in a
       different entry while we loaded.  If so, discard ours and retry. */
    lock_acquire(&cache.lock);
    if (cache_lookup(sector) != index) {
      e->valid = false;
      e->pin_count--;
      lock_release(&cache.lock);
      continue;
    }
    e->pin_count--;
    lock_release(&cache.lock);
    return;
  }
}

/* Writes CHUNK_SIZE bytes from BUF starting at SECTOR_OFS within SECTOR,
   through the buffer cache.  Marks the cached block dirty.  Blocking I/O
   is performed under the per-entry lock only, never under the global
   cache lock. */
static void cache_write(block_sector_t sector, const void* buf, int sector_ofs, int chunk_size) {
  while (true) {
    struct cache_entry* e;
    int index;

    lock_acquire(&cache.lock);
    index = cache_lookup(sector);
    if (index != -1) {
      e = &cache.entries[index];
      e->pin_count++;
      lock_acquire(&e->lock);
      lock_release(&cache.lock);
      if (e->valid && e->sector_num == sector) {
        e->accessed = true;
        memcpy(e->data + sector_ofs, buf, chunk_size);
        e->dirty = true;
        lock_release(&e->lock);
        lock_acquire(&cache.lock);
        e->pin_count--;
        lock_release(&cache.lock);
        return;
      }
      lock_release(&e->lock);
      lock_acquire(&cache.lock);
      e->pin_count--;
      lock_release(&cache.lock);
      continue;
    }

    index = cache_select_victim();
    e = &cache.entries[index];
    e->pin_count = 1;
    lock_acquire(&e->lock);
    lock_release(&cache.lock);

    if (e->dirty) {
      block_sector_t old_sector = e->sector_num;
      e->dirty = false;
      block_write(fs_device, old_sector, e->data);
    }

    e->sector_num = sector;
    e->valid = true;
    e->dirty = false;
    e->accessed = true;
    if (!(sector_ofs == 0 && chunk_size == BLOCK_SECTOR_SIZE))
      block_read(fs_device, sector, e->data);
    memcpy(e->data + sector_ofs, buf, chunk_size);
    e->dirty = true;
    lock_release(&e->lock);

    lock_acquire(&cache.lock);
    if (cache_lookup(sector) != index) {
      e->valid = false;
      e->pin_count--;
      lock_release(&cache.lock);
      continue; /* retry hits the existing entry and re-applies the write */
    }
    e->pin_count--;
    lock_release(&cache.lock);
    return;
  }
}

bool inode_is_dir(struct inode* id) { return id != NULL && id->data.is_dir == 1; }

block_sector_t inode_get_parent(const struct inode* inode) { return inode->data.parent; }

bool inode_is_removed(struct inode* id) { return id->removed; }

struct lock* inode_get_lock(struct inode* inode) { return &inode->lock; }
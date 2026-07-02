/*
 * mm_alloc.c
 */

#include "mm_alloc.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define ALIGNMENT 8
#define ALIGN(size) (((size) + (ALIGNMENT - 1)) & ~(ALIGNMENT - 1))

typedef struct s_block* t_block;

struct s_block {
  size_t size;
  t_block prev;
  t_block next;
  int free;
};

#define BLOCK_SIZE sizeof(struct s_block)

t_block head = NULL;

/* Helper: Find a free block that fits the requested size (First Fit) */
static t_block find_block(t_block* last, size_t size) {
  t_block b = head;
  while (b && !(b->free && b->size >= size)) {
    *last = b;
    b = b->next;
  }
  return b;
}

/* Helper: Extend the heap using sbrk */
static t_block extend_heap(t_block last, size_t size) {
  intptr_t increment = (intptr_t)(BLOCK_SIZE + size);
  if (increment <= 0) {
    return NULL;
  }

  t_block b = (t_block)sbrk(increment);
  if (b == (void*)-1) {
    return NULL;  
  }

  b->size = size;
  b->next = NULL;
  b->prev = last;
  b->free = 0;

  if (last) {
    last->next = b;
  }
  return b;
}

/* Helper: Split a block if it's large enough to hold a new block */
static void split_block(t_block b, size_t size) {
  if (b->size >= size + BLOCK_SIZE + ALIGNMENT) {
    t_block new_block = (t_block)((char*)(b + 1) + size);
    new_block->size = b->size - size - BLOCK_SIZE;
    new_block->free = 1;
    new_block->next = b->next;
    new_block->prev = b;

    if (new_block->next) {
      new_block->next->prev = new_block;
    }
    b->next = new_block;
    b->size = size;
  }
}

/* Helper: Coalesce adjacent free blocks */
static t_block coalesce(t_block b) {
  while (b->next && b->next->free) {
    b->size += BLOCK_SIZE + b->next->size;
    b->next = b->next->next;
    if (b->next) {
      b->next->prev = b;
    }
  }
  while (b->prev && b->prev->free) {
    b->prev->size += BLOCK_SIZE + b->size;
    b->prev->next = b->next;
    if (b->next) {
      b->next->prev = b->prev;
    }
    b = b->prev;
  }
  return b;
}

void* mm_malloc(size_t size) {
  if (size == 0) return NULL;

  size_t aligned_size = ALIGN(size);
  t_block b, last;

  if (head) {
    last = head;
    b = find_block(&last, aligned_size);
    if (b) {
      if (b->size >= aligned_size + BLOCK_SIZE + ALIGNMENT) {
        split_block(b, aligned_size);
      }
      b->free = 0;
    } else {
      b = extend_heap(last, aligned_size);
      if (!b) return NULL;
    }
  } else {
    b = extend_heap(NULL, aligned_size);
    if (!b) return NULL;
    head = b;
  }

  memset(b + 1, 0, aligned_size);
  return (void*)(b + 1);
}

void* mm_realloc(void* ptr, size_t size) {
  if (!ptr) return mm_malloc(size);
  if (size == 0) {
    mm_free(ptr);
    return NULL;
  }

  t_block b = (t_block)((char*)ptr - BLOCK_SIZE);
  size_t aligned_size = ALIGN(size);

  if (b->size >= aligned_size) {
    split_block(b, aligned_size);
    return ptr;
  }

  void* new_ptr = mm_malloc(size);
  if (!new_ptr) return NULL;

  // Copy old data to the new block
  memcpy(new_ptr, ptr, b->size);
  mm_free(ptr);

  return new_ptr;

  return NULL;
}

void mm_free(void* ptr) {
  if (!ptr) return;

  t_block b = (t_block)((char*)ptr - BLOCK_SIZE);
  b->free = 1;
  coalesce(b);
}

#include <assert.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* Function pointers to hw3 functions */
void* (*mm_malloc)(size_t);
void* (*mm_realloc)(void*, size_t);
void (*mm_free)(void*);

static void* try_dlsym(void* handle, const char* symbol) {
  char* error;
  void* function = dlsym(handle, symbol);
  if ((error = dlerror())) {
    fprintf(stderr, "%s\n", error);
    exit(EXIT_FAILURE);
  }
  return function;
}

static void load_alloc_functions() {
  void* handle = dlopen("hw3lib.so", RTLD_NOW);
  if (!handle) {
    fprintf(stderr, "%s\n", dlerror());
    exit(EXIT_FAILURE);
  }

  mm_malloc = try_dlsym(handle, "mm_malloc");
  mm_realloc = try_dlsym(handle, "mm_realloc");
  mm_free = try_dlsym(handle, "mm_free");
}

/* 1. Basic Allocation & Zero-fill Test */
void test_zero_fill() {
  size_t size = 100 * sizeof(int);
  int* data = mm_malloc(size);
  assert(data != NULL);
  
  // Homework requirement: mm_malloc should zero-fill the allocated memory
  for (int i = 0; i < 100; i++) {
    assert(data[i] == 0);
  }
  mm_free(data);
  puts("[PASS] malloc zero-fill test");
}

/* 2. Realloc Data Preservation Test */
void test_realloc() {
  int* data = mm_malloc(10 * sizeof(int));
  assert(data != NULL);
  for (int i = 0; i < 10; i++) {
    data[i] = i * 2;
  }

  // Expand memory
  data = mm_realloc(data, 20 * sizeof(int));
  assert(data != NULL);
  
  // Verify old data is preserved
  for (int i = 0; i < 10; i++) {
    assert(data[i] == i * 2);
  }
  mm_free(data);
  puts("[PASS] realloc data preservation test");
}

/* 3. Edge Cases Test */
void test_edge_cases() {
  // malloc(0) should return NULL
  void* ptr1 = mm_malloc(0);
  assert(ptr1 == NULL);

  // realloc(NULL, size) is equivalent to malloc(size)
  void* ptr2 = mm_realloc(NULL, 100);
  assert(ptr2 != NULL);

  // realloc(ptr, 0) is equivalent to free(ptr) and should return NULL
  void* ptr3 = mm_realloc(ptr2, 0);
  assert(ptr3 == NULL);

  puts("[PASS] edge cases test");
}

/* 4. Multiple Allocations & Fragmentation Test */
#define NUM_ALLOCS 50
void test_multiple_allocs() {
  int* ptrs[NUM_ALLOCS];
  
  // Allocate an array of blocks
  for (int i = 0; i < NUM_ALLOCS; i++) {
    ptrs[i] = mm_malloc(64);
    assert(ptrs[i] != NULL);
    ptrs[i][0] = i; // Write something to ensure it's mapped
  }

  // Free every alternating block to create "holes" (fragmentation)
  for (int i = 0; i < NUM_ALLOCS; i += 2) {
    mm_free(ptrs[i]);
  }

  // Re-allocate to see if allocator handles fragmented free lists correctly
  for (int i = 0; i < NUM_ALLOCS; i += 2) {
    ptrs[i] = mm_malloc(32); // Request smaller or equal sizes
    assert(ptrs[i] != NULL);
  }

  // Clean up remaining blocks
  for (int i = 0; i < NUM_ALLOCS; i++) {
    mm_free(ptrs[i]);
  }
  
  puts("[PASS] multiple allocations & fragmentation test");
}

/* 5. Alignment Test */
void test_alignment() {
  // Pointers returned by malloc should generally be aligned to at least 4 bytes (often 8)
  void* p1 = mm_malloc(1);
  void* p2 = mm_malloc(5);
  void* p3 = mm_malloc(13);
  
  assert(((uintptr_t)p1 % 4) == 0);
  assert(((uintptr_t)p2 % 4) == 0);
  assert(((uintptr_t)p3 % 4) == 0);

  mm_free(p1);
  mm_free(p2);
  mm_free(p3);
  puts("[PASS] alignment test");
}

int main() {
  load_alloc_functions();

  puts("--- Starting Memory Allocator Tests ---");
  
  // Original simple test
  int* data = mm_malloc(sizeof(int));
  assert(data != NULL);
  data[0] = 0x162;
  mm_free(data);
  puts("[PASS] basic malloc/free test");

  // Run new test suites
  test_zero_fill();
  test_realloc();
  test_edge_cases();
  test_multiple_allocs();
  test_alignment();

  puts("--- All tests finished successfully! ---");
  return 0;
}
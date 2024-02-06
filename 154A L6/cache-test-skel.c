/*
Tamer Tamer
Marco Mora
ECE 154A - Fall 2012
Lab 2 - Mystery Caches
Due: 12/3/12, 11:00 pm

Mystery Cache Geometries:
mystery0:
    block size = 64 bytes
    cache size = 4194304 bytes (4MB)
    associativity = 16 
mystery1:
    block size = 4 bytes
    cache size = 4096 bytes (4KB)
    associativity = 1
mystery2:
    block size = 32 bytes
    cache size = 4096 bytes (4KB)
    associativity = 128
*/

#include <stdlib.h>
#include <stdio.h>

#include "mystery-cache.h"

/* 
   Returns the size (in B) of the cache
*/
int get_cache_size(int block_size) {
  /* YOUR CODE GOES HERE */
    addr_t address=0;//initialize base address to 0
    int cache_size = 0; // initialize cache size to 0
    int i;
    flush_cache();
    access_cache(address);
    while(access_cache(address)){ //while accessing the base address hits
        flush_cache();
        cache_size += block_size; //increment cache size by block size
        for (i=0; i<cache_size;i+=block_size){ //fill the cache
            access_cache(i);
        }
    }
    cache_size = cache_size - block_size; //decrement final cache size
    return cache_size;
}



/*
   Returns the associativity of the cache
*/
int get_cache_assoc(int size) {
  /* YOUR CODE GOES HERE */
  int associativity = 0; //initialize assoiativity to 0
  int i;
  addr_t address=0;//initialize address to 0
  flush_cache();
  access_cache(address);
  while(access_cache(address)){ //while accessing the base address hits
        associativity++; //increment associativity by 1
        for (i=0; i<=associativity; i++){ //fill the cache 
            access_cache(i * size);
        }
    }
    return associativity;
}

/*
   Returns the size (in B) of each block in the cache.
*/
int get_block_size() {
  /* YOUR CODE GOES HERE */
  int block_size=1;//initialize block size to 1
  addr_t address=0; //base address is 0
  flush_cache();
  access_cache(address);//accecces base 0
  while(access_cache(address+block_size)){ //keep incrementing block size by 1 until it misses
    block_size++;
  }
  return block_size;
}

int main(void) {
  int size;
  int assoc;
  int block_size;
  
  /* The cache needs to be initialized, but the parameters will be
     ignored by the mystery caches, as they are hard coded.
     You can test your geometry paramter discovery routines by 
     calling cache_init() w/ your own size and block size values. */
  cache_init(0,0);
  
  block_size = get_block_size();
  size = get_cache_size(block_size);
  assoc = get_cache_assoc(size);


  printf("Cache size: %d bytes\n",size);
  printf("Cache associativity: %d\n",assoc);
  printf("Cache block size: %d bytes\n",block_size);
  
  return EXIT_SUCCESS;
}

#include "bubblesort.h"

void bubblesort(uint8_t* arr){
  int swapped = 1, x, y, tmp, index2;
  for (x = 0; (x < BSIZE) && swapped; x++) { 
    swapped = 0;
    for (y = 0; y < BSIZE - x - 1; y++) { 
      index2 = y + 1;
      if (arr[y] > arr[index2]) { 
        tmp = arr[y]; 
        arr[y] = arr[index2]; 
        arr[index2] = tmp;
        swapped = 1;
      } 
    }
  }
}


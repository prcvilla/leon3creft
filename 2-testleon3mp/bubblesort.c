#include "bubblesort.h"

void bubblesort(uint8_t* arr){
	int swapped, x, y, tmp, index2;
	for (x = 0; x < BSIZE; x++) { 
		swapped = 0;
		for (y = 0; y < BSIZE - x - 1; y++) {
			index2 = y + 1;
			if (arr[y] > arr[index2]) {
				tmp = arr[y];
				arr[y] = arr[index2];
				arr[index2] = tmp;
				swapped = 1;
				bubblelog(arr[y], arr[index2], y, index2);
			}
		}
		if(swapped == 0) break;
	}
}



#include "bubblesort.h"

void printarr(uint8_t *arr){
	int i=0;
	printf("|");
	for(i=0;i<BSIZE;i++){
		printf("%3d|", arr[i]);
	}
	printf("\n");
}

int checkarr(uint8_t *arr){
	int i;
	for(i=0;i<BSIZE-1;i++){
		if(arr[i] > arr[i+1]) return -1;
	}
	return 0;
}

void fillArray(uint8_t *arr){
	int i=0;
	for(i=0;i<BSIZE;i++){
		//~ arr[i] = (uint8_t)(rand()%255);
		arr[i] = (uint8_t)(9-i);
	}
}

void bubblesort(uint8_t* arr){
	int swapped = 1, x, y, index2;
	uint8_t tmp;
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


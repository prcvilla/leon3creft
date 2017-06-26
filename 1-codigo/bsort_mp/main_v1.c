#include "leon3.h"
#include "bubblesort.h"
#include "mutex.h"

#include <stdio.h>
#include <stdlib.h>

#define __INLINE __attribute__((always_inline)) 

#define LOCK() mutex_lock()
#define UNLOCK() mutex_unlock()

volatile uint8_t c0Running = 1;
volatile uint32_t C0total = 0;
volatile uint32_t C1total = 0;

void fillArray(uint8_t *arr){
	int i=0;
	for(i=0;i<BSIZE;i++){
		arr[i] = (uint8_t)(rand()%255);
	}
}

int main(){
	if(get_proc_index() == 0){//CPU0
		uint8_t bsArray0[BSIZE];

		start_processor(1);//start CPU1
		__asm("nop");
		__asm("nop");

		c0Running = 1;

		C0total = 0;
		do{
#ifdef DEBUG
			LOCK();
			printf("C0total:%ld\n", C0total);
			UNLOCK();
#endif
			fillArray(bsArray0);
			bubblesort(bsArray0);
			C0total++;
#ifdef DEBUG
			LOCK();
			printf("P0:");
			printarr(bsArray0);
			UNLOCK();
#endif
#ifdef SINGLERUN
			c0Running = 0;
#endif
		}while(c0Running == 1);

#ifdef SINGLERUN
		LOCK();
		printf("P0:");
		printarr(bsArray0);
		UNLOCK();
#endif

		c0Running = 0;
	} //fin CPU0
	else{ //CPU(!=0)
		uint8_t bsArray1[BSIZE];

		C1total = 0;

		do{
#ifdef DEBUG
			LOCK();
			printf("C1total:%ld\n", C1total);
			UNLOCK();
#endif
			fillArray(bsArray1);
			bubblesort(bsArray1);
			C1total++;
#ifdef DEBUG
			LOCK();
			printf("P1:");
			printarr(bsArray1);
			UNLOCK();
#endif
		}while(c0Running == 1);

#ifdef SINGLERUN
		LOCK();
		printf("P1:");
		printarr(bsArray1);
		UNLOCK();
#endif
	} //fin CPU(!=0)

	LOCK();
	printf("FIN\n");
	UNLOCK();

#ifdef SINGLERUN
	while(1);
#endif

	return 0;
}

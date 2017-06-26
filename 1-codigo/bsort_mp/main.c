#include "leon3.h"
#include "bubblesort.h"
#include "mutex.h"
#include "gpio.h"

#include <stdio.h>
#include <stdlib.h>

#define __INLINE __attribute__((always_inline)) 

#define LOCK() mutex_lock()
#define UNLOCK() mutex_unlock()
#define FILLING 6
#define SORTING 7
#define NOTSORTED 8

volatile uint8_t c0Running = 1;
volatile uint32_t C0total = 0;
volatile uint32_t C1total = 0;
uint8_t bsArray0[BSIZE];

int main(){
#ifdef GPIODBG
	gpio_set_outputs();
	gpio_write(0x0);
#endif
	if(get_proc_index() == 0){//CPU0
		
#ifndef SINGLEPROC
		start_processor(1);//start CPU1
		__asm("nop");
		__asm("nop");
#endif
		c0Running = 1;

		C0total = 0;
		do{
#ifdef GPIODBG
			gpio_setpin(FILLING);
#endif
			fillArray(bsArray0);
#ifdef GPIODBG
			gpio_clearpin(FILLING);
			gpio_setpin(SORTING);
#endif
			bubblesort(bsArray0);
#ifdef GPIODBG
			gpio_clearpin(SORTING);
#endif
			C0total++;
		}while(checkarr(bsArray0) == 0);

#ifdef GPIODBG
		gpio_setpin(NOTSORTED);
#else
		LOCK();
		printf("P0: array not sorted! - ");
		printarr(bsArray0);
		UNLOCK();
#endif
		c0Running = 0;
	} //fin CPU0
	else{ //CPU(!=0)
		uint8_t bsArray1[BSIZE];

		C1total = 0;

		do{
			fillArray(bsArray1);
			bubblesort(bsArray1);
			C1total++;
		}while(checkarr(bsArray1) == 0);

#ifndef GPIODBG
		LOCK();
		printf("P1: array not sorted! - ");
		printarr(bsArray1);
		UNLOCK();
#endif
	} //fin CPU(!=0)

#ifndef GPIODBG
	LOCK();
	printf("FIN\n");
	UNLOCK();
#endif

	return 0;
}

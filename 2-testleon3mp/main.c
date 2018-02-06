#include "leon3.h"
#include "testbubblesort.h"
#include <stdlib.h>
#include <stdint.h>

volatile uint32_t Seed=0x12345678;

int main(void){
	if(get_proc_index() == 0){//CPU0
		srand(Seed);
		rand();
		initializeTestData();
		runTestAlgorithm();
	}
	return 0;
}

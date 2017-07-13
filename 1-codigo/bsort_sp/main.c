#include <stdio.h>
#include "gpio.h"
#include "bubblesort.h"

#define CALC 6
#define FIN 7
#define ERR 8

volatile int i=0;
uint8_t bsArray0[BSIZE];

int main(){
	int i;
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);
	while(i<10){
		GPIO_SETPIN(CALC);
		
		fillArray(bsArray0);
		bubblesort(bsArray0);

		if(checkarr(bsArray0)!=0){
			GPIO_SETPIN(ERR);
		}
		GPIO_WRITE(0x0);
		i++;
	}
	GPIO_SETPIN(FIN);
	return 0;
}

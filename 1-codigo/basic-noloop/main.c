#include <stdio.h>
#include "gpio.h"

#define __INLINE __attribute__((always_inline)) 

#define CALC 6
#define FIN 7
#define ERR 8

volatile int x,a=CALC;

int main(){
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);

	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	GPIO_SETPIN(CALC);
	x=a;
	GPIO_CLEARPIN(x);
	
	GPIO_SETPIN(FIN);
	return 0;
}

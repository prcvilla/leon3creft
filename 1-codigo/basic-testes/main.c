#include "gpio.h"

//#include <stdio.h>

#define __INLINE __attribute__((always_inline)) 

#define CALC 6
#define FIN 7
#define ERR 8

volatile int x,a=9,b=8,c=4,d=5,i=0;

int main(){
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);
	2+3;
	3+2;
	a = 6;
	b = a + 1;
	GPIO_SETPIN(CALC);
	GPIO_WRITE(0x0);
	GPIO_SETPIN(FIN);

/*
	while(i<10){
		GPIO_SETPIN(CALC);
//		x=(a+b)-(c+d);
		x=a;
//		if(x!=8){GPIO_SETPIN(ERR);}
		if(x!=9){GPIO_SETPIN(ERR);}
//		GPIO_CLEARPIN(CALC);
		GPIO_WRITE(0x0);
		i++;
	}
	GPIO_SETPIN(FIN);
*/	
	return 0;
}

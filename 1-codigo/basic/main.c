#include <stdio.h>
#include "gpio.h"

#define CALC 6
#define FIN 7
#define ERR 8

volatile int x,a=9,b=8,c=4,d=5,i=0;

int main(){
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);
	while(i<500){
		GPIO_SETPIN(CALC);
		x=(a+b)-(c+d);
		if(x!=8){GPIO_SETPIN(ERR);}
		GPIO_WRITE(0x0);
		i++;
	}
	GPIO_SETPIN(FIN);
	return 0;
}

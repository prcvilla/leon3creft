#include <stdio.h>
#include "gpio.h"

#define CALC 6
#define FIN 7
#define ERR 8

int checksum(const char*);

int checksum(const char *s) {
	int c = 0;

	while(*s)
		c ^= *s++;

	return c;
}

volatile int i=0;
//correct checksum = 0x76 = 118 decimal
const char *nmeamsg = "GPGGA,092750.000,5321.6802,N,00630.3372,W,1,8,1.03,61.7,M,55.2,M,,";

int main(void) {
	int chks;
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);
	
	while(i<IRUNS){
		GPIO_SETPIN(CALC);
		chks=checksum(nmeamsg);

		if(chks!=118) {
			GPIO_SETPIN(ERR);
		}

		GPIO_WRITE(0x0);
		i++;
	}
	GPIO_SETPIN(FIN);
	return 0;
}

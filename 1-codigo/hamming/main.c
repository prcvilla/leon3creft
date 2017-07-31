#include <stdio.h>
#include <string.h>
#include "gpio.h"

#define CALC 6
#define FIN 7
#define ERR 8

/*Code Generator Matrix*/
const unsigned char G[7][4] = {
	{1,1,0,1},
	{1,0,1,1},
	{1,0,0,0},
	{0,1,1,1},
	{0,1,0,0},
	{0,0,1,0},
	{0,0,0,1}
};

/*Data to be transmitted*/
const unsigned char data[4] = {1,0,1,0};

/*Encoded msg*/
unsigned char msg[7] = {0,0,0,0,0,0,0};

/*Verify*/
unsigned char verify[7] = {1,0,1,1,0,1,0};

void encode(unsigned char*,const unsigned char*);

void encode(unsigned char *encoded, const unsigned char *dt){
	int _i,_j;
	for(_i=0;_i<7;_i++){
		for(_j=0;_j<4;_j++){
			encoded[_i] += G[_i][_j] & dt[_j]; /*it is possible to either AND it or multiply*/
		}
		encoded[_i]&=1;
	}
}

volatile int i=0;

int main(void){
	GPIO_SET_OUTPUTS;
	GPIO_WRITE(0x0);

	while(i<IRUNS) {
		GPIO_SETPIN(CALC);
		encode(msg,data);

		if(memcmp(msg, verify, 7)!=0) {
			GPIO_SETPIN(ERR);
		}

		GPIO_WRITE(0x0);
		i++;
	}
	GPIO_SETPIN(FIN);
	return 0;
}

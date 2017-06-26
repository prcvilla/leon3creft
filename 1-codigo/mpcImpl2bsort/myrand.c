#include "myrand.h"

static uint16_t lfsr = 0xACE1u;

void mysrand(uint16_t seed){
	lfsr = seed;
}

uint16_t myrand(){
	uint16_t bit  = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1;
	return lfsr =  (lfsr >> 1) | (bit << 15);
}
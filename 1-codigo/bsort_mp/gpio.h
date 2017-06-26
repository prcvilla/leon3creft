#include <stdio.h>
#include <stdint.h>

#ifndef __GPIO_H__
#define __GPIO_H__

#define GPIO_IN *((volatile unsigned int *)0x80000800)
#define GPIO_OUT *((volatile unsigned int *)0x80000804)
#define GPIO_DIR *((volatile unsigned int *)0x80000808)

void gpio_set_outputs(void){
	// Enable all Outputs
	GPIO_DIR = 0xffffffff;
}

void gpio_write(int val){
	GPIO_OUT = val;
}

void gpio_setpin(int pin){
	GPIO_OUT |= (1<<pin);
}

void gpio_clearpin(int pin){
	GPIO_OUT &= ~(1<<pin);
}

uint32_t gpio_read(void){
	return (int32_t)GPIO_IN;
}

#endif

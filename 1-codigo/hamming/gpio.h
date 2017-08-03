#include <stdio.h>
#include <stdint.h>

#ifndef __GPIO_H__
#define __GPIO_H__

#define GPIO_IN *((volatile unsigned int *)0x80000800)
#define GPIO_OUT *((volatile unsigned int *)0x80000804)
#define GPIO_DIR *((volatile unsigned int *)0x80000808)


#define GPIO_SET_OUTPUTS GPIO_DIR=0xffffffff

#define GPIO_WRITE(_v) GPIO_OUT=_v

#define GPIO_SETPIN(_p) GPIO_OUT|=(1<<_p)

#define GPIO_CLEARPIN(_p) GPIO_OUT&=~(1<<_p)

#define GPIO_READ (int32_t)GPIO_IN

#endif

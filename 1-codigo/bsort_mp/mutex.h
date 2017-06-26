#include <stdio.h>
#include <stdint.h>

#ifndef __MUTEX_H__
#define __MUTEX_H__

extern uint8_t mlock;

uint8_t testandset(uint8_t *lock);

void mutex_lock(void);

void mutex_unlock(void);

#endif

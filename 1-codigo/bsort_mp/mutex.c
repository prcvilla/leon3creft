#include "mutex.h"

uint8_t mlock = 0;

void mutex_lock(void){
	//printf("lock: %x\n", mlock);
	while(testandset(&mlock)==0xff);
}
void mutex_unlock(void){
	//printf("unlock: %x\n", mlock);
	mlock=0;
}


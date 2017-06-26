#include "fix.h"
#include "mpc.h"
#include "myrand.h"

#include "leon3.h"
#include "bubblesort.h"

#define __INLINE __attribute__((always_inline)) 

volatile uint32_t* ireg = (uint32_t*)0x80000500;

void randFix(fix_t* v){
    uint32_t rnd = myrand();
    int sng = rnd&1;
    rnd <<= 3;
    v->raw = rnd;
    v->sign = sng;
}

void randFix2(fix_t* v){
    uint32_t rnd = myrand();
    int sng = rnd&1;
    rnd <<= 1;
    v->raw = rnd;
    v->sign = sng;
}

uint8_t bsArray[BSIZE];
volatile uint8_t c0Running = 1;
volatile uint32_t C1total = 0;


int main(){
    if(get_proc_index() == 0){//CPU0
        c0Running = 1;
        c0Running = 1;
            fix_t x[3] = {zero, zero, zero};
            fix_t ref, u=zero;
            int i;
            while(ireg[0] != 0x80000000);
            ref.raw = ireg[1];
            int count = ireg[2];
            mysrand(ireg[3]);
            myrand();
            
            if(ireg[4])
                start_processor(1);//start CPU1
            __asm("nop");
            __asm("nop");
            
            for(i=0;i<count;i++){
                fix_t du;
                ctrSig(x, &u, &ref, &du);
                randFix(&ref);
                randFix2(&u);
                randFix(&(x[0]));
                randFix(&(x[1]));
                randFix(&(x[2]));
            }
        c0Running = 0;
        c0Running = 0;
    }
    else{
        int i;
        uint16_t lfsr = ireg[3];
        C1total = 0;
        while(c0Running == 1){
            for(i=0;i<BSIZE;i++){
                uint16_t bit  = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1;
                lfsr =  (lfsr >> 1) | (bit << 15);
                bsArray[i] = lfsr;
            }
            bubblesort(bsArray);
            C1total++;
        }
    }
}


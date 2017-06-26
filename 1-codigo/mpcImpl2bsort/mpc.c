#include "mpc.h"
#include <stdbool.h>

#include "mpccnts.h"


void compwdP2(fix_t cs[VARSN+1], fix_t* vars[VARSN], fix_t* wdP){
    fix_t t1;
    int i;
	*wdP = cs[VARSN];
	for(i=0;i<VARSN;i++){
        mul(&cs[i], vars[i], &t1);
        add(wdP, &t1, wdP);
	}
}

void ctrSig(fix_t* st, fix_t* u, fix_t* ref, fix_t* du){
    int i, o;
    fix_t olambda[LAMBDASN];
    for(i=0;i<LAMBDASN;i++){
        lambda[i] = zero;
    }
    for(i=0;i<STATEN;i++){
        vars[LAMBDASN+i] = &st[i];
    }
    vars[LAMBDASN+STATEN] = ref;
    vars[LAMBDASN+STATEN+1] = u;
    fix_t w;
    for(i=0;i<25;i++){
			for(o=0;o<LAMBDASN;o++){
				olambda[o] = lambda[o];}
			for(o=0;o<LAMBDASN;o++){
                compwdP2(lcnts[o], vars, &w);
                if(w.sign==0) lambda[o] = w;
			}
			fix_t al = zero, t;
			fix_t tol = {.integer=0, .fraction=21, .sign=0};
			for(o=0;o<LAMBDASN;o++){
				sub(&lambda[o], &olambda[o], &t);
				t.sign = 0;
				add(&al, &t, &al);
			}
			if(fixIsLessOrEqual(&al, &tol))
				break;
    }
    #ifdef DEBUG
        printf("total iter: %d\n", i);
    #endif
    compwdP2(eta2cnts, vars, du);
    i=0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
}
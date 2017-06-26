#include "fix.h"
#include "mpc.h"


volatile uint32_t* ireg = (uint32_t*)0x80000500;

fix_t sc1 = {.integer=0, .fraction=59415, .sign=0};
fix_t sc2 = {.integer=0, .fraction=33361, .sign=0};
fix_t sc3 = {.integer=0, .fraction=16273, .sign=0};
fix_t sc4 = {.integer=0, .fraction=1962, .sign=1};
fix_t sc5 = {.integer=0, .fraction=468, .sign=1};
fix_t sc6 = {.integer=0, .fraction=7720, .sign=0};
fix_t sc7 = {.integer=1, .fraction=0, .sign=0};

fix_t umax = {.integer=3, .fraction=0, .sign=0};
fix_t umin = {.integer=3, .fraction=0, .sign=1};

void saturate(fix_t* u, fix_t* du){
    fix_t nu;
    add(u, du, &nu);
    if(!fixIsLessOrEqual(&nu, &umax)){
        sub(&umax, u, du);
    }
    if(!fixIsGreaterOrEqual(&nu, &umin)){
        sub(&umin, u, du);
    }
}

void system(fix_t x[3], fix_t* du, fix_t nx[3]){
		fix_t t1, t2;
		mul(&sc1, &(x[0]), &t1);
		mul(&sc2, &(x[1]), &t2);
		add(&t1, &t2, &(nx[0]));
		mul(&sc3, du, &t1);
		add(&(nx[0]), &t1, &(nx[0]));
		
		mul(&sc4, &(x[0]), &t1);
		mul(&sc5, &(x[1]), &t2);
		add(&t1, &t2, &(nx[1]));
		mul(&sc6, du, &t1);
		add(&(nx[1]), &t1, &(nx[1]));
		
		mul(&sc1, &(x[0]), &t1);
		mul(&sc2, &(x[1]), &t2);
		add(&t1, &t2, &(nx[2]));
		mul(&sc3, du, &t1);
		add(&(nx[2]), &t1, &(nx[2]));
		mul(&sc7, &(x[2]), &t1);
		add(&(nx[2]), &t1, &(nx[2]));
}

int main(){
    fix_t s0 = {.integer = 8, .fraction=0, .sign=0};
    fix_t s1 = {.integer = 8, .fraction=0, .sign=0};
    fix_t s2 = {.integer = 8, .fraction=0, .sign=0};
    fix_t x1[3] = {zero,zero,zero}, x2[3];
    fix_t* x, *tx;
    x = x1;
    tx = x2;
    fix_t u = zero;
    int i;
    uint32_t refint = 8;
    int count = 100;
    uint8_t sgn = 0;
    for(i=0;i<count;i++){
		fix_t ref = {.integer = (uint16_t)refint, .fraction=0, .sign=sgn};
        fix_t du;
        ctrSig(x, &u, &ref, &du);
        saturate(&u, &du);
        system(x, &du, tx);
        add(&u, &du, &u);
        printf("%f %f\n", FX2F(u), FX2F(du));
        fix_t* temp = x;
        x = tx;
        tx = temp;
    }
    printf("%f\n", FX2F(x[2]));
}
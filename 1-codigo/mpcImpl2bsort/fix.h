#ifndef FIX_H
#define FIX_H

#include <stdint.h>
#include <stdbool.h>

#define bits 16
#define mask ((1 << bits) - 1)
#define F2F(a) (a*(1<<bits))
#define FX2F(a) ((((float)(a).integer)+((float)(a).fraction)/65536)*((a).sign?-1:1))

typedef union{
	struct{
#ifdef LEON
		uint16_t sign : 1;
		uint16_t integer : 15;
		uint16_t fraction;
#else
		uint16_t fraction;
		uint16_t integer : 15;
		uint16_t sign : 1;
#endif
	};
	uint32_t raw;
} fix_t;

extern fix_t zero;

void mul(fix_t* a, fix_t* b, fix_t* r);
//void div(fix_t* a, fix_t* b, fix_t* r);
void add(fix_t* a, fix_t* b, fix_t* r);
void sub(fix_t* a, fix_t* b, fix_t* r);
void fixAbs(fix_t* x, fix_t* r);
int fixCompare(fix_t* a, fix_t* b);
bool fixIsGreaterOrEqual(fix_t* a, fix_t* b);
bool fixIsLessOrEqual(fix_t* a, fix_t* b);

#endif

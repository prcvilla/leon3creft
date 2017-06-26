#include <stdint.h>
//#include "mymath.h"
#include "fix.h"

#ifdef USEASMMUL
extern uint64_t myumul(uint32_t a, uint32_t b);
#endif


void mul(fix_t* a, fix_t* b, fix_t* r){
#ifdef USEBUILTIN
	uint64_t v = ((uint64_t)(a->raw) & 0x7FFFFFFF)* ((uint64_t)(b->raw) & 0x7FFFFFFF);
#elif USEASMMUL
	uint64_t v = myumul((a->raw) & 0x7FFFFFFF, (b->raw) & 0x7FFFFFFF);
#else
	uint64_t v = uint32mul((a->raw) & 0x7FFFFFFF, (b->raw) & 0x7FFFFFFF);
#endif
	v >>= bits;
	r->raw = v & 0x7FFFFFFF;
	r->sign = (a->sign) ^ (b->sign);
}

/*void div(fix_t* a, fix_t* b, fix_t* r){
	uint64_t Q, R;
	uint64div(((uint64_t)((a->raw) & 0x7FFFFFFF))<<bits, (b->raw) & 0x7FFFFFFF, &Q, &R);
	r->raw = Q & 0x7FFFFFFF;
	r->sign = (a->sign) ^ (b->sign);
}*/

#define FIXSUM(OP, a, b, r) do{\
    fix_t res;\
	int64_t araw[2];\
	araw[0] = (a->raw) & 0x7FFFFFFF;\
	araw[1] = -araw[0];\
	int64_t braw[2]; \
	braw[0] = (b->raw) & 0x7FFFFFFF;\
	braw[1] = -braw[0];\
	int64_t resraw = araw[a->sign] OP braw[b->sign];\
	int sign = ((uint64_t)resraw)>>63;\
	int64_t nraw[2];\
	nraw[0] = resraw;\
	nraw[1] = -resraw;\
	r->raw = ((uint32_t)nraw[sign]) & 0x7FFFFFFF;\
	r->sign = sign;\
	} while(0)

void add(fix_t* a, fix_t* b, fix_t* r){
	FIXSUM(+, a, b, r);
}

void sub(fix_t* a, fix_t* b, fix_t* r){
	FIXSUM(-, a, b, r);
}
//1 if a > b
//-1 if a < b
//0 if a == b
int fixCompare(fix_t* a, fix_t* b){
	fix_t d;
	sub(a, b, &d);
	if(d.raw == 0)
		return 0;
	else if(d.sign == 1)
		return -1;
	else
		return 1;
}

void fixAbs(fix_t* x, fix_t* r){
    r->raw = x->raw;
    r->sign = 0;
}

//a >= b
bool fixIsGreaterOrEqual(fix_t* a, fix_t* b){
    fix_t d;
	sub(a, b, &d);
	return !d.sign;
}

//a <= b
bool fixIsLessOrEqual(fix_t* a, fix_t* b){
    fix_t d;
	sub(b, a, &d);
	return !d.sign;
}

fix_t zero = {.integer = 0, .fraction=0, .sign=0};
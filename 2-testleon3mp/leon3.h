#ifndef LEON3_H
#define LEON3_H

void disable_cache(void) {
  /*asi 2*/
  __asm__ volatile ("lda [%%g0] 2, %%l1\n\t"  \
                    "set 0x00000f, %%l2\n\t"  \
                    "andn  %%l2, %%l1, %%l2\n\t" \
                    "sta %%l2, [%%g0] 2\n\t"  \
                    :  : : "l1", "l2");	
};

void enable_traps(void){
  __asm__ volatile ("set 0x10e0, %l2\n\t" \
                    "wr %l2, %psr\n\t"
  );
}

void set_tbr(void){
  __asm__ volatile ("set  0x40000000, %l2\n\t" \
                    "wr %l2, %tbr\n\t" \
                    "nop\n\t" \
                    "nop\n\t" \
                    "nop\n\t"
  );
}

void powerdown(void) {
  __asm__ volatile ("wr %g0, %asr19\n\t");	
};

#define MPCTRL_STATUS_REGISTER *((volatile int* volatile)0x80000210)

__inline__ unsigned long get_psr(void) {
	unsigned int retval;
	__asm__ __volatile__("rd %%psr, %0\n\t" :
			     "=r" (retval) :);
	return (retval);
}

__inline__ unsigned long get_wim(void) {
	unsigned int retval;
	__asm__ __volatile__("rd %%wim, %0\n\t" :
			     "=r" (retval) :);
	return (retval);
}

__inline__ unsigned long get_tbr(void) {
	unsigned int retval;
	__asm__ __volatile__("rd %%tbr, %0\n\t" :
			     "=r" (retval) :);
	return (retval);
}

__inline__ unsigned long get_asr17(void) {
	unsigned int retval;
	__asm__ __volatile__("rd %%asr17, %0\n\t" :
			     "=r" (retval) :);
	return (retval);
}

unsigned int get_proc_index(void){
  return get_asr17() >> 28;
}


void stop_processor(int proc) {
  proc &= 15;
  MPCTRL_STATUS_REGISTER |= (1<<proc);
}

void start_processor(int proc){
  proc &= 15;
  MPCTRL_STATUS_REGISTER &= ~(1<<proc);
}

#endif
#include <sched.h>
#include <bsp.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <rtems.h>

static inline uint32_t get_ticks_per_second( void ) {
	rtems_interval ticks_per_second;
	(void) rtems_clock_get( RTEMS_CLOCK_GET_TICKS_PER_SECOND, &ticks_per_second );  return ticks_per_second;
}

// Global Variables
int data;
sem_t empty, full;
uint32_t ticks;

// Structs for task priorities
struct sched_param param;
pthread_attr_t attr;

//Task Prototypes
void *t_task(void *);
void *t_Producer(void *);
void *t_Consumer(void *);

void *POSIX_Init(void) {
	int i;

	pthread_t dummy[4];
	pthread_t t_prod, t_cons;


	pthread_attr_init(&attr);
	pthread_attr_setschedpolicy(&attr, SCHED_FIFO);

	sem_init(&empty, 1, 1);  /* sem empty = 1 */
	sem_init(&full, 1, 0);   /* sem full = 0  */

	printf("INFO: found %d processors.\n", (int)rtems_get_processor_count());

	ticks=get_ticks_per_second();

	printf("%d ticks per second...\n", (int)ticks);

	sleep(1);


	for(i=0;i<4;i++){
		int *arg = malloc(sizeof(*arg));
		*arg=i;
		pthread_create(&dummy[i], NULL, t_task, arg);
		printf("Thread %d created...\n",i);
		rtems_task_wake_after(ticks);
	}

	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
	pthread_attr_setschedparam(&attr, &param);
	if( pthread_create(&t_prod, &attr, t_Producer, NULL) ||
		pthread_setschedparam(t_prod, SCHED_FIFO, &param) ){
		printf("error on creating producer...\n");
		exit(1);
	}

	param.sched_priority = sched_get_priority_max(SCHED_FIFO)-1;
	pthread_attr_setschedparam(&attr, &param);
	if( pthread_create(&t_cons, &attr, t_Producer, NULL) ||
		pthread_setschedparam(t_cons, SCHED_FIFO, &param) ){
		printf("error on creating consumer...\n");
		exit(1);
	}

	for(i=0;i<4;i++){
		pthread_join(dummy[i], NULL);
		printf("Thread %d started...\n",i);
		rtems_task_wake_after(100);
	}
	pthread_join(t_prod, NULL);
	pthread_join(t_cons, NULL);

	printf("main done, fuck this shit...I'm out.\n");

	exit(0);
}

void *t_task(void *arg) {
	//int status;
	int tid = *((int *) arg);
	int curr_cpu = (int)rtems_get_current_processor();
	printf("CPU %d running taskid %d\n", curr_cpu, tid);
	while(1){
		curr_cpu = (int)rtems_get_current_processor();
		printf("cpu: %d | tid: %d\n", curr_cpu, tid);
		rtems_task_wake_after(ticks*(tid+1));
	}
}

void *t_Producer(void *unused) {
	int produced=0;
	int curr_cpu = (int)rtems_get_current_processor();
	printf("Producer created\n");
	for(;;){
		sem_wait(&empty);
		curr_cpu = (int)rtems_get_current_processor();
		data = produced;
		produced++;
		printf("CPU: %d - Produced: %d\n", curr_cpu, data);
		sem_post(&full);
		rtems_task_wake_after(ticks*2);
	}
}

void *t_Consumer(void *unused) {
	int curr_cpu = (int)rtems_get_current_processor();
	printf("Consumer created\n");
	for(;;){
		sem_wait(&full);
		curr_cpu = (int)rtems_get_current_processor();
		printf("CPU: %d - Consumed: %d\n", curr_cpu, data);
		sem_post(&empty);
	}
}

#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER

#define CONFIGURE_SMP_APPLICATION
#define CONFIGURE_SMP_MAXIMUM_PROCESSORS 2

#define CONFIGURE_MAXIMUM_POSIX_THREADS              10
#define CONFIGURE_MAXIMUM_POSIX_CONDITION_VARIABLES  10
#define CONFIGURE_MAXIMUM_POSIX_MUTEXES              10
#define CONFIGURE_POSIX_INIT_THREAD_TABLE

#define CONFIGURE_INIT

#include <rtems/confdefs.h>

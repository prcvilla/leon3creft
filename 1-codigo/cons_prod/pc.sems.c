/* a simple producer/consumer using semaphores and threads

   usage on Solaris:
     gcc thisfile.c -lpthread -lposix4
     a.out numIters

*/
 
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#define SHARED 0
#define N 11

#define BUFF_SZ 10

void *Producer(void *);  /* the two threads */
void *Consumer(void *);

sem_t empty, full, mutex;    /* the global semaphores */
int data[BUFF_SZ];             /* shared buffer         */
int next_ins=0, next_rem=0;

/* main() -- read command line and create threads, then
             print result when the threads have quit */

int main(int argc, char *argv[]) {
  /* thread ids and attributes */
  pthread_t pid, cid;  

  sem_init(&empty, SHARED, BUFF_SZ);  /* sem empty = 1 */
  sem_init(&full, SHARED, 0);   /* sem full = 0  */
  sem_init(&mutex, SHARED, 1);   /* sem mutex  = 1 */

  printf("main started\n");
  pthread_create(&pid, NULL, Producer, NULL);
  pthread_create(&cid, NULL, Consumer, NULL);
  pthread_join(pid, NULL);
  pthread_join(cid, NULL);
  printf("main done\n");
  return 0;
}

/* deposit 1, ..., numIters into the data buffer */
void *Producer(void *arg) {
  int produced;
  printf("Producer created\n");
  for (produced = 0; produced < N; produced++) {
    sem_wait(&empty);
	sem_wait(&mutex);
    printf("produced %d\n",produced);
    data[next_ins] = produced;
	next_ins = (next_ins + 1) % BUFF_SZ;
    sem_post(&mutex);
    sem_post(&full);

  }
  return NULL;
}

/* fetch numIters items from the buffer and sum them */
void *Consumer(void *arg) {
  int total = 0, consumed;
  printf("Consumer created\n");
  for (consumed = 0; consumed < N; consumed++) {
    sem_wait(&full);
	sem_wait(&mutex);
    printf("consumed %d\n",data[next_rem]);
    total = total + data[next_rem];
	next_rem = (next_rem + 1) % BUFF_SZ;
    sem_post(&mutex);
    sem_post(&empty);
  }
  printf("for %d iterations, the total is %d\n", N, total);
  return NULL;
}

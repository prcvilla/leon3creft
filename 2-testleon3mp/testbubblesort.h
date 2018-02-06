#ifndef TESTBUBBLESORT_H
#define TESTBUBBLESORT_H

#include "bubblesort.h"
#include <stdlib.h>
#include <stdint.h>

typedef struct{
  uint8_t data1;
  uint8_t data2;
  int from;
  int to;
} TData_t;

TData_t TData;
uint8_t DataToSort[BSIZE];

void bubblelog(uint8_t, uint8_t, int, int);

inline void initializeTestData(void);

inline void runTestAlgorithm(void);

#endif

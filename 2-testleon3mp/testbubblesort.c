#include "testbubblesort.h"

void bubblelog(uint8_t data1, uint8_t data2, int from, int to){
  TData.data1 = data1;
  TData.data2 = data2;
  TData.from = from;
  TData.to = to;
}

inline void initializeTestData(){
  int i;
  for(i=0;i<BSIZE;i++){
    DataToSort[i] = (((uint64_t)rand())*0xFF)/RAND_MAX;
    bubblelog(DataToSort[i], DataToSort[i], i, i);
  }
}

inline void runTestAlgorithm(){
  bubblesort(DataToSort);
}

#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void bubSort(int inArr[], int size);

int main(int argc, char **argv) {

	
	
	int numInts;
	int i = 0;
	clock_t start, end;
	double cpu_time;
	
	//define files
	FILE *myOut = fopen("problem1.out", "w");
	FILE *myin;
	FILE *myTime = fopen("problem1a.out", "w");


	if(argc == 1){
	//if no input given not defined then do this
		myin = fopen("problem1.in", "r");
		fscanf(myin, "%d", &numInts);
		
	}	
	else{
		
		srand(0);
		numInts = atoi(argv[1]);

	}

	int list2sort[numInts];
	if(argc == 1){
		//if argc == 1 (meaning there are no arguments) read file and populate array
		int *arrp = list2sort;
		for(i = 0; i < numInts; i++){
			fscanf(myin, "%d", arrp);
			arrp = arrp+1;
		}	
	}
	else{
		//numints set by program so generate that many random numbers
		for(i = 0; i < numInts; i++){
			list2sort[i] = rand();
		}
	}
	start = clock();
	bubSort(list2sort, numInts);
	end = clock();
	cpu_time = ((double)(end-start)) / CLOCKS_PER_SEC;
	fprintf(myTime, "%d \n", numInts);
	fprintf(myTime, "%lf \n", cpu_time*1000);
	printf("%d \n", numInts);
	printf("%lf \n", cpu_time*1000);

	for(i = 0; i < numInts; i++){
		//printf("%d \n", list2sort[i]);
		fprintf(myOut, "%d \n", list2sort[i]);
	}
	//fclose(myOut);
	//fclose(myin);
	return 0;
}

void bubSort(int inArr[], int size){

	int i;
	int j;
	int temp;
	//for each iteration of outer loop, the largest unsorted number will be pushed back to the end of the array until everything is in order
	for(i = 0; i < size-1; i++){
		for(j = 0; j < size-1-i; j++){
			if(inArr[j] > inArr[j+1]){
				temp = inArr[j+1];
				inArr[j+1] = inArr[j];
				inArr[j] = temp;
			}
		}
	}

}



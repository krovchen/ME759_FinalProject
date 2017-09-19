#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int compfun(const void *a, const void *b);

int main(int argc, char **argv) {

	
	
	int numInts;
	int i = 0;
	clock_t start, end;
	double cpu_time;
	
	
	FILE *myOut = fopen("problem1.out", "w");
	FILE *myin;
	FILE *myTime = fopen("problem1b.out", "w");

	//printf("%d \n", argc);
	//printf("%d \n", atoi(argv[1]));

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
		int *arrp = list2sort;
		for(i = 0; i < numInts; i++){
			fscanf(myin, "%d", arrp);
			//printf("%d \n", list2sort[i]);
			arrp = arrp+1;
		}	
	}
	else{
	
		for(i = 0; i < numInts; i++){
			list2sort[i] = rand();
			//printf("%d \n", list2sort[i]);
		}
	}
	start = clock();
	qsort(list2sort, numInts, sizeof(int), compfun);
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



int compfun(const void *a, const void *b){
	return (*(int*)a - *(int*)b);
}



#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void bubSort(int inArr[], int size);
int compfun(const void *a, const void *b);

int main(int argc, char **argv) {

	
	
	int numInts;
	int i = 0;
	int ab = 0;
	clock_t start, end;
	double bub_time;
	double qs_time;
	char fstr[] = "problem1_10.in";
	
	
	FILE *myin;
	FILE *myTimeFile = fopen("problem1c.out", "w");
	fprintf(myTimeFile, "%s\n", "---- bub sort timing ----");
	printf("%s\n", "---- bub sort timing ----");
	for(ab = 10; ab < 20; ab++){	
	
	//if no input given not defined then do this
		myin = fopen(fstr, "r");
		fscanf(myin, "%d", &numInts);

		int list2sort[numInts];

		int *arrp = list2sort;
		for(i = 0; i < numInts; i++){
			fscanf(myin, "%d", arrp);
			arrp = arrp+1;
		}	

		start = clock();
		bubSort(list2sort, numInts);
		end = clock();
		bub_time = ((double)(end-start)) / CLOCKS_PER_SEC;
		fprintf(myTimeFile, "%d \n", numInts);
		fprintf(myTimeFile, "%lf \n", bub_time*1000);
		printf("%d \t", numInts);
		printf("%lf \n", bub_time*1000);
		fclose(myin);
		fstr[10] = fstr[10]+1;

	}
	fprintf(myTimeFile, "%s\n", "---- qsort timing ----");
	printf("%s\n", "---- qsort timing ----");
	fstr[10] = '0';
	for(ab = 10; ab < 20; ab++){
	
		myin = fopen(fstr, "r");
		fscanf(myin, "%d", &numInts);

		int list2sort[numInts];

		int *arrp = list2sort;
		for(i = 0; i < numInts; i++){
			fscanf(myin, "%d", arrp);
			arrp = arrp+1;
		}	
		start = clock();
		qsort(list2sort, numInts, sizeof(int), compfun);
		end = clock();
		qs_time = ((double)(end-start)) / CLOCKS_PER_SEC;
		fprintf(myTimeFile, "%d \n", numInts);
		fprintf(myTimeFile, "%lf \n", qs_time*1000);
		printf("%d \t", numInts);
		printf("%lf \n", qs_time*1000);
		fclose(myin);
		fstr[10] = fstr[10]+1;
	}
	return 0;
}

void bubSort(int inArr[], int size){

	int i;
	int j;
	int temp;
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


int compfun(const void *a, const void *b){
	return (*(int*)a - *(int*)b);
}

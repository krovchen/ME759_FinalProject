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
	//name of file to read
	char fstr[] = "problem1_10.in";
	
	
	FILE *myin;
	FILE *myTimeFile = fopen("problem1c.out", "w");

	//this will scan in the array and run qsort and time it
	fprintf(myTimeFile, "%s\n", "---- qsort timing ----");
	printf("%s\n", "---- qsort timing ----");
	for(ab = 10; ab < 20; ab++){
	
		myin = fopen(fstr, "r");
		fscanf(myin, "%d", &numInts);

		int list2sort_q[numInts];

		int *arrp1 = list2sort_q;
		for(i = 0; i < numInts; i++){
			fscanf(myin, "%d", arrp1);
			arrp1 = arrp1+1;
		}	
		start = clock();
		qsort(list2sort_q, numInts, sizeof(int), compfun);
		end = clock();
		qs_time = ((double)(end-start)) / CLOCKS_PER_SEC;
		fprintf(myTimeFile, "%d \n", numInts);
		fprintf(myTimeFile, "%lf \n", qs_time*1000);
		printf("%d \t", numInts);
		printf("%lf \n", qs_time*1000);
		fclose(myin);
		//this iterates through the filename, making problem1_10.in to problem1_11.in and so on
		fstr[10] = fstr[10]+1;
	}




	//this will scan in the array, run bub sort and time it
	
	//this line resets the filename to problem1_10.in 
	fstr[10] = '0';
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
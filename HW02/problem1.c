#include <stdio.h>
#include <stdlib.h>


void bubSort(int inArr[], int size);

int main(int argc, char **argv) {

	
	
	int numInts;
	int i = 0;
	
	
	
	FILE *myOut = fopen("problem1.out", "w");
	FILE *myin;

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

	bubSort(list2sort, numInts);
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



#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void print2File(FILE *outFile, int size);


int main(int argc, char **argv) {

	int imageSize = atoi(argv[1]);
	int featureSize = atoi(argv[2]);

	

	FILE *myOut = fopen("problem3.dat", "w");
	
	srand(time(NULL));

	print2File(myOut, imageSize);
	print2File(myOut, featureSize);
	fclose(myOut);

	return 0;	
}

void print2File(FILE *outFile, int size){
	int i;
	int j;
	int randN;
		
	for(i = 0; i < size; i++){
		for(j = 0; j < size; j++){
			//generate random number either 1 or 0
			randN = rand() % 2;
			//if number is 0 make it -1
			if(randN == 0){
				randN = -1;
			}
			//print number to file
			fprintf(outFile, "%d", randN);
			//if not at end of line, print a space
			if(j < size-1){
				fprintf(outFile, "%c", ' ');
			}

		}
		//print a space if end of line
		fprintf(outFile, "%s\n", "");
	}

}

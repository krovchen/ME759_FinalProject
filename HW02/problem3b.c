#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {

	

	FILE *myIn = fopen("problem3.dat", "r");
	FILE *myOut = fopen("problem3.out", "w");
	int i = 1;
	int j;
	int imgSize = 1;
	char c;

	

	//read first line of array to find image size
	fscanf (myIn, "%d", &i); 
	//read space
	c = fgetc(myIn);
	while(c != '\n'){
		//read until end line
		fscanf (myIn, "%d", &i); 
		c = fgetc(myIn);
		imgSize = imgSize+1;
	}
	rewind(myIn);

	//allocate vector of memory that can store nxn ints
	int *mymat = malloc(imgSize*sizeof(int)*imgSize);
	
	//populate the memory space -- now we have the matrix
	for(i = 0; i < imgSize*imgSize; i++){
		fscanf(myIn, "%d", mymat);
		//printf("%d \n", *mymat);
		mymat = mymat+1;
	}
	//roll back pointer by 1 row so it points at start of last row of mem
	mymat = mymat-1*imgSize;

	//this will be the output matrix
	int *outmat = malloc(imgSize*sizeof(int)*imgSize);


	for(i = 0; i < imgSize; i++){
		//copy mem from original pointer to new pointer
		memcpy(outmat, mymat, imgSize*sizeof(int));
		//increase new pointer by 1 row
		outmat = outmat+1*imgSize;
		//decrease old pointer by 1 row
		mymat = mymat-1*imgSize;
	}
	//roll back pointer to start of memory
	outmat = outmat - 1*imgSize*imgSize;

	//print out each entry into .dat file
	for(i = 0; i < imgSize; i++){
		for(j = 0; j < imgSize; j++)
		{
			fprintf(myOut, "%d", *outmat);
			if(j < imgSize-1){
				fprintf(myOut, "%c", ' ');
			}
			outmat = outmat+1;
		}
		fprintf(myOut, "%s\n", "");
	
	}
	outmat = outmat - imgSize*imgSize;
	mymat = mymat+imgSize;
	//clean up
	free(outmat);
	free(mymat);
	fclose(myOut);
	fclose(myIn);

	return 0;	
}



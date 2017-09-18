#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char **argv) {


	
	int numInts;
	int i;
	int j;
	char fstr[] = "problem1_10.in";
	char i_str[2];
	//FILE *myOut = fopen("problem1.out", "w");
	FILE *myin;

	srand(0);
	for(i = 10; i < 20; i++){	
		numInts = 2^i;
		//sprintf(i_str, "%d", 42);
		//printf("c\n", (char)i);
		
		
		//fstr = ["problem1_" itoa(i) ".out"];
		myin = fopen(fstr, "w");
		fprintf(myin, "%d \n", 1<<i);
		for(j = 0; j < numInts; j++){
			fprintf(myin, "%d \n", rand());
		}
		fstr[10] = fstr[10]+1;
	}

	return 0;
}





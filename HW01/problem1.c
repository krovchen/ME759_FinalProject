#include <stdio.h>
#include <stdlib.h>


int main(void) {

	FILE *myin;
	char fullID[256];
	
	myin = fopen("problem1.txt", "r");
	char ch = fgetc(myin);
	int i = 0;

	while (ch != EOF) {
		
		fullID[i] = ch;
		ch = getc(myin);
		//printf("%c", ch);
		i++;

	}
	//printf("%c \n", i);
	printf("Hello! I'm student ");
	int j = 5;
	for(j = 5; j > 1; j--){
		printf("%c", fullID[i-j]);
}	

	printf("%c\r\n", '.');
	printf("\r\n");


	return 0;




}
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "omp.h"

double f_out(double x);

int main(int argc, char **argv) {

	double x;
	int i;
	const double h = .0001;
	const double n = 1000000;
	double result = 0;
	double start_time;
	

	start_time = omp_get_wtime();
	result = 17*(f_out(0) + f_out(100));
	result = result+59*(f_out(h)+f_out(100-h));
	result = result+43*(f_out(h+h)+f_out(100-h-h));
	result = result+49*(f_out(h+h+h)+f_out(100-h-h-h));
	
	for(i = 4; i < n-3; i++)
	{
		result = result+48*f_out(i*h);
	

	}
	result = result*h/48;
	printf("wall clock time: %.2g\n", omp_get_wtime()-start_time);
	printf("the answer is: %lf\n", result);
	

	return 0;

}

double f_out(double x){

	//return 1.00;
	return exp(sin(x))*cos(x/40);

}


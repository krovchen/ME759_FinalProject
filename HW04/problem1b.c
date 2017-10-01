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
	double *pointResult = &result;
	double start_time;
	double threadVal;

	int num_th = atoi(argv[1]);
	

	start_time = omp_get_wtime();
	threadVal = 17*(f_out(0) + f_out(100));
	*pointResult = *pointResult+threadVal;
	
	threadVal = 59*(f_out(h)+f_out(100-h));
	*pointResult = *pointResult+threadVal;

	threadVal = 43*(f_out(h+h)+f_out(100-h-h));
	*pointResult = *pointResult+threadVal;

	threadVal = 49*(f_out(h+h+h)+f_out(100-h-h-h));
	*pointResult = *pointResult+threadVal;
	#pragma omp parallel num_threads(num_th) private(threadVal)
	{
	printf("num threads: %d \n", omp_get_num_threads());

	
	for(i = 4; i < n-3; i++)
	{
		threadVal = 48*f_out(i*h);
		*pointResult = *pointResult+threadVal;
	

	}
	
	}
	result = result*h/48;
	printf("wall clock time: %.2g\n", omp_get_wtime()-start_time);
	printf("the answer is: %lf\n", result);
	

	return 0;

}

double f_out(double x){

	double sinx, cosx, espx;
	
	#pragma omp parallel sections
	{
		//printf("num threads: %d \n", omp_get_num_threads());
		#pragma omp section
		{
			sinx = sin(x);
			espx = exp(sinx);
		}
		#pragma omp section
		{
			cosx = cos(x/40);
		}			

	}
	
	//return 1.00;
	return espx*cosx;

}


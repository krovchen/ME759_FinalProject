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
	//double *pointResult = &result;
	double start_time;
	//double threadVal;

	int num_th = atoi(argv[1]);
	

	start_time = omp_get_wtime();
	result = result+h/48*17*(f_out(0) + f_out(100));
	//*pointResult = *pointResult+threadVal;
	
	result = result+ h/48*59*(f_out(h)+f_out(100-h));
	//*pointResult = *pointResult+threadVal;

	result = result+h/48*43*(f_out(h+h)+f_out(100-h-h));
	//*pointResult = *pointResult+threadVal;

	result = result+h/48*49*(f_out(h+h+h)+f_out(100-h-h-h));
	//*pointResult = *pointResult+threadVal;

	int ix = 0;
	int nx = n-3;
	#pragma omp parallel num_threads(num_th)
	{
		#pragma omp single
		{
		printf("num threads: %d \n", omp_get_num_threads());
		}
	
		#pragma omp for private(i) reduction(+:result)
		//{
			for(ix = 0; ix < nx; ix++)
			{
				i = ix+4;
				result = result+h*f_out(i*h);
				//#pragma omp critical
				//{
				//	*pointResult = *pointResult+threadVal;
				//}
	

			}
	
		//}
	}
	//result = result*h/48;
	printf("wall clock time: %.2g\n", omp_get_wtime()-start_time);
	printf("the answer is: %lf\n", result);
	

	return 0;

}

double f_out(double x){

	/*double sinx, cosx, espx;
	
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
	*/
	//return 1.00;
	return exp(sin(x))*cos(x/40);

}


#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "jacobi_kernels.h"
#include "main_fcn.h"


using namespace std;

void gen_b_vec(double* inp1){
	int i = 0;
	for(i = 0; i < Ni; i++)
		inp1[i] = i*.01;
}

void gen_A_mat(double* A)
//generate A matrix that is diagonally dominant
{
	int i = 0;
	int d = 0;
	int temp;
	double val;
	for(i = 0; i < numElems; i++){
		temp = rand();
		A[i] = (double)temp/RAND_MAX;
		if(i == d*Ni+d){			//this part makes the matrix diagonally dominant
			A[i] = A[i]+Ni;
			d=d+1;
		
		}

	}
}


__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr){

	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	write_2_ptr[thid] = read_in_ptr[thid];


}

__global__ void jacobiOptimizedOnDevice(double* x_next, double* A, double* x_now, double* b, int Ni, int Nj)
{
   // Optimization step 1: tiling
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
     
    if (idx < Ni)
    {
        double sigma = 0.0;

        // Optimization step 2: store index in register
        // Multiplication is not executed in every iteration.
        int idx_Ai = idx*Nj;
        
        // Tried to use prefetching, but then the result is terribly wrong and I don't know why.. 
        /*     
        float curr_A = A[idx_Ai];
        float nxt_A;
        //printf("idx=%d\n",idx);
        for (int j=0; j<Nj-1; j++)
        {
            if (idx != j)
                nxt_A = A[idx_Ai + j + 1];
                sigma += curr_A * x_now[j];
                //sigma += A[idx_Ai + j] * x_now[j];
                curr_A = nxt_A;
                //printf("curr_A=%f\n",curr_A);
        }
        if (idx != Nj-1)
            sigma += nxt_A * x_now[Nj-1];
        x_next[idx] = (b[idx] - sigma) / A[idx_Ai + idx];
        */
        
        for (int j=0; j<Nj; j++)
            if (idx != j)
                sigma += A[idx_Ai + j] * x_now[j];

        // Tried to use loop-ennrolling, but also here this gives a wrong result.. 
        /*
        for (int j=0; j<Nj/4; j+=4)
        {
            if (idx != j)
            {
                sigma += A[idx_Ai + j] * x_now[j];
            }
            if (idx != j+1)
            {
                sigma += A[idx_Ai + j+1] * x_now[j+1];
            }
            if (idx != j+2)
            {
               sigma += A[idx_Ai + j+2] * x_now[j+2];
            }
            if (idx != j+3)
            {
                sigma += A[idx_Ai + j+3] * x_now[j+3];
            }
        }*/

        x_next[idx] = (b[idx] - sigma) / A[idx_Ai + idx];
    }

    
}




bool help_fcn(help_input_from_main help_input, double* out, volatile bool* kernel_rdy){
	//int j = 1;
	int k = 0;
	int j;
	double* x_now_d;
	x_now_d = help_input.x_now_d;
	double* A_d = help_input.A_d;
	double *x_next_d = help_input.x_next_d;
	double *b_d = help_input.b_d;
	double nTiles = help_input.nTiles;
	double *b_h = help_input.b_h;
	double *A_h = help_input.A_h;	

	double *test_host;

	cudaMemcpy(b_d, b_h, sizeof(double)*Ni, cudaMemcpyHostToDevice);
	cudaMemcpy(A_d, A_h, sizeof(double)*numElems, cudaMemcpyHostToDevice);
	for(k = 0; k < 5; k++){
		cout << "copied from A: " << A_h[k] << endl;
		cout << "copied from b: " << b_h[k] << endl;

	}
	
	*kernel_rdy = 1;
        for (k=0; k<iter; k++)
        {
            if (k%2){
                jacobiOptimizedOnDevice <<< nTiles, tileSize >>> (x_now_d, A_d, x_next_d, b_d, Ni, Nj);
		//cudaMemcpy(test_host, x_next_d, sizeof(double)*Ni, cudaMemcpyDeviceToHost);
		//for(j = 0; j < 3; j++)
		//cout << "test output in help function: " << test_host[j] << endl;

		}
            else
                jacobiOptimizedOnDevice <<< nTiles, tileSize >>> (x_next_d, A_d, x_now_d, b_d, Ni, Nj);
            //cudaMemcpy(x_now_d, x_next_d, sizeof(float)*Ni, cudaMemcpyDeviceToDevice);

		sleep(.1);
        }
	
	cudaMemcpy(out, x_now_d, sizeof(double)*Ni, cudaMemcpyDeviceToHost);
	cout << "finished copy" << endl;
	for(k = 0; k < 5; k++)
		cout << "Value copied over: "  << out[k] << endl;
	cout << "exiting help" << endl;

	return 1;
}



bool main_fcn(ctrl_flags CF, double* help_out, help_input_from_main* help_input_ptr)
{	
	struct timeval stop, start;
	bool *call_help = CF.call_help;
	//volatile bool *help_rdy = CF.help_rdy;
	volatile bool *request_val = CF.request_val;
	volatile bool *request_done = CF.request_done;

	//initialize data for input to helper function
	//double inp1[N] = {4};
	int i = 0;
	int numReads = 10;
	double sval;
	double sum_times = 0;
	int j = 0;

	double Amat[numElems];
	double b_h[Ni];
	gen_A_mat(Amat);
	gen_b_vec(b_h);

	//set values of helper function input
	(*help_input_ptr).initS(b_h, Amat);
	//ask to start help function	
	cout << "Main calling help function for 1st time" << endl;
	*call_help = 1;
	
	//=====USER CODE before calling help GOES HERE==========
	
	sleep(.6);


	for(j = 0; j < numReads; j++){
	gettimeofday(&start, NULL);

		//BELOW IS WHERE YOU CALL THE HELPER READ FROM MAIN
		*request_val = 1;
		while(*request_done == 0)
			sleep(.00000001);
		//ABOVE IS WHERE YOU CALL THE HELPER READ FROM MAIN -- now help value(s) is in *help_out

	gettimeofday(&stop, NULL);
	sval = (stop.tv_sec-start.tv_sec)*1000000; //sec to us
	sval = sval + stop.tv_usec-start.tv_usec; //us

	cout << "Time between message request and message receive in us is: " << sval << endl;
	for(i = 0; i < 3; i++)
		cout << "Main update received " << help_out[i] << endl;
	*request_done = 0;
	if(j > 0)  //skip the first call because its bad fro some reason
		sum_times = sum_times+sval;
	sleep(.01);

	}

	
	cout << "Average read time between message request and message received in us is: " << sum_times/(numReads-1) << endl;

	//=======USER code AFTER calling helper goes here======

	cout << "Exiting Main" << endl;
	
	return 1;


}

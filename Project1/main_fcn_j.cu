#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "test_kernels.h"
#include "main_fcn.h"
#include <stdlib.h>

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
	for(i = 0; i < NumElems; i++){
		temp = rand();
		A[i] = (double)temp/RAND_MAX;
		if(i == d*Ni+d){			//this part makes the matrix diagonally dominant
			A[i] = A[i]+Ni;
			d=d+1;
		
		}

	}
}


int main()
{
	//define booleans needed for logic
	ctrl_flags CF;


	//define interface between helper and main i.e.: what is returned
	//double out_val =0.0;


	double out[Ni];
	double Amat[numElems];

	gen_A_mat(Amat);

	help_input_from_main test_input;	
	help_input_from_main* help_input = &test_input;

	static double inp1[Ni];
	gen_b_vec(inp1);

	(*help_input).initS(&inp1[0]);	
		cout <<"Running CUDA init" << endl;

			double *x_now_d, *x_next_d, *A_d, *b_d;
			int k;

			//pointer of helper function return	

			double* h_data;
			double* monitor_data;
			
			    // Allocate memory on the device
			cudaMalloc((void **) &x_next_d, Ni*sizeof(double)));
			cudaMalloc((void **) &A_d, NumElems*sizeof(double)));
 			cudaMalloc((void **) &x_now_d, Ni*sizeof(double)));
	 		cudaMalloc((void **) &b_d, Ni*sizeof(double)));
	
			cudaMalloc((void**)&monitor_data, sizeof(double)*Ni);
			cudaMallocHost((void**)&h_data, sizeof(double)*Ni);
			cudaStream_t stream1;
			cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);
		
			 // Optimized kernel
   			 int nTiles = Ni/tileSize + (Ni%tileSize == 0?0:1);
   			 int gridHeight = Nj/tileSize + (Nj%tileSize == 0?0:1);
   			 int gridWidth = Ni/tileSize + (Ni%tileSize == 0?0:1);
    		
    		dim3 dGrid(gridHeight, gridWidth), dBlock(tileSize, tileSize);

	#pragma omp parallel num_threads(3) shared(CF, help_input, out)
	{

		if(omp_get_thread_num() == 0){
			cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
		//code for master threads
			CF.main_done_cmd = main_fcn(CF, out, help_input);
		}

		if(omp_get_thread_num() == 1){
	

			while(CF.main_done_cmd == 0){


				if(CF.help_running_cmd == 1 && allow_interrupt == 0 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<numBlocks, numThreads,0, stream1>>>(monitor_data, x_now_d);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, numElems*sizeof(double), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
					CF.request_val_cmd = 0;
					for(i = 0; i < numElems; i++)
						out[i] = h_data[i];
					CF.req_delivered_cmd = 1;
				}	
			}



		
	
		}
		if(omp_get_thread_num() == 2){
			while(CF.main_done_cmd == 0){
				if(CF.call_help_cmd == 1 && CF.help_running_cmd == 0){

					cout <<"Launching Helper Function" << endl;
					//*help_rdy =  help_fcn(*help_input, out);
					CF.help_running_cmd = 1;
					CF.call_help_cmd = 0;
					dataKernel<<<nTiles, tileSize >>>(dArray, 1000);

				}
			}
			cudaMemcpy(h_data, dArray, sizeof(double)*numElems, 				cudaMemcpyDeviceToHost);
			for(i = 0; i < 5; i++)
				cout << "Value copied over: "  << h_data[i] << endl;

			cudaFree(dArray);
			cudaFree(monitor_data);
	
		}


	}


	return 0;

}




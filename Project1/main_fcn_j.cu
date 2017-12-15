#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "jacobi_kernels.h"
#include "main_fcn.h"
#include <stdlib.h>

using namespace std;




int main()
{
	//define booleans needed for logic
	ctrl_flags CF;


	//define interface between helper and main i.e.: what is returned
	//double out_val =0.0;

	int i;
	double out[Ni];
	double Amat[numElems];
	int numBlocks, numThreads;

	gen_A_mat(Amat);

	static double inp1[Ni];
	gen_b_vec(inp1);

	help_input_from_main test_input;	
	test_input.initS(inp1, Amat);	
	

	cout <<"Running CUDA init" << endl;

	double *x_now_d, *x_next_d, *A_d, *b_d;
	int k;

	//pointer of helper function return
	double* h_data;
	double* monitor_data;  //asdfasdf
			
	    // Allocate memory on the device
	cudaMalloc((void **) &x_next_d, Ni*sizeof(double));
	cudaMalloc((void **) &A_d, numElems*sizeof(double));
 	cudaMalloc((void **) &x_now_d, Ni*sizeof(double));
	cudaMalloc((void **) &b_d, Ni*sizeof(double));
	
	cudaMalloc((void**)&monitor_data, sizeof(double)*Ni);
	cudaMallocHost((void**)&h_data, sizeof(double)*Ni);

	test_input.x_next_d = x_next_d;
	test_input.A_d = A_d;
	test_input.b_d = b_d;
	test_input.x_now_d = x_now_d;

	test_input.nTiles = Ni/tileSize + (Ni%tileSize == 0?0:1);

	help_input_from_main* help_input = &test_input;

	cudaStream_t stream1;
	cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);
	
	if(els_to_read > 1024){			//for now just assume numElems is multiple of 1024
		numThreads = 1024;
		numBlocks = numElems/numThreads;
	}
	 // Optimized kernel
   	 
   	 //int gridHeight = Nj/tileSize + (Nj%tileSize == 0?0:1);
   	// int gridWidth = Ni/tileSize + (Ni%tileSize == 0?0:1);
    		
    	//dim3 dGrid(gridHeight, gridWidth), dBlock(tileSize, tileSize);

	#pragma omp parallel num_threads(3) shared(CF, help_input, out)
	{

		if(omp_get_thread_num() == 0){
			cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
		//code for master threads
			CF.main_done_cmd = main_fcn(CF, out, help_input);
		}

		if(omp_get_thread_num() == 1){
			while(CF.main_done_cmd == 0){
				if(CF.help_running_cmd == 1 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<numBlocks, numThreads,0, stream1>>>(monitor_data, x_now_d);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, Ni*sizeof(double), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
					CF.request_val_cmd = 0;
					for(i = 0; i < Ni; i++)
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
					CF.help_rdy_cmd = help_fcn(*help_input, out);
					//dataKernel<<<nTiles, tileSize >>>(dArray, 1000);

				}
			}
			
	
		}
		

	}

	
	cudaFree(x_next_d);
	cudaFree(A_d);
	cudaFree(x_now_d);
	cudaFree(b_d);
	cudaFree(monitor_data);
	cudaFree(h_data);
	
	return 0;

}




#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "test_kernels.h"
#include "main_fcn.h"

using namespace std;



int main()
{
	//define booleans needed for logic
	ctrl_flags CF;


	//define interface between helper and main i.e.: what is returned
	//double out_val =0.0;


	double out[numElems];

	help_input_from_main test_input;	
	help_input_from_main* help_input = &test_input;

	static double inp1[N] = {5};


	(*help_input).initS(&inp1[0]);	

			cout <<"Running CUDA init" << endl;

			//EDIT THIS to init cuda
			double *dArray;

			int i = 0;
			int numBlocks = 1;
			int numThreads = numElems;
			if(numElems > 1024){			//for now just assume numElems is multiple of 1024
				numThreads = 1024;
				numBlocks = numElems/numThreads;
			}

			//pointer of helper function return	

			double* h_data;
			double* monitor_data;
			

			

			cudaMalloc((void**)&dArray, sizeof(double)*numElems);
			cudaMemset(dArray, 0, numElems*sizeof(double));
		
			cudaMalloc((void**)&monitor_data, sizeof(double)*numElems);
			cudaMallocHost((void**)&h_data, sizeof(double)*numElems);
			cudaStream_t stream1;
			cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);

	#pragma omp parallel num_threads(3) shared(CF, help_input, out)
	{

		if(omp_get_thread_num() == 0){
			cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
		//code for master threads
			CF.main_done_cmd = main_fcn(CF, out, help_input);
		}

		if(omp_get_thread_num() == 1){

			//cudaStreamCreate(&stream1);


			while(CF.main_done_cmd == 0){

				if(CF.call_help_cmd == 1 && CF.help_running_cmd == 0){
					CF.help_running_cmd = 1;
					CF.call_help_cmd = 0;
					cout <<"Launching Helper Kernel" << endl;
					//*help_rdy =  help_fcn(*help_input, out);
			
					dataKernel<<<numBlocks,numThreads>>>(dArray, 100000000000);
				}
				
			}


			cudaMemcpy(h_data, dArray, sizeof(double)*numElems, cudaMemcpyDeviceToHost);
			for(i = 0; i < 5; i++)
				cout << "Value copied over: "  << h_data[i] << endl;

			cudaFree(dArray);
			cudaFree(monitor_data);
		
	
		}
		if(omp_get_thread_num() == 2){
			while(CF.main_done_cmd == 0){
				if(CF.help_running_cmd == 1 && allow_interrupt == 0 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<numBlocks, numThreads,0, stream1>>>(monitor_data, dArray);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, numElems*sizeof(double), cudaMemcpyDeviceToHost, stream1);
					//cudaStreamSynchronize(stream1);
					CF.request_val_cmd = 0;
					for(i = 0; i < numElems; i++){
						
						out[i] = h_data[i];
						if(i < 2)
							cout << "value monitored over: " << out[i] << endl;

					}
					CF.req_delivered_cmd = 1;
				}	
			
			}

		}



	}


	return 0;

}




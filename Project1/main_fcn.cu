#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>

using namespace std;

//global variables
const bool allow_interrupt = 0;
const int N = 5;
__device__ volatile bool *stop_kernel =0;
__device__ volatile bool *request_read = 0;
__device__ volatile bool *ready_to_read = 0;
__device__ volatile bool *read_complete = 0;

struct help_input_from_main{
	static const int length = N;
	double inp1[N];
	double inp2[N];

	void initS(double* v1, double* v2){
		int i = 0;
		for(i = 0; i < N; i++){
			inp1[i] = v1[i];
			inp2[i] = v2[i];
		}
	}

};

struct ctrl_flags{
	bool main_done_cmd = 0;
	bool call_help_cmd = 0;
	bool help_rdy_cmd = 0;
	bool help_running_cmd = 0;
	bool interrupt_help_cmd = 0;
	bool request_val_cmd = 0;
	bool req_delivered_cmd = 0;
	
	bool *call_help = &call_help_cmd;
	bool *help_rdy = &help_rdy_cmd;
	bool *main_done = &main_done_cmd;
	bool *help_running = &help_running_cmd;
	bool *interrupt_help = &interrupt_help_cmd;
	bool *request_val = &request_val_cmd;
	bool *request_done = &req_delivered_cmd;};

//function declarations -- helper and main
bool main_fcn(ctrl_flags CF, int * out_data, help_input_from_main* help_input);
bool help_fcn(help_input_from_main help_input, double* out);
bool init_help(help_input_from_main help_input);

//function declarations -- calc kernel and monitor kernel
__global__ void dataKernel( int* data, int size, int* held_Data);
__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr);


int main()
{
	//define booleans needed for logic
	ctrl_flags CF;

	//define interface between helper and main i.e.: what is returned
	int out_val =0.0;


	int *out = &out_val;

	help_input_from_main test_input;	
	help_input_from_main* help_input = &test_input;

	static double inp1[N] = {1,2,3,4,5};
	static double inp2[N] = {1,2,3,4,5};

	(*help_input).initS(&inp1[0], &inp2[0]);	


	#pragma omp parallel num_threads(2) shared(CF)
	{

		if(omp_get_thread_num() == 0){
			cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
		//code for master threads
			CF.main_done_cmd = main_fcn(CF, out, help_input);
		}

		if(omp_get_thread_num() == 1){
			cout <<"Running CUDA init" << endl;
			const int numElems = 4;
			int hostArray[numElems];
			int *dArray;
			int *dArray_Held;
			int i = 0;

			//pointer of helper function return	
			int transfered_data;
			int *h_data = &transfered_data;
			int *monitor_data;

			//bool *stop_kern_ptr = &stop_kernel;
		
			cudaMalloc(&stop_kernel, sizeof(bool));
			cudaMalloc(&request_read, sizeof(bool));
			cudaMalloc(&read_complete, sizeof(bool));
			cudaMalloc(&ready_to_read, sizeof(bool));
			cudaMalloc((void**)&dArray, sizeof(int)*numElems);
			cudaMalloc((void**)&dArray_Held, sizeof(int)*numElems);
			cudaMemset(dArray, 0, numElems*sizeof(int));
			cudaMemset(dArray_Held, 0, numElems*sizeof(int));
			cudaMallocHost((void**)&monitor_data, sizeof(int));
			

			cudaStream_t stream1;
			cudaStreamCreate(&stream1);


			while(CF.main_done_cmd == 0){

				if(CF.call_help_cmd == 1 && CF.help_running_cmd == 0){
					CF.help_running_cmd = 1;
					CF.call_help_cmd = 0;
					cout <<"Launching Helper Kernel" << endl;
					//*help_rdy =  help_fcn(*help_input, out);
					dataKernel<<<1, 4>>>(dArray, numElems, dArray_Held);
				}
				if(CF.help_running_cmd == 1 && allow_interrupt == 0 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor Kernel" << endl;
					cudaStreamSynchronize(stream1);
					monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dArray);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
					CF.request_val_cmd = 0;
					*out = *h_data;
					CF.req_delivered_cmd = 1;
				}	
			}

			bool k_stop_cmd = 1;
			bool *host_stop_kernel = &k_stop_cmd;

			cout <<"Trying to Stop Helper Kernel" << endl;
			cudaMemcpyAsync(&stop_kernel, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice, stream1);
	

			cout << "Copying values from helper kernel to base (but they may be garbage!!!!!" << endl;
			cudaMemcpy(&hostArray, dArray_Held, sizeof(int)*numElems, cudaMemcpyDeviceToHost);


			for(i = 0; i < numElems; i++)
				cout << hostArray[i] << endl;

			cudaFree(dArray);
			cudaFree(monitor_data);
			cout << "Expected h_data point to: " << *h_data << endl;
	
		}



	}


	return 0;

}

bool main_fcn(ctrl_flags CF, int* help_out, help_input_from_main* help_input_ptr)
{	
	bool *call_help = CF.call_help;
	bool *help_rdy = CF.help_rdy;
	bool *request_val = CF.request_val;
	bool *request_done = CF.request_done;

	//initialize data for input to helper function
	double inp1[N] = {1,2,3,4,5};
	

	//set values of helper function input
	(*help_input_ptr).initS(inp1, inp1);
	//ask to start help function	
	cout << "Main calling help function for 1st time" << endl;
	*call_help = 1;
	
	//some code/processing goes here
	sleep(1);

	//if interrupt not allowed, then request value from help
	if(allow_interrupt == 0){	
		cout << "Main requesting function update" << endl;
		*request_val = 1;
		while(*request_done == 0)
			sleep(1);
	}
	//..cout << "Main requesting function update" << endl;

	/*if(allow_interrupt == 1){
		sleep(2); //sleep 2 s to simulate other activities or running code
		*interrupt_help = 1;	//set helper interrupt flag
		while(*help_rdy == 0)    // wait for helper function to finish after interrupt
			sleep(1);
	}*/

	cout << "Main update received " << *help_out << endl;
	*request_done = 0;
	sleep(2);

	cout << "Main Requestiong Second function update " << endl;
	cout << "Current Request Val (shoudl be 0) = " << *request_val << endl;
	
	*request_val = 1;
	while(*request_done == 0)
		sleep(1);
	cout << "Main update received " << *help_out << endl;
	*request_done = 0;
	sleep(2);

	cout << "Main Requestiong Third function update " << endl;
	*request_val = 1;
	while(*request_done == 0)
		sleep(1);
	cout << "Main update received " << *help_out << endl;
	*request_done = 0;
	//sleep(2);
	cout << "Exiting Main" << endl;
	
	return 1;


}

bool help_fcn(help_input_from_main help_input, double* out){
	//int j = 1;
	int i = 0;
	double* inp1 = help_input.inp1;
	double* inp2 = help_input.inp2;
	
	for(i = 0; i < N; i++){

		if(i > 0)
			//*out = (*out+inp1[i]+inp2[i])*i/(i+1);
			*out = (*out+inp1[i]+inp2[i]);
		else
			//*out = (*out+inp1[i]+inp2[i]);
			*out = (*out+inp1[i]+inp2[i]);	
		//cout << "out after update = " << *out << endl;	

	
	}
	return 1;
}

bool init_help(help_input_from_main help_input){
	

return 1;

}



__global__ void dataKernel( int* data, int size, int* data_held){
//this adds a value to a variable stored in global memory
	int thid = threadIdx.x+blockIdx.x*blockDim.x;

	
	if(thid < size){
		data_held[thid] = (blockIdx.x+ threadIdx.x);
		data[thid] = (blockIdx.x+ threadIdx.x);
		while(1){
			if(data[thid] < 1000)
				data[thid] = data[thid]+.2;
			else
				data[thid] = data[thid]-100;
			if(*stop_kernel == 1){
					__syncthreads();

					asm("trap;");
					}
			if(*request_read == 1){
					__syncthreads();
					if(thid == 0)
						*ready_to_read = 1;
					while(*read_complete == 0)
						{}

					*request_read = 0;
					*read_complete = 0;
			}			


		}
	}

}


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr){
	*request_read = 1;

	while(*ready_to_read == 0)
		{}
	*write_2_ptr = *read_in_ptr;
	*read_complete =1;
	*ready_to_read = 0;

}


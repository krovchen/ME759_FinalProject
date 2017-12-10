#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>

using namespace std;

//global variables
const bool allow_interrupt = 0;
const int N = 5;


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
	volatile bool help_rdy_cmd = 0;
	volatile bool help_running_cmd = 0;
	volatile bool interrupt_help_cmd = 0;
	volatile bool request_val_cmd = 0;
	volatile bool req_delivered_cmd = 0;
	
	bool *call_help = &call_help_cmd;
	volatile bool *help_rdy = &help_rdy_cmd;
	bool *main_done = &main_done_cmd;
	volatile bool *help_running = &help_running_cmd;
	volatile bool *interrupt_help = &interrupt_help_cmd;
	volatile bool *request_val = &request_val_cmd;
	volatile bool *request_done = &req_delivered_cmd;};

//function declarations -- helper and main
bool main_fcn(ctrl_flags CF, double * out_data, help_input_from_main* help_input);
bool help_fcn(help_input_from_main help_input, double* out);
bool init_help(help_input_from_main help_input);

//function declarations -- calc kernel and monitor kernel
__global__ void dataKernel( double* data,  int nsteps);
__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr);


int main()
{
	//define booleans needed for logic
	ctrl_flags CF;

	//define interface between helper and main i.e.: what is returned
	double out_val =0.0;


	double *out = &out_val;

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
			const int numElems = 1;
			double hostArray[numElems];
			double *dArray;

			int i = 0;

			//pointer of helper function return	

			double *h_data;
			double *monitor_data;

		

			cudaMalloc((void**)&dArray, sizeof(double)*numElems);
			//cudaMalloc((void**)&dArray_Held, sizeof(int)*numElems);
			cudaMemset(dArray, 0, numElems*sizeof(double));
			//cudaMemset(dArray_Held, 0, numElems*sizeof(int));
			cudaMalloc((void**)&monitor_data, sizeof(double));
			cudaMallocHost((void**)&h_data, sizeof(double));
			cudaStream_t stream1;
			cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);


			while(CF.main_done_cmd == 0){

				if(CF.call_help_cmd == 1 && CF.help_running_cmd == 0){
					CF.help_running_cmd = 1;
					CF.call_help_cmd = 0;
					cout <<"Launching Helper Kernel" << endl;
					//*help_rdy =  help_fcn(*help_input, out);
					dataKernel<<<1,1>>>(dArray, 100);
				}
				if(CF.help_running_cmd == 1 && allow_interrupt == 0 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dArray);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, sizeof(double), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
					CF.request_val_cmd = 0;
					*out = *h_data;
					CF.req_delivered_cmd = 1;
				}	
			}


			cudaMemcpy(h_data, dArray, sizeof(double), cudaMemcpyDeviceToHost);
			cout << "Value copied over: "  << *h_data << endl;

			cudaFree(dArray);
			cudaFree(monitor_data);
		
	
		}



	}


	return 0;

}

bool main_fcn(ctrl_flags CF, double* help_out, help_input_from_main* help_input_ptr)
{	
	bool *call_help = CF.call_help;
	//volatile bool *help_rdy = CF.help_rdy;
	volatile bool *request_val = CF.request_val;
	volatile bool *request_done = CF.request_done;

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



__global__ void dataKernel( double* data, int nsteps){
//this adds a value to a variable stored in global memory
	*data = 0;
	int i = 0;
	bool wait = 1;

	clock_t start = clock64();
	clock_t now;

	while(i < nsteps){
		*data = *data+.1;

		clock_t start = clock64();
		i = i+1;
		while(wait == 1){
			now = clock();
			clock_t cycles = now > start ? now - start : now + (0xffffffff - start);
			if(cycles > 5)
				wait = 0;
		}		
		wait = 1;
	}	



}


__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr){

	*write_2_ptr = *read_in_ptr;


}


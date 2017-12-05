#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>

using namespace std;

//global variables
const bool allow_interrupt = 0;
const int N = 5;
bool stop_kernel =0;

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

//function declarations -- helper and main
bool main_fcn(bool * call_help1, bool * help_rdy1, double * out_data, help_input_from_main* help_input, bool *interrupt_help);
bool help_fcn(help_input_from_main help_input, double* out);

//function declarations -- calc kernel and monitor kernel
__global__ void dataKernel( int* data, int size);
__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr);


int main()
{
	//define booleans needed for logic
	bool main_done_cmd = 0;
	bool call_help_cmd = 0;	
	bool help_rdy_cmd = 0;
	bool help_running_cmd = 0;
	bool interrupt_help_cmd = 0;

	//define interface between helper and main i.e.: what is returned
	double out_val =0.0;

	//define pointers to bools and doubles
	bool *call_help = &call_help_cmd;
	bool *help_rdy = &help_rdy_cmd;
	bool *main_done = &main_done_cmd;
	bool *help_running = &help_running_cmd;
	bool *interrupt_help = &interrupt_help_cmd;
	double *out = &out_val;


	
	help_input_from_main test_input;
	
	help_input_from_main* help_input = &test_input;


	static double inp1[N] = {1,2,3,4,5};
	static double inp2[N] = {1,2,3,4,5};

	(*help_input).initS(&inp1[0], &inp2[0]);	




	#pragma omp parallel num_threads(2) shared(main_done, help_rdy, call_help, out, help_input, interrupt_help)
	{

	if(omp_get_thread_num() == 0){
		cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
	//code for master threads
		*main_done = main_fcn(call_help, help_rdy, out, help_input, interrupt_help);
	}

	if(omp_get_thread_num() == 1){
		cout <<"WHATDDUP IM LAUNCHING that second" << endl;
		
		while(*main_done == 0){
			//sleep(10);
			//cout << *call_help <<endl;
			//cout << *help_running << endl;
			if(*call_help == 1 && *help_running == 0){
				*help_running = 1;
				*call_help = 0;
				*help_rdy =  help_fcn(*help_input, out);
			}
			//if(*help_running == 1 && *interrupt_help == 0){

		}	
	
	}


	}




	cout << "begin CUDA Testing" << endl;
	//begin CUDA testing
	const int numElems = 4;
	int hostArray[numElems];
	 int *dArray;
	int i = 0;

	//pointer of helper function return	
	int transfered_data;
	 int *h_data = &transfered_data;
	int *monitor_data;

	bool *stop_kern_ptr = &stop_kernel;
	//cudaSetDeviceFlags(cudaDeviceMapHost);
	//cudaHostAlloc((void **)&h_data, sizeof(int), cudaHostAllocMapped);
	//cudaHostGetDevicePointer((int **)&d_data, (int *)h_data,0);
	
	cudaMalloc(&stop_kern_ptr, sizeof(bool));
	cudaMalloc((void**)&dArray, sizeof(int)*numElems);
	cudaMemset(dArray, 0, numElems*sizeof(int));
	cudaMalloc((void**)&monitor_data, sizeof(int));
	cudaMalloc((void**)&dArray, sizeof(int)*numElems);



	dataKernel<<<1, 4>>>(dArray, numElems);

	monitorKernel<<<1, 1>>>(monitor_data, &dArray[2]);

	cudaMemcpy(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost);

	cudaMemcpy(&hostArray, dArray, sizeof(int)*numElems, cudaMemcpyDeviceToHost);


	for(i = 0; i < numElems; i++)
		cout << hostArray[i] << endl;

	cudaFree(dArray);

	cudaFree(monitor_data);



	cout << "Expected h_data to point to 1, actual point to: " << *h_data << endl;

	return 0;


}

bool main_fcn(bool* call_help, bool* help_rdy, double* help_out, help_input_from_main* help_input_ptr, bool *interrupt_help){
	
	cout << "WHADDUP IM IN THE MAIN " << endl;
	//initialize data for input to helper function
	double inp1[N] = {1,2,3,4,5};
	cout << "WHADDUP I initialized inp1 " << endl;
	(*help_input_ptr).initS(inp1, inp1);

	cout << "WHADDUP ABOUT TO CALL DAT HEEELP " << endl;
	//call help function
	*call_help = 1;
	
	cout << "WHADDUP JUST CALLED DAT HELP " << endl;

	//if interrupt not allowed, then sleep until helper function is ready
	if(allow_interrupt == 0){
		while(*help_rdy == 0)
			sleep(1);
	}

	if(allow_interrupt == 1){
		sleep(2); //sleep 2 s to simulate other activities or running code
		*interrupt_help = 1;	//set helper interrupt flag
		while(*help_rdy == 0)    // wait for helper function to finish after interrupt
			sleep(1);
	}

	cout << "helper function returned the following value to main fnc: " << *help_out << endl;
	
	
	
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



__global__ void dataKernel( int* data, int size){
//this adds a value to a variable stored in global memory
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	if(thid < size)
	data[thid] = (blockIdx.x+ threadIdx.x);

}


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr){
//this adds a value to a variable stored in global memory
	*write_2_ptr = *read_in_ptr;

}


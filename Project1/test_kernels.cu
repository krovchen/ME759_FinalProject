#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "test_kernels.h"
#include "main_fcn.h"


using namespace std;


__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr){

	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	write_2_ptr[thid] = read_in_ptr[thid];


}





__global__ void dataKernel( double* data, int nsteps){
//this adds a value to a variable stored in global memory
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	//data[thid] = 0;
	int i = 0;
	//bool wait = 1;

	//clock_t start = clock64();
	//clock_t now;

	while(i < nsteps){
		data[thid] = data[thid]+.00001*thid;
		i=i+1;
	
	}
		/*start = clock64();
		i = i+1;
		while(wait == 1){
			now = clock();
			clock_t cycles = now > start ? now - start : now + (0xffffffff - start);
			if(cycles > 5000)
				wait = 0;
		}		
		wait = 1;
		
	}	*/



}


bool help_fcn(help_input_from_main help_input, double* out){
	//int j = 1;
	int i = 0;
	double* inp1 = help_input.inp1;
	double* inp2 = help_input.inp1;
	
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



bool main_fcn(ctrl_flags CF, double* help_out, help_input_from_main* help_input_ptr)
{	
	struct timeval stop, start;
	bool *call_help = CF.call_help;
	//volatile bool *help_rdy = CF.help_rdy;
	volatile bool *request_val = CF.request_val;
	volatile bool *request_done = CF.request_done;

	//initialize data for input to helper function
	double inp1[N] = {4};
	int i = 0;
	int numReads = 10;
	double sval;
	double sum_times = 0;
	int j = 0;

	//set values of helper function input
	(*help_input_ptr).initS(inp1);
	//ask to start help function	
	cout << "Main calling help function for 1st time" << endl;
	*call_help = 1;
	
	//=====USER CODE before calling help GOES HERE==========
	sleep(.01);


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
	sleep(.2);

	}

	
	cout << "Average read time between message request and message received in us is: " << sum_times/(numReads-1) << endl;

	//=======USER code AFTER calling helper goes here======

	cout << "Exiting Main" << endl;
	
	return 1;


}

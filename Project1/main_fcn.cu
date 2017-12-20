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
	double temp_out[numElems];

	help_input_from_main test_input;	
	help_input_from_main* help_input = &test_input;

	static double inp1[N] = {5};


	(*help_input).initS(&inp1[0]);	

			int i = 0;
	
			//pointer of helper function return	



	#pragma omp parallel num_threads(3) shared(CF, help_input, out)
	{

		if(omp_get_thread_num() == 0){
			cout <<"WHATDDUP IM LAUNCHING THAT MAIN" << endl;
		//code for master threads
			CF.main_done_cmd = main_fcn(CF, temp_out, help_input);
		}

		if(omp_get_thread_num() == 1){

			//cudaStreamCreate(&stream1);


			while(CF.main_done_cmd == 0){

				if(CF.call_help_cmd == 1 && CF.help_running_cmd == 0){
					CF.help_running_cmd = 1;
					CF.call_help_cmd = 0;
					cout <<"Launching Helper Kernel" << endl;
					//*help_rdy =  help_fcn(*help_input, out);
					//sleep(10);
					CF.help_rdy_cmd = help_fcn(*help_input, out, &CF.kernel_rdy_cmd);
				}
				
			}


		
			for(i = 0; i < 5; i++)
 				cout << "Last value of helper function: "  << out[i] << endl;

	
		}
		if(omp_get_thread_num() == 2){
			while(CF.main_done_cmd == 0){
				if(CF.help_running_cmd == 1 && allow_interrupt == 0 && CF.request_val_cmd == 1){	
					cout <<"Launching Monitor" << endl;
	
					CF.request_val_cmd = 0;
				
					
					for(i = 0; i < numElems; i++){
						temp_out[i] = out[i];
						if(i < 3)
							cout << "value monitored over: " << temp_out[i] << endl;

					}
					CF.req_delivered_cmd = 1;
				}	
			
			}

		}



	}


	return 0;

}




#include<cuda.h>
#include<iostream>
#include <unistd.h>

using namespace std;

const int numElems =2;

__global__ void dataKernel( double* data, int nsteps){
//this adds a value to a variable stored in global memory
	int thid = threadIdx.x;
	//data[thid] = 0;
	int i = 0;
	bool wait = 1;

	clock_t start = clock64();
	clock_t now;

	while(i < nsteps){
		data[thid] = data[thid]+.1;

		clock_t start = clock64();
		i = i+1;
		while(wait == 1){
			now = clock();
			clock_t cycles = now > start ? now - start : now + (0xffffffff - start);
			if(cycles > 5000)
				wait = 0;
		}		
		wait = 1;
		__syncthreads();
	}	



}


__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr){
	


	*write_2_ptr = *read_in_ptr;

}

int main()
{

			cout <<"Running CUDA init" << endl;

			double *dArray;

			int i = 0;

			//pointer of helper function return	

			double h_data[numElems];
			double monitor_data[numElems];

			cudaMalloc((void**)&dArray, sizeof(double)*numElems);
			cudaMemset(dArray, 0, numElems*sizeof(double));
			cudaMallocHost((void**)&h_data, sizeof(double)*numElems);
			cudaStream_t stream1;
			cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);
			cudaMalloc((void**)&monitor_data, sizeof(double)*numElems);


		cout <<"Launching Helper Kernel" << endl;
			//*help_rdy =  help_fcn(*help_input, out);
			dataKernel<<<1,numElems>>>(dArray, 1000);
			sleep(.4);

					cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dArray);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, numElems*sizeof(double), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
						for(i = 0; i < numElems; i++)
				cout << "Value copied over: "  << h_data[i] << endl;
					sleep(.3);
							cout <<"Launching Monitor Kernel" << endl;
					//cudaStreamSynchronize(stream1);
					monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dArray);
					cout <<"Launching Async Mem Cpy" << endl;
					cudaMemcpyAsync(h_data, monitor_data, numElems*sizeof(double), cudaMemcpyDeviceToHost, stream1);
					cudaStreamSynchronize(stream1);
						for(i = 0; i < numElems; i++)
				cout << "Value copied over: "  << h_data[i] << endl;



			cudaMemcpy(h_data, dArray, sizeof(double)*numElems, cudaMemcpyDeviceToHost);
			for(i = 0; i < numElems; i++)
				cout << "Value copied over: "  << h_data[i] << endl;

			cudaFree(dArray);
	
			cudaFree(monitor_data);
return 0;


	



}

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


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr){
	


	*write_2_ptr = *read_in_ptr;

}

int main()
{

			cout <<"Running CUDA init" << endl;

			double *dArray;

			int i = 0;

			//pointer of helper function return	

			double h_data[numElems];


			cudaMalloc((void**)&dArray, sizeof(double)*numElems);
			cudaMemset(dArray, 0, numElems*sizeof(double));
			cudaMallocHost((void**)&h_data, sizeof(double)*numElems);



		cout <<"Launching Helper Kernel" << endl;
			//*help_rdy =  help_fcn(*help_input, out);
			dataKernel<<<1,numElems>>>(dArray, 1000);


			cudaMemcpy(h_data, dArray, sizeof(double)*numElems, cudaMemcpyDeviceToHost);
			for(i = 0; i < numElems; i++)
				cout << "Value copied over: "  << h_data[i] << endl;

			cudaFree(dArray);
	

return 0;


	



}

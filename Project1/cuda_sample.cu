#include<cuda.h>
#include<iostream>

using namespace std;


__device__ volatile bool *stop_kernel =0;
__device__ volatile bool *request_read = 0;
__device__ volatile bool *ready_to_read = 0;
__device__ volatile bool *read_complete = 0;

__global__ void dataKernel( int* data){
//this adds a value to a variable stored in global memory
	*data = 3;
	if(*stop_kernel == 1)
		*data = 4;
	}
/*
	while(1){
		if(*stop_kernel == 1){
			*data = 4;
			__syncthreads();
			asm("trap;");
		}
		if(*request_read == 1){
			__syncthreads();
			*ready_to_read = 1;
			while(*read_complete == 0)
			{}
			*request_read = 0;
			*read_complete = 0;
			*data = 5;
		}			


		
	}

}*/


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr){
	*request_read = 1;

	while(*ready_to_read == 0)
		{}
	*write_2_ptr = *read_in_ptr;
	*read_complete =1;
	*ready_to_read = 0;

}

int main()
{

	int *dVal;

	//pointer of helper function return	
	int transfered_data;
	int *h_data = &transfered_data;
	int *monitor_data;

	//bool *stop_kern_ptr = &stop_kernel;
		
	cudaMalloc(&stop_kernel, sizeof(bool));
	cudaMalloc(&request_read, sizeof(bool));
	cudaMalloc(&read_complete, sizeof(bool));
	cudaMalloc(&ready_to_read, sizeof(bool));
	cudaMalloc((void**)&dVal, sizeof(int));

	cudaMallocHost((void**)&monitor_data, sizeof(int));
			
	bool k_stop_cmd = 1;
	bool *host_stop_kernel = &k_stop_cmd;
	cudaStream_t stream1;
	cudaStreamCreate(&stream1);
	cout <<"Trying to Stop Helper Kernel" << endl;
	cudaMemcpy(&stop_kernel, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice);
	//cudaStreamSynchronize(stream1);
	dataKernel<<<1, 1>>>(dVal);
	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "Value copied over: "  << *h_data << endl;
return 0;
	cout <<"Launching Monitor Kernel" << endl;
	cudaStreamSynchronize(stream1);
	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dVal);
	cout <<"Launching Async Mem Cpy" << endl;
	cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cudaStreamSynchronize(stream1);
	
	cout << "Value monitored: "  << *h_data << endl;
	//bool k_stop_cmd = 1;
	//bool *host_stop_kernel = &k_stop_cmd;
	cout <<"Trying to Stop Helper Kernel" << endl;
	cudaMemcpyAsync(&stop_kernel, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice, stream1);
	cudaStreamSynchronize(stream1);
	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "Value copied over: "  << *h_data << endl;

	cudaFree(dVal);
	cudaFree(&stop_kernel);
	cudaFree(&request_read);
	cudaFree(&read_complete);
	cudaFree(&ready_to_read);
	
	return 0;
	/*
cudaMemcpy(&hostArray, dArray, sizeof(int)*numElems, cudaMemcpyDeviceToHost);

	cout << "Values in hostArray: " << endl;
	for(i = 0; i < numElems; i++)
		cout << hostArray[i] << endl;
	cudaFree(dArray);
	return 0;
*/
}

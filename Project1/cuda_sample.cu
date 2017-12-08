#include<cuda.h>
#include<iostream>

using namespace std;


__device__ static bool *stop_kernel =0;
__device__ static bool *request_read = 0;
__device__ static bool *ready_to_read = 0;
__device__ static bool *read_complete = 0;

__global__ void dataKernel( int* data, bool* stop, bool* req_red, bool *r2r, bool *rdc){
//this adds a value to a variable stored in global memory

	*data = 3;
	if(*stop == 1){
		*data = 4;
		*stop = 0;}	
}
/*
	while(1){
		if(*stop == 1){
			*data = 6;
			__syncthreads();
			asm("trap;");
		}
		if(*req_red == 1){
			__syncthreads();
			*r2r = 1;
			while(*rdc == 0)
			{}
			*r2r = 0;
			*rdc = 0;
			*data = 5;
		}			


		
	}

}*/


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr, bool* req_rd, bool *r2r, bool *rc){
	
	if(*stop == 0){
		*req_rd = 1;
		*stop = 1;
	}
	/*
	*req_rd = 1;

	while(*r2r == 0)
		{}
	*write_2_ptr = *read_in_ptr;
	*rc =1;
	*r2r = 0;
	*/

}

int main()
{

	int *dVal;
	int size = sizeof(bool);

	//pointer of helper function return	
	int transfered_data;
	int *h_data = &transfered_data;
	int *monitor_data;
	bool k_stop_cmd = 1;
	bool *host_stop_kernel = &k_stop_cmd;

	bool bool_test = 0;
	bool *test_value = &bool_test;
	bool *stop_kern_ptr;
	bool *request_read_ptr;
	bool *read_to_read_ptr;
	bool *read_complete_ptr;
	
	cudaMallocHost((void**)&host_stop_kernel, size);
	*host_stop_kernel = 1;

	cudaMalloc((void**)&stop_kernel, size);
	cudaMalloc((void**)&request_read, size);
	cudaMalloc((void**)&ready_to_read, size);
	cudaMalloc((void**)&read_complete, size);

	cudaGetSymbolAddress((void**)&stop_kern_ptr, stop_kernel);
	cudaGetSymbolAddress((void**)&request_read_ptr, request_read);
	cudaGetSymbolAddress((void**)&read_to_read_ptr, ready_to_read);
	cudaGetSymbolAddress((void**)&read_complete_ptr, read_complete);

	cout << "ADDRESs Of stop_kernel = " << stop_kern_ptr << endl;
	//cout << "Dereferenced stop kernel = " << *stop_kern_ptr << endl;
	//cudaMalloc((void**)&dVal, sizeof(int));
	cudaMalloc((void**)&dVal, sizeof(int));
		
	//cout << "Cuda Error: " << cErr << endl;	

	
	//cudaMemcpyToSymbol(stop_kernel, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice);
	cout << "Copying " << *host_stop_kernel << " from the address: " << host_stop_kernel << "to: " << stop_kern_ptr << endl;
	cudaMemcpy(stop_kern_ptr, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice);
cout <<"COPIED MEM DO DEVICE" << endl;
	cout << "Copying from" << stop_kern_ptr << "to: " << &test_value << endl;
	
	cudaMemcpy(test_value, stop_kern_ptr, sizeof(bool), cudaMemcpyDeviceToHost);

	cout << "if stop_kernel in global memory of device then this better be 1: " << *test_value << endl;
	//cudaStreamSynchronize(stream1);
	dataKernel<<<1, 1>>>(dVal, stop_kern_ptr, request_read_ptr, read_to_read_ptr, read_complete_ptr);


	cudaStream_t stream1;
	cudaStreamCreate(&stream1);
	cudaMallocHost((void**)&monitor_data, sizeof(int));
	cout <<"Launching Monitor Kernel" << endl;

	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dVal, request_read_ptr, read_to_read_ptr, read_complete_ptr);
	cudaMemcpy(test_value, stop_kern_ptr, sizeof(bool), cudaMemcpyDeviceToHost);
	cout << "if stop_kernel in global memory of device then this better be 0: " << *test_value << endl;
	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);

	cudaMemcpy(test_value, request_read_ptr, sizeof(bool), cudaMemcpyDeviceToHost);
	cout << "if stop_kernel in global memory of device then this better be 1: " << *test_value << endl;

	cout << "Value copied over: "  << *h_data << endl;
return 0;


	cudaStreamSynchronize(stream1);

	cout <<"Launching Async Mem Cpy" << endl;
	cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cudaStreamSynchronize(stream1);
	cout << "Value monitored: "  << *h_data << endl;
cout << "Copying " << *host_stop_kernel << " from the address: " << host_stop_kernel << "to: " << stop_kern_ptr << endl;
	cudaMemcpy(stop_kern_ptr, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice);
cout <<"COPIED MEM DO DEVICE" << endl;
	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "Value copied over: "  << *h_data << endl;
return 0;





	cudaMalloc(&request_read, sizeof(bool));
	cudaMalloc(&read_complete, sizeof(bool));
	cudaMalloc(&ready_to_read, sizeof(bool));
	
	


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

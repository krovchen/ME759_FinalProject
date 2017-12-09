#include<cuda.h>
#include<iostream>
#include <unistd.h>

using namespace std;


//__device__ static bool *stop_kernel =0;


__global__ void dataKernel( int* data){
//this adds a value to a variable stored in global memory

	*data = 3;
	bool x = 0;
	bool *stop = &x;
	while(1){
		if(*data > 300)
			*data = 0;
		*data = *data+1;
		if(*stop == 1){
			*data = 6;
			__syncthreads();
			asm("trap;");
		}

		
	}

}


__global__ void monitorKernel(int * write_2_ptr,  int * read_in_ptr){
	


	*write_2_ptr = *read_in_ptr;
	/*if(*rc == 1){
		
		*rc = 0;
	}*/
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
	//int size = sizeof(bool);

	//pointer of helper function return	asdfasdfasdf
	int transfered_data;
	int *h_data = &transfered_data;
	int *monitor_data;
	//bool k_stop_cmd = 1;
	//bool *host_stop_kernel = &k_stop_cmd;

	//bool bool_test = 0;
	//bool *test_value = &bool_test;
	
	//cudaMallocHost((void**)&host_stop_kernel, size);
	//*host_stop_kernel = 1;

	//cudaMalloc((void**)&stop_kernel, size);
	
	//bool *stop_kern_ptr;
	//cudaGetSymbolAddress((void**)&stop_kern_ptr, stop_kernel);

	cudaMalloc((void**)&dVal, sizeof(int));
	cudaMallocHost((void**)&monitor_data, sizeof(int));	


	cudaStream_t stream1;
	cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);
	
	dataKernel<<<1, 1>>>(dVal);

	cout <<"Launching Monitor Kernel" << endl;
	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dVal);
	cout <<"Launching Async Mem Cpy" << endl;
	cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cout << "Value monitored over: "  << *h_data << endl;
	cudaStreamSynchronize(stream1);

	sleep(2);
	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dVal);
	cout <<"Launching Async Mem Cpy" << endl;
	cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cout << "Value monitored over: "  << *h_data << endl;
	cudaStreamSynchronize(stream1);

sleep(1);

	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, dVal);
	cout <<"Launching Async Mem Cpy" << endl;
	cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cout << "Value monitored over: "  << *h_data << endl;
	cudaStreamSynchronize(stream1);

sleep(1);


	//cout << "Stopping Kernel " << *host_stop_kernel << endl;
	//cudaMemcpyAsync(stop_kern_ptr, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice, stream1);
	//cudaStreamSynchronize(stream1);
	
	//cudaMemcpyAsync(test_value, stop_kern_ptr, sizeof(bool), cudaMemcpyDeviceToHost, stream1);
	
	//cudaStreamSynchronize(stream1);
//cout << "if stop_kernel in global memory of device then this better be 1: " << *test_value << endl;

	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "Value copied over: "  << *h_data << endl;
	cudaFree(dVal);
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

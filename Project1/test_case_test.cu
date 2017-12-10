#include<cuda.h>
#include<iostream>
#include <unistd.h>
#include <math.h>
#include <stdlib.h>

using namespace std;


__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr);


__device__ void MatrixAddKernel(double* Melems, double* Nelems, double* Pelems)
{
 
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	int i = 0;
	int shift = thid;
	for(i = 0; i < 1; ++i)
	Pelems[shift+i] = Melems[shift+i]+Nelems[shift+i];

}


__device__ void Muldev(double* A, double* B, double* C, int nRows)
{

	extern __shared__ double ptr[];


	int bx = blockIdx.x;
	int by = blockIdx.y;

	int tx = threadIdx.x;
	int ty = threadIdx.y;

	int aBegin = nRows*blockDim.x*by;
	int aEnd = aBegin + nRows-1;

	int aStep = blockDim.x;
	
	int bBegin = blockDim.x*bx;
	int bStep = blockDim.x*nRows;

	double Csub = 0;
	
	double* As = &ptr[0];
	double* Bs = &ptr[blockDim.x*blockDim.x];

	

	int a;
	int b;
	int k;

	for(a = aBegin, b = bBegin; a<=aEnd; a+=aStep, b+=bStep){
		
		As[ty*blockDim.x+tx] = A[a+nRows*ty+tx];

		Bs[ty*blockDim.x+tx] = B[b+nRows*ty+tx];
		

		__syncthreads();
		__threadfence_block();
		
		for(k = 0; k < blockDim.x; ++k){
			Csub+=As[ty*blockDim.x+k]*Bs[k*blockDim.x+tx];}
			//Csub+=As[tx*blockDim.x+k]*Bs[k*blockDim.x+ty];}
			
		__syncthreads();
	}

	int c = nRows*blockDim.x*by+blockDim.x*bx;
	C[c+nRows*ty+tx] = Csub;
		


}


__global__ void dataKernel(double* data, double* A, double* B, int nsteps, double *temp1, double *temp2, double* temp3){
//this adds a value to a variable stored in global memory


	int tx = threadIdx.x;
	int ty = threadIdx.y;
	int thid = tx + blockDim.x*ty;

	int i = 0;
	while(i < nsteps)
	{
		temp3[thid] = sin(data[thid]);
		__syncthreads();
	
		Muldev(data, data, temp1, 2);
		__syncthreads();
		Muldev(B, data, temp2, 2);
		__syncthreads();
		Muldev(A, temp3, temp3, 2);
		__syncthreads();


		data[thid] = temp1[thid]+temp2[thid]+temp3[thid];
		__syncthreads();
		i = i+1;
	}
}


int main(int argc, char** argv)
{


	double hA[4] = {.6, -.1, .6, 1.95};
	double hB[4] = {1/150, .1/150, -.1/150, -1/150};
	double hC[4] = {.3, .3, -.5, -.25};
	double* dA;
	double* dB;
	double* dC;
	double *temp1, *temp2, *temp3;
	int nRows = 2;
	int TileSize = 2;

	int size = 4*sizeof(double);
	int nSteps = atoi(argv[1]);

	cudaMalloc((void**)&dA, size);
	cudaMalloc((void**)&dB, size);
	cudaMalloc((void**)&dC, size);
	cudaMalloc((void**)&temp1, size);
	cudaMalloc((void**)&temp2, size);
	cudaMalloc((void**)&temp3, size);
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dC, hC, size, cudaMemcpyHostToDevice);

	dim3 dimBlock(TileSize, TileSize);
	dim3 dimGrid(nRows/TileSize, nRows/TileSize);

	double *monitor_data;
	cudaMallocHost((void**)&monitor_data, sizeof(double));
	cudaStream_t stream1;
	cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);	


	dataKernel<<<dimGrid, dimBlock, sizeof(double)*TileSize*TileSize*TileSize*TileSize>>>(dC, dA, dB, nSteps, temp1, temp2, temp3);

		cout <<"Launching Monitor Kernel" << endl;
	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, &dC[1]);
	cout <<"Launching Async Mem Cpy" << endl;
	//cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cout << "Value monitored over: "  << *monitor_data*100 << endl;
	cudaStreamSynchronize(stream1);

	sleep(.001);
		cout <<"Launching Monitor Kernel" << endl;
	monitorKernel<<<1, 1,0, stream1>>>(monitor_data, &dC[1]);
	cout <<"Launching Async Mem Cpy" << endl;
	//cudaMemcpyAsync(h_data, monitor_data, sizeof(int), cudaMemcpyDeviceToHost, stream1);
	cout << "Value monitored over: "  << *monitor_data*100 << endl;
	cudaStreamSynchronize(stream1);

	cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);

	int i = 0;
	for(i = 0; i < 4; i++)
		cout << "hC: " << hC[i]*100 << endl;


	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

return 0;
}
	/*int *dVal;
	int size = sizeof(bool);

	//pointer of helper function return	asdfasdfasdf
	int transfered_data;
	int *h_data = &transfered_data;
	int *monitor_data;
	bool k_stop_cmd = 1;
	bool *host_stop_kernel = &k_stop_cmd;

	bool bool_test = 0;
	bool *test_value = &bool_test;
	
	cudaMallocHost((void**)&host_stop_kernel, size);
	*host_stop_kernel = 1;

	cudaMalloc((void**)&stop_kernel, size);
	
	bool *stop_kern_ptr;
	cudaGetSymbolAddress((void**)&stop_kern_ptr, stop_kernel);

	cudaMalloc((void**)&dVal, sizeof(int));
	cudaMallocHost((void**)&monitor_data, sizeof(int));	


	cudaStream_t stream1;
	cudaStreamCreateWithFlags(&stream1, cudaStreamNonBlocking);
	
	dataKernel<<<1, 1>>>(dVal, stop_kern_ptr);

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


	cout << "Stopping Kernel " << *host_stop_kernel << endl;
	cudaMemcpyAsync(stop_kern_ptr, host_stop_kernel, sizeof(bool), cudaMemcpyHostToDevice, stream1);
	cudaStreamSynchronize(stream1);
	
	cudaMemcpyAsync(test_value, stop_kern_ptr, sizeof(bool), cudaMemcpyDeviceToHost, stream1);
	
	cudaStreamSynchronize(stream1);
cout << "if stop_kernel in global memory of device then this better be 1: " << *test_value << endl;

	cudaMemcpy(h_data, dVal, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "Value copied over: "  << *h_data << endl;
return 0;*/





__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr){

	*write_2_ptr = *read_in_ptr;
}



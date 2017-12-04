#include<cuda.h>
#include<iostream>

using namespace std;


__global__ void simpleKernel(int* data, int size){
//this adds a value to a variable stored in global memory
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	if(thid < size)
	data[thid] = (blockIdx.x+ threadIdx.x);
}

int main()
{
	const int numElems = 16;
	int hostArray[numElems], *dArray;
	int i = 0;
	cudaMalloc((void**)&dArray, sizeof(int)*numElems);
	cudaMemset(dArray, 0, numElems*sizeof(int));
	
	simpleKernel<<<2, 8>>>(dArray, numElems);
	cudaMemcpy(&hostArray, dArray, sizeof(int)*numElems, cudaMemcpyDeviceToHost);

	cout << "Values in hostArray: " << endl;
	for(i = 0; i < numElems; i++)
		cout << hostArray[i] << endl;
	cudaFree(dArray);
	return 0;
}

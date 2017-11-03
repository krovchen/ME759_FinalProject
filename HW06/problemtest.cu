#include<cuda.h>
#include<iostream>

using namespace std;


__global__ void simpleKernel(int* data){
//this adds a value to a variable stored in global memory
	//int thid = threadIdx.x+blockIdx.x*blockDim.x;
	//if(thid < size)
	data[threadIdx.x] += 2*(blockIdx.x+threadIdx.x);
}

int main()
{
	const int numElems = 4;
	int hostArray[numElems], *devArray;
	int testArray[numElems];
	int i = 0;

	cudaMalloc((void**)&devArray, sizeof(int)*numElems);
	//set devArray to 0 all elements
	cudaMemset(devArray, 0, numElems*sizeof(int));
	//expecting this to set testArray to devArray	
	cudaMemcpy(&testArray, devArray, sizeof(int)*numElems, cudaMemcpyDeviceToHost);

	//here run kernel. same as lecture slide
	simpleKernel<<<1, 4>>>(devArray);


	//now copy devArray to hostArray to get the same answer in lecture
	cudaMemcpy(&hostArray, devArray, sizeof(int)*numElems, cudaMemcpyDeviceToHost);

	cout << "Values in hostArray: " << endl;
	for(i = 0; i < numElems; i++)
		cout << hostArray[i] << endl;
	cout << "Values in testArray: " << endl;
	for(i = 0; i < numElems; i++)
		cout << testArray[i] << endl;
	cudaFree(devArray);


	return 0;
}

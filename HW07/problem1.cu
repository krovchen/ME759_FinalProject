#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;

int* read_array(const char* filename, int len) {
	int *x = (int*) malloc(len * sizeof(int));
	FILE *fp = fopen(filename, "r");
	for (int i = 0; i < len; i++) {
		fscanf(fp, "%d", &x[i]);
	}
	fclose(fp);
	return x;
}

void matxvec(int *hA, int *hB, int *hC, int rowWidth, int colWidth){
	int i = 0;
	int j = 0;

	for(i=0; i < colWidth; i++){
		int locsum = 0;
		for(j = 0; j < rowWidth; j++){
			locsum = locsum + hA[i*rowWidth+j]*hB[j];
		}		
		hC[i] = locsum;
	}


}


__global__ void multKernel(int* dA, int* dB, int* dC, int rowWidth, int colWidth){
	//__shared__ int B[rowWidth];
	//B = dB;
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	int locsum = 0;
	if(thid < rowWidth*colWidth){
		locsum = dA[thid]*dB[threadIdx.x];
		dC[thid] += locsum;
	}
}


int main(int argc, char *argv[]) {
	if (argc != 1) {
		printf("Invalid argument Usage: ./problem1");
		return -1;
	}

	const int rowWidth=4;//32;
        const int colWidth=2;//16;
	int i = 0;	
	int *hA = read_array("inputA1.inp",rowWidth*colWidth );
	int *hB = read_array("inputB1.inp", rowWidth);
	int *hC = (int*) malloc(colWidth * sizeof(int));
	int *refC = (int*) malloc(colWidth * sizeof(int));
	// TODO - allocate host memory for refC (you have to figure out how much)
	// The skeleton currently segfaults because refC is accessed without allocation

	// TODO do a reference host implementation (Ch) here. ie populate answer in refC
	matxvec(hA, hB, refC, rowWidth, colWidth);



	int *dA, *dB, *dC;
	// TODO allocate device memory for dA,dB and dC
	// TODO copy data from host to GPU 
	cudaMalloc((void**)&dA, sizeof(int)*rowWidth*colWidth);
	cudaMemcpy(dA, hA, sizeof(int)*rowWidth*colWidth, cudaMemcpyHostToDevice);

	cudaMalloc((void**)&dB, sizeof(int)*rowWidth);
	cudaMemcpy(dB, hC, sizeof(int)*rowWidth, cudaMemcpyHostToDevice);

	cudaMalloc((void**)&dC, sizeof(int)*colWidth);
	cudaMemset(dC, 0, sizeof(int)*colWidth);


	// TODO call your kernel
	multKernel<<<colWidth, rowWidth>>>(dA, dB, dC, rowWidth, colWidth);

	// TODO copyback results
	cudaMemcpy(hC, dC, sizeof(int)*colWidth, cudaMemcpyDeviceToHost);

	float Error=0;

	for(int i=0;i<colWidth;i++)
		Error+=(hC[i]-refC[i])*(hC[i]-refC[i]);
	printf("%f\n%d",sqrt(Error),hC[colWidth-1]);

	free(refC);
	free(hB);
	free(hA);
	free(hC);

	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);


	return 0;
}

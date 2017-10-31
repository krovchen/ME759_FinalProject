#ifdef _WIN32
#  define NOMINMAX 
#endif

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
// includes, project

// includes, kernels

////////////////////////////////////////////////////////////////////////////////
// declaration, forward

double* read_array(const char* filename, int len) {
	double *x = (double*) malloc(len * sizeof(double));
	FILE *fp = fopen(filename, "r");
	for (int i = 0; i < len; i++) {
		fscanf(fp, "%lf", &x[i]);
	}
	fclose(fp);
	return x;
}

void computeOnDevice(double* hA,double* hB, double* hC, int nRows, int tileSize, float* incTime );

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////

int main( int argc, char** argv) 
{
	if(argc!=2)
	{
		printf("Usage: ./problem2 N\n");
		return 0;
	}
	int nRows = 1024;
	int num_elements = nRows*nRows;
	int tileSize = atoi(argv[1]);  //change this for scaling analysis
	float incTime=0; // Time for GPU
	double* hA = read_array("inputA.inp",num_elements);
	double* hB = read_array("inputB.inp",num_elements);
	double* hC = (double*) malloc(num_elements * sizeof(double));

	// **===-------- Modify the body of this function -----------===**
	computeOnDevice( hA, hB,hC, nRows, tileSize, &incTime);
	// **===-----------------------------------------------------------===**


	printf("%f\n%f\n%d\n",hC[num_elements-1],incTime,tileSize);
	// cleanup memory
	free(hA);
	free(hB);
	free(hC);

	return 0;
}



__global__ void Muldev(double* A, double* B, double* C, int nRows)
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
		
		for(k = 0; k < blockDim.x; ++k)
			

			Csub+=As[ty*blockDim.x+k]*Bs[k*blockDim.x+tx];
			
		__syncthreads();
	}

	int c = nRows*blockDim.x*by+blockDim.x*bx;
	C[c+nRows*ty+tx] = Csub;
		


}

void computeOnDevice(double* hA,double* hB, double* hC, int nRows, int TileSize, float* incTime)
{
	double* dA;
	double* dB;
	double* dC;
	cudaEvent_t startEvent_inc;
	cudaEvent_t stopEvent_inc;
	cudaEventCreate(&startEvent_inc);
	cudaEventCreate(&stopEvent_inc);

	int size = nRows*nRows*sizeof(double);

	cudaEventRecord(startEvent_inc,0);

	cudaMalloc((void**)&dA, size);
	cudaMalloc((void**)&dB, size);
	cudaMalloc((void**)&dC, size);
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);
	
	dim3 dimBlock(TileSize, TileSize);
	dim3 dimGrid(nRows/TileSize, nRows/TileSize);

	
	Muldev<<<dimGrid, dimBlock, sizeof(double)*TileSize*TileSize*TileSize*TileSize>>>(dA, dB, dC, nRows);
	cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);
	cudaEventRecord(stopEvent_inc,0);  //ending timing for inclusive
	cudaEventSynchronize(stopEvent_inc);   
	cudaEventElapsedTime(incTime, startEvent_inc, stopEvent_inc);

	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

	return;//Placeholder
}



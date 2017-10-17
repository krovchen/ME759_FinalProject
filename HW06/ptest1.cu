#include<iostream>
#include<stdio.h>
#include<cuda.h>

using namespace std;

__global__ void addKernel(double* arrA, double* arrB, double* arrC, int N){
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	if(thid < N)
	arrC[thid] = threadIdx.x;
}


int main( int argc, char *argv[])
{

	if(argc!=3)
	{
		printf("Invalid argument Usage: ./problem3 N M");
		return 0;
	}

	cout << "HEre we go!" << "\n";


	int N = atoi(argv[1]);
	int M = atoi(argv[2]); 
	double *hA= new double[N];
	double *hB= new double[N];
	double *hC=  new double[N];
	double *refC=  new double[N]; // Used to verify functional correctness
	double *dA,*dB,*dC;  // You may use these to allocate memory on gpu
	//defining variables for timing


	int nBlocks = N/M;
	float blockRem = N/M - nBlocks;
	if(blockRem != 0)
	nBlocks = nBlocks+1;
	cout << "blocks used: " << nBlocks << "\n";
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";


      for(int i=0;i<N;i++)
        refC[i]=hA[i]+hB[i];

	cout << "starting cuda stuff" << "\n";
	cout << "right before record" << "\n";
	cudaEventRecord(startEvent_inc,0);

	cout << "right after record"  << "\n";
 // starting timing for inclusive
	// TODO allocate memory for arrays and copay array A and B
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";

	cudaMalloc((void**)&dA, sizeof(double)*N);
	cout << "dA allocated" << "\n";
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";
	cudaMemcpy(&dA, hA, sizeof(double)*N, cudaMemcpyHostToDevice);
	cout << "dA copied " << "\n";
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";
	cudaMalloc((void**)&dB, sizeof(double)*N);
	cout << "dB allocated" << "\n";
	cudaMemcpy(&dB, hB, sizeof(double)*N, cudaMemcpyHostToDevice);
	cout << "dB copied " << "\n";
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";
	cudaMalloc((void**)&dC, sizeof(double)*N);
	cout << "dC copied " << "\n";
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";
	//cudaMemset(dC, 1, sizeof(double)*N);

	cout << "trying to copy hC to dC" << "\n";
	cudaMemcpy(hC, dC, sizeof(double)*N, cudaMemcpyDeviceToHost);
	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";
	cout << "copied hC to dC " << "\n";
	//cout << "first value of host array after copying back dC is: " << hC[0] << "\n";
	
	cout << "alocated memory" << "\n";
	cudaEventRecord(startEvent_exc,0); // staring timing for exclusive


	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";

	addKernel<<<nBlocks, M>>>(dA, dB, dC, N);


	cout << "N = " << N << "\n";
	cout << "M = " << M << "\n";

	cout << "ran kernel" << "\n";

	// TODO copy data back
	cudaMemcpy(hC, dC, sizeof(double)*N, cudaMemcpyDeviceToHost);



	cout << "time to print results: " << "\n";
	cout<<N<<"\n";
	cout<<M<<"\n";

	cout <<hC[N-1]<<"\n";
	//freeing memory
	delete[] hA,hB,hC,refC;     

	// TODO free CUDA memory allocated
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

	return 0;
}



	
	







#include<iostream>
#include<stdio.h>
#include<cuda.h>

using namespace std;

__global__ void addKernel(double* arrA, double* arrB, double* arrC, int N){
	int thid = threadIdx.x+blockIdx.x*blockDim.x;
	if(thid < N)
	arrC[thid] = arrA[thid]; //+arrB[thid];
}


int main( int argc, char *argv[])
{

	if(argc!=3)
	{
		printf("Invalid argument Usage: ./problem3 N M");
		return 0;
	}

	cout << "HEre we go!" << "\n";

	FILE *fpA,*fpB;
	int N = atoi(argv[1]);
	int M = atoi(argv[2]); 
	double *hA= new double[N];
	double *hB= new double[N];
	double *hC=  new double[N];
	double *refC=  new double[N]; // Used to verify functional correctness
	double *dA,*dB,*dC;  // You may use these to allocate memory on gpu
	//defining variables for timing
	cudaEvent_t startEvent_inc, stopEvent_inc, startEvent_exc, stopEvent_exc;
	cudaEventCreate(&startEvent_inc);
	cudaEventCreate(&stopEvent_inc);
	cudaEventCreate(&startEvent_exc);
	cudaEventCreate(&stopEvent_exc);
	float elapsedTime_inc, elapsedTime_exc;

	//reading files
	fpA = fopen("inputA.inp", "r");
	fpB= fopen("inputB.inp", "r");


	for (int i=0;i<N;i++){    
		fscanf(fpA, "%lf",&hA[i]);
	}
	for (int i=0;i<N;i++){
		fscanf(fpB, "%lf",&hB[i]);
	}



	int nBlocks = N/M;
	float blockRem = N/M - nBlocks;
	if(blockRem != 0)
	nBlocks = nBlocks+1;
	cout << "blocks used: " << nBlocks << "\n";


      for(int i=0;i<N;i++)
        refC[i]=hA[i]+hB[i];

	cout << "starting cuda stuff" << "\n";
	cudaEventRecord(startEvent_inc,0); // starting timing for inclusive
	// TODO allocate memory for arrays and copay array A and B
	cudaMalloc((void**)&dA, sizeof(double)*N);
	cudaMemcpy(&dA, hA, sizeof(double)*N, cudaMemcpyHostToDevice);
	cudaMalloc((void**)&dB, sizeof(double)*N);
	cudaMemcpy(&dB, hB, sizeof(double)*N, cudaMemcpyHostToDevice);
	cudaMalloc((void**)&dC, sizeof(double)*N);
	//cudaMemset(dB, 0, sizeof(double)*N);
	
	cout << "alocated memory" << "\n";
	cudaEventRecord(startEvent_exc,0); // staring timing for exclusive

	addKernel<<<nBlocks, M>>>(dA, dB, dC, N);

	cout << "ran kernel" << "\n";
	cudaEventRecord(stopEvent_exc,0);  // ending timing for exclusive
	cudaEventSynchronize(stopEvent_exc);   
	cudaEventElapsedTime(&elapsedTime_exc, startEvent_exc, stopEvent_exc);

	// TODO copy data back
	cudaMemcpy(&hC, dC, sizeof(double)*N, cudaMemcpyDeviceToHost);

	cout << "copied mem back" << "\n";
	cudaEventRecord(stopEvent_inc,0);  //ending timing for inclusive
	cudaEventSynchronize(stopEvent_inc);   
	cudaEventElapsedTime(&elapsedTime_inc, startEvent_inc, stopEvent_inc);



	//verification
	int count=0;
	for(int i=0;i<N;i++)
	{
		cout << hC[i]  << "\n";
		cout << hA[i] << "\n";
		if(hC[i]!=hA[i]) //refC[i])
		{
			count++;
		}
	}
	if(count!=0) // This should never be printed in correct code
		std::cout<<"Error at "<< count<<" locations\n";
	std::cout<<N<<"\n"<<M<<"\n"<<elapsedTime_exc<<"\n"<<elapsedTime_inc<<"\n"<<hC[N-1]<<"\n";
	//freeing memory
	delete[] hA,hB,hC,refC;     

	// TODO free CUDA memory allocated
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

	return 0;
}



	
	







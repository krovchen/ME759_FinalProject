#include<iostream>
#include<stdlib.h>
#include <cuda.h>
#include <math.h>

#define RADIUS 3

int checkResults(int startElem, int endElem, float* cudaRes, float* res)
{
    int nDiffs=0;
    const float smallVal = 0.0001f;
    for(int i=startElem; i<endElem; i++)
        if(fabs(cudaRes[i]-res[i])>smallVal)
            nDiffs++;
    return nDiffs;
}

void initializeWeights(float* weights, int rad)
{
    // for now hardcoded for RADIUS=3
    weights[0] = 0.50f;
    weights[1] = 0.75f;
    weights[2] = 1.25f;
    weights[3] = 2.00f;
    weights[4] = 1.25f;
    weights[5] = 0.75f;
    weights[6] = 0.50f;
}

void initializeArray(FILE* fp,float* arr, int nElements)
{
    for( int i=0; i<nElements; i++){
        	int r=fscanf(fp,"%f",&arr[i]);
		if(r == EOF){
		  rewind(fp);
		}
    }
}

void applyStencil1D_SEQ(int sIdx, int eIdx, const float *weights, float *in, float *out) {
  
  for (int i = sIdx; i < eIdx; i++) {   
    out[i] = 0;
    //loop over all elements in the stencil
    for (int j = -RADIUS; j <= RADIUS; j++) {
      out[i] += weights[j + RADIUS] * in[i + j]; 
    }
    out[i] = out[i] / (2 * RADIUS + 1);
  }
}

__global__ void applyStencil1D(int sIdx, int eIdx, const float *weights, float *in, float *out) {
   // int i = sIdx + blockIdx.x*blockDim.x + threadIdx.x;
    __shared__ volatile float sharedInput[512];


    int sInd = threadIdx.x;
    int bInd = threadIdx.x+blockIdx.x*blockDim.x;

    if(bInd < sIdx+eIdx)
    sharedInput[sInd] = in[bInd];

    __syncthreads();
    __threadfence_block();


if((bInd-sIdx) < eIdx){
		    
		float result = 0.f;
		if(sInd < 509 && sInd > 2){
		 	
       			result += weights[0]*sharedInput[sInd-3];
        		result += weights[1]*sharedInput[sInd-2];
        		result += weights[2]*sharedInput[sInd-1];
        		result += weights[3]*sharedInput[sInd];
       	 		result += weights[4]*sharedInput[sInd+1];
        		result += weights[5]*sharedInput[sInd+2];
        		result += weights[6]*sharedInput[sInd+3];
			result /=7.f;
   			out[bInd] = result;
			}
		if(sInd == 509){
       		 	result += weights[0]*sharedInput[sInd-3];
        		result += weights[1]*sharedInput[sInd-2];
        		result += weights[2]*sharedInput[sInd-1];
        		result += weights[3]*sharedInput[sInd];
       	 		result += weights[4]*sharedInput[sInd+1];
        		result += weights[5]*sharedInput[sInd+2];
        		result += weights[6]*in[bInd+3];
			result /=7.f;
   			out[bInd] = result;
			}
		if(sInd == 510){
	       		 result += weights[0]*sharedInput[sInd-3];
        		result += weights[1]*sharedInput[sInd-2];
        		result += weights[2]*sharedInput[sInd-1];
        		result += weights[3]*sharedInput[sInd];
       	 		result += weights[4]*sharedInput[sInd+1];
        		result += weights[5]*in[bInd+2];
        		result += weights[6]*in[bInd+3];
			result /=7.f;
   			out[bInd] = result;
			}
		if(sInd == 511){
			result += weights[0]*sharedInput[sInd-3];
        		result += weights[1]*sharedInput[sInd-2];
        		result += weights[2]*sharedInput[sInd-1];
        		result += weights[3]*sharedInput[sInd];
       	 		result += weights[4]*in[bInd+1];
        		result += weights[5]*in[bInd+2];
        		result += weights[6]*in[bInd+3];
			result /=7.f;
   			out[bInd] = result;
			}	
		if(blockIdx.x > 0){
			if(sInd == 2){
				result += weights[0]*in[bInd-3];
        			result += weights[1]*sharedInput[sInd-2];
        			result += weights[2]*sharedInput[sInd-1];
        			result += weights[3]*sharedInput[sInd];
       	 			result += weights[4]*sharedInput[sInd+1];
        			result += weights[5]*sharedInput[sInd+2];
        			result += weights[6]*sharedInput[sInd+3];
				result /=7.f;
   				out[bInd] = result;
				}
			if(sInd == 1){				
				result += weights[0]*in[bInd-3];
        			result += weights[1]*in[bInd-2];
        			result += weights[2]*sharedInput[sInd-1];
        			result += weights[3]*sharedInput[sInd];
       	 			result += weights[4]*sharedInput[sInd+1];
        			result += weights[5]*sharedInput[sInd+2];
        			result += weights[6]*sharedInput[sInd+3];
				result /=7.f;
   				out[bInd] = result;
				}
			if(sInd == 0){
				result += weights[0]*in[bInd-3];
        			result += weights[1]*in[bInd-2];
        			result += weights[2]*in[bInd-1];
        			result += weights[3]*sharedInput[sInd];
       	 			result += weights[4]*sharedInput[sInd+1];
        			result += weights[5]*sharedInput[sInd+2];
        			result += weights[6]*sharedInput[sInd+3];
				result /=7.f;
   				out[bInd] = result;
				}
		}

		
   }
   /* if( i < eIdx ) {
        float result = 0.f;
        result += weights[0]*in[i-3];
        result += weights[1]*in[i-2];
        result += weights[2]*in[i-1];
        result += weights[3]*in[i];
        result += weights[4]*in[i+1];
        result += weights[5]*in[i+2];
        result += weights[6]*in[i+3];
        result /=7.f;
        out[i] = result;
    }*/
}

int main(int argc, char* argv[]) {
  if(argc!=2){
	printf("Usage %s N\n",argv[0]);
	return 1;
  }
  int N=atoi(argv[1]);
  FILE *fp = fopen("problem1.inp","r");
  int size = N * sizeof(float); 
  int wsize = (2 * RADIUS + 1) * sizeof(float); 
  //allocate resources
  float *weights = (float *)malloc(wsize);
  float *in      = (float *)malloc(size);
  float *out     = (float *)malloc(size); 
  float *cuda_out= (float *)malloc(size);
  float time = 0.f;
  initializeWeights(weights, RADIUS);
  initializeArray(fp,in, N);
  float *d_weights;  cudaMalloc(&d_weights, wsize);
  float *d_in;       cudaMalloc(&d_in, size);
  float *d_out;      cudaMalloc(&d_out, size);

	cudaEvent_t startEvent_inc;
	cudaEvent_t stopEvent_inc;
	cudaEventCreate(&startEvent_inc);
	cudaEventCreate(&stopEvent_inc);
	cudaEventRecord(startEvent_inc,0);
  
  cudaMemcpy(d_weights,weights,wsize,cudaMemcpyHostToDevice);
  cudaMemcpy(d_in, in, size, cudaMemcpyHostToDevice);
  applyStencil1D<<<(N+511)/512, 512, 512*sizeof(float)>>>(RADIUS, N-RADIUS, d_weights, d_in, d_out);
  cudaMemcpy(cuda_out, d_out, size, cudaMemcpyDeviceToHost);

	cudaEventRecord(stopEvent_inc,0);  //ending timing for inclusive
	cudaEventSynchronize(stopEvent_inc);   
	cudaEventElapsedTime(&time, startEvent_inc, stopEvent_inc);



  applyStencil1D_SEQ(RADIUS, N-RADIUS, weights, in, out);
  int nDiffs = checkResults(RADIUS, N-RADIUS, cuda_out, out);

  if(nDiffs)printf("Test Failed\n"); // This should never print
  printf("%f\n%f\n",cuda_out[N-RADIUS-1],time);

  
  //free resources 
  free(weights); free(in); free(out); free(cuda_out);
  cudaFree(d_weights);  cudaFree(d_in);  cudaFree(d_out);
  return 0;
}

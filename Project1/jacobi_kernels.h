/*
* Copyright 1993-2006 NVIDIA Corporation.  All rights reserved.
*
* NOTICE TO USER:   
*
* This source code is subject to NVIDIA ownership rights under U.S. and 
* international Copyright laws.  
*
* This software and the information contained herein is PROPRIETARY and 
* CONFIDENTIAL to NVIDIA and is being provided under the terms and 
* conditions of a Non-Disclosure Agreement.  Any reproduction or 
* disclosure to any third party without the express written consent of 
* NVIDIA is prohibited.     
*
* NVIDIA MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE 
* CODE FOR ANY PURPOSE.  IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR 
* IMPLIED WARRANTY OF ANY KIND.  NVIDIA DISCLAIMS ALL WARRANTIES WITH 
* REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF 
* MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.   
* IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, 
* OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS 
* OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
* OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
* OR PERFORMANCE OF THIS SOURCE CODE.  
*
* U.S. Government End Users.  This source code is a "commercial item" as 
* that term is defined at 48 C.F.R. 2.101 (OCT 1995), consisting  of 
* "commercial computer software" and "commercial computer software 
* documentation" as such terms are used in 48 C.F.R. 12.212 (SEPT 1995) 
* and is provided to the U.S. Government only as a commercial end item.  
* Consistent with 48 C.F.R.12.212 and 48 C.F.R. 227.7202-1 through 
* 227.7202-4 (JUNE 1995), all U.S. Government End Users acquire the 
* source code with only those rights set forth herein.
*/





#ifndef _JACOBIKERNEL_H_
#define _JACOBIKERNEL_H_


#include<cuda.h>
#include<iostream>
#include<stdio.h>
#include "omp.h"
#include <unistd.h>
#include <sys/time.h>
#include "main_fcn.h"

//global variables
const int Ni = 64;
const int Nj = 64;
const int numElems =Ni*Nj;
static int tileSize = Ni;
static int iter = 100000;
static int els_to_read = 64;

struct help_input_from_main{
	
	//pointers to things on device
	double *x_now_d;
	double *x_next_d;
	double *A_d;
	double *b_d;

	double b_h[Ni];
	double A_h[numElems];
	int nTiles;

	void initS(double* v1, double* Ain){
		int i = 0;
		for(i = 0; i <  Ni; i++){
			b_h[i] = v1[i];
		}
		for(i = 0; i < numElems; i++)
			A_h[i] = Ain[i];
	}

};


 bool main_fcn(ctrl_flags CF, double* help_out, help_input_from_main* help_input_ptr);
 bool help_fcn(help_input_from_main help_input, double* out);
//__global__ void dataKernel( double* data, int nsteps);
__global__ void monitorKernel(double * write_2_ptr,  double * read_in_ptr);
__global__ void jacobiOptimizedOnDevice(double* x_next, double* A, double* x_now, double* b, int Ni, int Nj);

void gen_b_vec(double* inp1);
void gen_A_mat(double* A);


#endif // _JACOBIKERNEL_H_


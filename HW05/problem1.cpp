#include <fstream>
#include <iostream>
#include <vector>
#include <omp.h>
#include "math.h"
#include <chrono>

using namespace std;

#define nrows 1800
#define ncols 1200


int main(int argc, char *argv[]) {

	size_t size = nrows*ncols;
	int i;
	int temp;
	int j=0;
	double mintime;


	int ncounts[7] = {0,0,0,0,0,0, 0};

	int nthreads = atoi(argv[1]);
	
	int num0 = 0;
	int num1 = 0;
	int num2 = 0;
	int num3 = 0;
	int num4 = 0;
	int num5 = 0;
	int num6 = 0;

	
	vector<int> in_vec(size);

	ifstream file_in;
	file_in.open("picture.inp");

	for(i = 0; i < size; i++)
	{
		file_in >> temp;
		in_vec[i] =temp;

	}
	for(j = 0; j < 10; j++)
	{
	num0=0;
	num1=0;
	num2=0;
	num3=0;
	num4=0;
	num5=0;
	num6=0;

	auto t1 = std::chrono::high_resolution_clock::now();

	#pragma omp parallel num_threads(nthreads) 
	{
	#pragma omp for reduction(+:num0, num1, num2, num3, num4, num5, num6)
	
	
	
		for(i = 0; i < size; i++)
		{
			if(in_vec[i] == 0) num0++;
			if(in_vec[i] == 1) num1++;
			if(in_vec[i] == 2) num2++;
			if(in_vec[i] == 3) num3++;
			if(in_vec[i] == 4) num4++;
			if(in_vec[i] == 5) num5++;
			if(in_vec[i] == 6) num6++;
		}
	
	}
	auto t2 = std::chrono::high_resolution_clock::now();
	if(j == 0) mintime =  std::chrono::duration_cast<std::chrono::microseconds>(t2-t1).count()/1000.0;
	else mintime = min((std::chrono::duration_cast<std::chrono::microseconds>(t2-t1).count())/1000.0, mintime);
	//cout << std::chrono::duration_cast<std::chrono::milliseconds>(end-begin).count(); << endl;
	//cout << mintime << endl;
}

	

	cout << num0 << endl;
	cout << num1 << endl;
	cout << num2 << endl;
	cout << num3 << endl;
	cout << num4 << endl;
	cout << num5 << endl;
	cout << num6 << endl;
	//cout << num0+num1+num2+num3+num4+num5+num6 << endl;
	//cout << size << endl;
	cout << nthreads << endl;
	cout << mintime << endl;


}

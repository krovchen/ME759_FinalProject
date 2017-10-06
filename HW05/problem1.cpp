#include <fstream>
#include <iostream>
#include <vector>
#include "stopwatch.hpp"
#include <omp.h>

using namespace std;

#define nrows 1800
#define ncols 1200


int main() {

	size_t size = nrows*ncols;
	int i;
	int temp;
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
		in_vec[i] = temp;
		

	}

	#pragma omp parallel num_threads(5)
	{
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
	cout << num0 << endl;
	cout << num1 << endl;
	cout << num2 << endl;
	cout << num3 << endl;
	cout << num4 << endl;
	cout << num5 << endl;
	cout << num6 << endl;
	cout << num0+num1+num2+num3+num4+num5+num6 << endl;
	cout << size << endl;


}

#include <iostream>
#include <list>
#include <vector>
#include <ctime>
#include <fstream>

using namespace std;

#define NSTART 8
#define NEND 13

void write2file(double *arr, ofstream& myFile);

int main(){

	int N = 2;
	int i = 0;
	int j = 0;
	list<int> myList = {};
	vector<int> myVec;
	myVec.reserve(1 << NEND); //reserve the space for the vector now
	vector<int>::iterator itvec;
	double timePassed;
	double partAtimes[NEND-NSTART+1];
	double partBtimes[NEND-NSTART+1];
	double partCtimes[NEND-NSTART+1];
	double partAtimesArr[NEND-NSTART+1];
	double partBtimesArr[NEND-NSTART+1];
	double partCtimesArr[NEND-NSTART+1];
	clock_t begin;
	clock_t end;

	ofstream listFile;
	listFile.open("problem1_list.out");

	ofstream vecFile;
	vecFile.open("problem1_array.out");


	srand(0);

	for(N = NSTART; N<=NEND; N++){
		// part A -- insert 2^N values in front of list
		//do this for list
		for(j = 0; j < 10; j++){
			begin = clock();
			for(i = 0; i < 1<<N; i++){
				myList.push_front(rand());
			}
			end = clock();
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			
			
			if(j != 0){
				partAtimes[N-NSTART] = min(timePassed, partAtimes[N-NSTART]);
			}
			else{
				partAtimes[N-NSTART] = timePassed;
			}
		
			myList.clear();
		}

		//now do this for vector
		for(j = 0; j < 10; j++){
			begin = clock();
			for(i = 0; i < 1<<N; i++){
				itvec = myVec.begin();
				myVec.insert(itvec, rand());
			}
			end = clock();
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			if(j != 0){
				partAtimesArr[N-NSTART] = min(timePassed, partAtimesArr[N-NSTART]);
			}
			else{
				partAtimesArr[N-NSTART] = timePassed;
			}			

			myVec.clear();
		}
		
		
		
		//part B -- insert 2^N values in back of list
		for(j = 0; j < 10; j++){
			begin = clock();
			for(i = 0; i < 1 << N; i++){
				myList.push_back(rand());	
			}
			end = clock();		
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			if(j != 0){
				partBtimes[N-NSTART] = min(timePassed, partBtimes[N-NSTART]);
			}
			else{
				partBtimes[N-NSTART] = timePassed;
			}
		
			myList.clear();
		}
		
		//now do this for vector
		for(j = 0; j < 10; j++){
			begin = clock();
			for(i = 0; i < 1<<N; i++){
				
				myVec.push_back(rand());
			}
			end = clock();
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			if(j != 0){
				partBtimesArr[N-NSTART] = min(timePassed, partBtimesArr[N-NSTART]);
			}
			else{
				partBtimesArr[N-NSTART] = timePassed;
			}			

			myVec.clear();
		}



		//part C -- insert 2^N values in middle of list
		auto it = myList.begin();
		for(j = 0; j < 10; j++){
			it = myList.begin();
			begin = clock();
			for(i = 0; i < 1<<N; i++){
				myList.insert(it,i);
				if((i%2) == 0){
					it--;
				}
		
			}
			end = clock();
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			if(j != 0){
				partCtimes[N-NSTART] = min(timePassed, partCtimes[N-NSTART]);
			}
			else{
				partCtimes[N-NSTART] = timePassed;
			}
		}


		//now do this for vector
		for(j = 0; j < 10; j++){
			itvec = myVec.begin();
			begin = clock();
			for(i = 0; i < 1<<N; i++){
				myVec.insert(itvec, rand());
				if((i%2) == 0){
					advance(itvec, 1);
				}
			}
			end = clock();
			timePassed = double(end - begin) / CLOCKS_PER_SEC*1000;
			if(j != 0){
				partCtimesArr[N-NSTART] = min(timePassed, partCtimesArr[N-NSTART]);
			}
			else{
				partCtimesArr[N-NSTART] = timePassed;
			}			

			myVec.clear();
		}


		


	}
	write2file(partAtimes, listFile);
	write2file(partBtimes, listFile);
	write2file(partCtimes, listFile);
	listFile.close();

	write2file(partAtimesArr, vecFile);
	write2file(partBtimesArr, vecFile);
	write2file(partCtimesArr, vecFile);
	vecFile.close();

}


void write2file(double *arr, ofstream& myFile){
	int i = 0;
	for(i = 0; i < NEND-NSTART+1; i++){
		myFile << NSTART+i;
		myFile << ' ';
		myFile << *arr << endl;
		arr++;
	}

	return;

}






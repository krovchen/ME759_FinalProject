#include <fstream>
#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>
#include "stopwatch.hpp"


using namespace std;

struct point3Da {
	float x, y, z;
};

struct point3Db {
	float x, y, z;
	char mychar;
};

struct point3Dc {
	float x, y, z;
	char mychar[52];
};

int main() {
	ofstream fout{"problem2.out"};

	auto min_timea = [&fout](array_view<float> const& xa) {
		fout << *min_element(xa.begin(), xa.end()) << '\n';
	};

	auto min_timeb = [&fout](array_view<float> const& xb) {
		fout << *min_element(xb.begin(), xb.end()) << '\n';
	};

	auto min_timec = [&fout](array_view<float> const& xc) {
		fout << *min_element(xc.begin(), xc.end()) << '\n';
	};
	constexpr auto size = 1'000'000UL;
	cout << sizeof(point3Da) << endl;
	cout << sizeof(point3Db) << endl;
	cout << sizeof(point3Dc) << endl;
	stopwatch<milli, float> swa;
	stopwatch<milli, float> swb;
	stopwatch<milli, float> swc;
	vector<point3Da> xa(size);
	vector<point3Db> xb(size);
	vector<point3Dc> xc(size);

	/*
	 * Note that this is really just a dummy variable we are using
	 * to prevent the compiler from optimizing away our calculations.
	 */
	volatile float sum{};
	auto fa = [&xa, &sum]() {
		sum = accumulate(xa.begin(), xa.end(), 0.0f, [](float total, point3Da const& p){ return total + p.x;});
	};
	auto fb = [&xb, &sum]() {
		sum = accumulate(xb.begin(), xb.end(), 0.0f, [](float total, point3Db const& p){ return total + p.x;});
	};
	auto fc = [&xc, &sum]() {
		sum = accumulate(xc.begin(), xc.end(), 0.0f, [](float total, point3Dc const& p){ return total + p.x;});
	};
	swa.time_it(10UL, fa, min_timea);
	swb.time_it(10UL, fb, min_timeb);
	swc.time_it(10UL, fc, min_timec);
}

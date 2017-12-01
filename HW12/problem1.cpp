#include <iostream>
#include <omp.h>
#define OMPI_SKIP_MPICXX  /* Don't use OpenMPI's C++ bindings (they are deprecated) */
#include <mpi.h>
#include <fstream>
#include <vector>
#include <ctime>

namespace mpi {
	class context {
		int m_rank, m_size;
	public:
		context(int *argc, char **argv[]) : m_rank { -1 } {
			if (MPI_Init(argc, argv) == MPI_SUCCESS) {
				MPI_Comm_rank(MPI_COMM_WORLD, &m_rank);
				MPI_Comm_size(MPI_COMM_WORLD, &m_size);
			}
		}
		~context() {
			if(m_rank >= 0) {
				MPI_Finalize();
			}
		}
		explicit operator bool() const {
			return m_rank >= 0;
		}
		int rank() const noexcept { return m_rank; }
		int size() const noexcept { return m_size; }
	};
}

int main(int argc, char *argv[]) {
	mpi::context ctx(&argc, &argv);
	std::ifstream file_in;
	file_in.open("problem1.inp");
	int N;
	clock_t begin;
	clock_t end;
	double time_passed;
	N = atoi(argv[1]);
	int i = 0;
	std::vector<float> in_vec(N);
	float loc_sum=0;
	for(i = 0; i < N; i++)
	{
		file_in >> loc_sum;
		in_vec[i] = loc_sum;
	}
	loc_sum=0;
	begin = clock();
	#pragma omp parallel num_threads(8)
	{
	#pragma omp for reduction(+:loc_sum)
	for(i = 0; i < N; i++)
	{
		loc_sum = loc_sum+in_vec[i];
	}
	}

	if(!ctx) {
		std::cerr << "MPI Initialization failed\n";
		return -1;
	}

	if(ctx.rank() == 0) {
		
		float x = 0;
		constexpr int source_rank = 1;  // We expect a message from Task 1
		MPI_Status status;
		MPI_Recv(&x, 1, MPI_FLOAT, source_rank, 0, MPI_COMM_WORLD, &status);
		end = clock();
		time_passed = double(end-begin)/CLOCKS_PER_SEC*1000;
		std::cout << "Received x = " << x << " on root task.\n";
		std::cout << "CAlculated = " << loc_sum << "\n";
		std::cout << "N = " << N << "\n";
		std::cout << "time passed = " << time_passed << "\n";
		std::cout << "total_Red = " << loc_sum+x << "\n";
		
			
} else {
		const float send_sum=loc_sum;
		constexpr int dest_rank =0;  // We send a message to Task 0
		MPI_Send(&send_sum, 1, MPI_FLOAT, dest_rank, 0, MPI_COMM_WORLD);
	
	}
	return 0;
}

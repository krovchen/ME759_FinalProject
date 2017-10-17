# Warnings
WFLAGS	:= -Wall -Wextra -Wsign-conversion -Wsign-compare

# Optimization and architecture
OPT		:= -O3
ARCH   	:= -march=native

# Language standard
CCSTD	:= -std=c99
CXXSTD	:= -std=c++11

# Linker options
LDOPT 	:= $(OPT)
LDFLAGS := 
BIN = "/usr/local/gcc/6.4.0/bin/gcc"
.DEFAULT_GOAL := all

.PHONY: debug
debug : OPT  := -O0 -g -fno-omit-frame-pointer -fsanitize=address
debug : LDFLAGS := -fsanitize=address
debug : ARCH :=
debug : $(EXEC)

all : problem3 problem2 test test1

test: problemtest.cu
	nvcc -o problemtest problemtest.cu

problem2: problem2.cu
	module load cuda;nvcc -o problem2 problem2.cu

problem3: problem3.cu
	module load cuda;nvcc -o problem3 problem3.cu -ccbin $(CU_CCBIN)

test1: ptest1.cu
	nvcc -o ptest1 ptest1.cu

# TODO: add targets for building executables


.PHONY: clean
clean:
	rm -f *.o *.exe *.dat *.out

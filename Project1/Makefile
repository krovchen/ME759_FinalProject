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

all : bare test



bare: main_fcn.cu
	nvcc main_fcn.cu test_kernels.cu -Xcompiler "-fopenmp" -arch compute_35 -o project_test
test: main_fcn_j.cu
	nvcc main_fcn_j.cu jacobi_kernels.cu -Xcompiler "-fopenmp" -arch compute_35 -o jacobi_test


# TODO: add targets for building executables

.PHONY: clean
clean:
	rm -f project_test jacobi_test

# Warnings
WFLAGS	:= -Wall -Wextra -Wsign-conversion -Wsign-compare

# Optimization and architecture
OPT		:= -O3

# Language standard
CCSTD	:= -std=c99
CXXSTD	:= -std=c++14

# Linker options
LDFLAGS := 

# Names of executables to create
EXEC	:= problem1.exe problem2.exe

.DEFAULT_GOAL := all

.PHONY: debug
debug : OPT  := -O0 -g -fno-omit-frame-pointer -fsanitize=address
debug : LDFLAGS := -fsanitize=address
debug : $(EXEC)

all : problem1

problem1 : problem1.cpp
	g++ problem1.cpp -std=c++14 -o problem1.exe -fopenmp -O3


.PHONY: clean
clean:
	@ rm -f *.o $(EXEC)

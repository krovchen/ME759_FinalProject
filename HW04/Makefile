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

.DEFAULT_GOAL := all

.PHONY: debug
debug : OPT  := -O0 -g -fno-omit-frame-pointer -fsanitize=address
debug : LDFLAGS := -fsanitize=address
debug : ARCH :=
debug : $(EXEC)

all : problem1a problem1b

problem1a : problem1a.c
	gcc -o3 problem1a.c -o problem1a.exe -fopenmp -lm

problem1b : problem1b.c
	gcc -o3 problem1b.c -o problem1b.exe -fopenmp -lm 



# TODO: add targets for building executables

.PHONY: clean
clean:
	@ rm -f $(EXEC) $(OBJS)

Two different tests to run:

To see infrastructure operation with NO CUDA -- main function repeatedly samples values from helper function. Type in:

make bare

then run ./project_test

you will see the helper function counter increasing, and main function pulling its values.

To see timing of memory copy from CUDA -- this will require a concurrent run-copy GPU. If you do no thave this then the values will be wrong but timing I believe should still work. This will run the jacobi method

first run the makefile

make test

then run

./jacobi_test


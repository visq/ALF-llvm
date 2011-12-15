* run all tests with clang (-Ox)

bash prepare.sh 1x
bash run_tests

* run all tests with llvm-gcc-4.2 (-Ox)

bash prepare.sh 2x
bash run_tests
  
* run all tests in all configurations

for c in 10 11 12 13 20 21 22 23 ; do
    bash prepare.sh $c;
    bash run_tests;
done

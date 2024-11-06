#!/usr/bin/env bash

curl -sL https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-19.1.3.zip -o llvm-project.zip
unzip -q llvm-project.zip 

cd llvm-project-llvmorg-19.1.3/

mkdir buid
mkdir install
cd build

brew install ninja
cmake -G Ninja \
  -S ../lld
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS='lld' \
  -DCMAKE_INSTALL_PREFIX=./install  \
  -DLLVM_INCLUDE_BENCHMARKS=0 \
  -DLLVM_INCLUDE_EXAMPLES=0  \
  -DLLVM_INCLUDE_TESTS=0 \
  -DSPHINX_OUTPUT_HTML=0 \
  -DSPHINX_OUTPUT_MAN=0 \
  -DLLVM_ROOT=$(brew --prefix llvm@18) 

ninja lld
ninja install

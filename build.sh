#!/usr/bin/env bash

LLVM_VERSION='18.1.8'

brew install ninja

curl -sL https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$LLVM_VERSION.zip -o llvm-project.zip
unzip -q llvm-project.zip 

mkdir build
mkdir install

cmake -G Ninja \
  -B llvm-project-llvmorg-$LLVM_VERSION/build \
  -S llvm-project-llvmorg-$LLVM_VERSION/lld \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS='lld' \
  -DCMAKE_INSTALL_PREFIX=./install  \
  -DLLVM_INCLUDE_BENCHMARKS=0 \
  -DLLVM_INCLUDE_EXAMPLES=0  \
  -DLLVM_INCLUDE_TESTS=0 \
  -DSPHINX_OUTPUT_HTML=0 \
  -DSPHINX_OUTPUT_MAN=0 \
  -DLLVM_ROOT=$(brew --prefix llvm@18) 


ninja -C build lld
ninja -C build install

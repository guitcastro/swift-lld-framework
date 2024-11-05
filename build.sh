#!/usr/bin/env bash

curl -sL https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-19.1.3.zip -o llvm-project.zip
unzip llvm-project.zip -q

cd llvm-project-llvmorg-19.1.3/

mkdir buid
mkdir install
cd buid

brew install ninja
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS='lld' -DCMAKE_INSTALL_PREFIX=./install ../llvm

ninja lld
ninja install

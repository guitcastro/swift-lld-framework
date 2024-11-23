#!/usr/bin/env bash

LLVM_VERSION='19.1.3'

echo 'Installing homebrew x86 ...'
arch -x86_64  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'Installing zstd x86 ...'
arch -x86_64 /usr/local/bin/brew install zstd    

echo 'Downloading LLVM source code'
curl -sL https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$LLVM_VERSION.zip -o llvm-project.zip

echo 'Unziping LLVM source code'
unzip -q llvm-project.zip 

echo 'Downloading LLVM x86 binaries'         
curl -sL https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVM_VERSION/LLVM-$LLVM_VERSION-macOS-X64.tar.xz -o llvm.tar.gz

echo 'Extracting LLVM x86 binaries'
tar -xvf llvm.tar.gz

echo 'Installing Ninja ...'
arch -x86_64 /usr/local/bin/brew install ninja

LLVM_ROOT=$(pwd)/LLVM-$LLVM_VERSION-macOS-X64/

mkdir build
mkdir install
cd build

cmake -G Ninja -S ../llvm-project-llvmorg-$LLVM_VERSION/lld \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DLLVM_ROOT=${LLVM_ROOT} \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS='lld' \
  -DCMAKE_INSTALL_PREFIX=./install  \
  -DDEFAULT_SYSROOT=`xcrun --show-sdk-path`  \
  -DLLVM_INCLUDE_BENCHMARKS=0 \
  -DLLVM_INCLUDE_EXAMPLES=0  \
  -DLLVM_INCLUDE_TESTS=0 \
  -DSPHINX_OUTPUT_HTML=0 \
  -DSPHINX_OUTPUT_MAN=0 \
  -DCMAKE_CXX_FLAGS='-arch x86_64 -target x86_64-apple-darwin-macho' \
  -DLLVM_HOST_TRIPLE=x86_64-apple-darwin-macho \
  -DLLVM_TARGETS_TO_BUILD=X86


ninja lldCOFF lldELF lldMachO lldMinGW lldWasm

mkdir -p ../dist/

xcodebuild -create-xcframework -library ./lib/liblldCOFF.a -headers ../llvm-project-llvmorg-$LLVM_VERSION/lld/include -output  ../dist/liblldCOFF.xcframework   
xcodebuild -create-xcframework -library ./lib/liblldELF.a -headers ../llvm-project-llvmorg-$LLVM_VERSION/lld/include -output  ../dist/liblldELF.xcframework   
xcodebuild -create-xcframework -library ./lib/liblldMachO.a -headers ../llvm-project-llvmorg-$LLVM_VERSION/lld/include -output  ../dist/liblldMachO.xcframework   
xcodebuild -create-xcframework -library ./lib/liblldMinGW.a -headers ../llvm-project-llvmorg-$LLVM_VERSION/lld/include -output  ../dist/liblldMinGW.xcframework   
xcodebuild -create-xcframework -library ./lib/liblldWasm.a -headers ../llvm-project-llvmorg-$LLVM_VERSION/lld/include -output  ../dist/liblldCliblldWasmOFF.xcframework   

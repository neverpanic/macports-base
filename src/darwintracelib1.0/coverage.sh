#!/bin/sh

make CC=clang-mp-11 LD=clang-mp-11 CFLAGS="-fprofile-instr-generate -fcoverage-mapping"

export LLVM_PROFILE_FILE="${PWD}/dtrace.%p.rawprof"
rm -f "${PWD}"/*.rawprof
make test CC=clang-mp-11 LD=clang-mp-11

llvm-profdata-mp-11 merge -sparse "${PWD}"/*.rawprof -o "${PWD}/dtrace.profdata"
llvm-cov-mp-11 show -format=html darwintrace.dylib -instr-profile="${PWD}/dtrace.profdata" > report.html
llvm-cov-mp-11 report darwintrace.dylib -instr-profile="${PWD}/dtrace.profdata"

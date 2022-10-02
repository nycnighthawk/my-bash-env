#!/bin/bash
export TOOLCHAIN_DIR=/opt/llvm/gcc/v8.0.1
export LIBEDIT_BASE_PATH=/opt/devtool
export GCC_DIR=/opt/gcc-8.2.0
export VERBOSE=1
export AR=${TOOLCHAIN_DIR}/bin/llvm-ar
export AS=${TOOLCHAIN_DIR}/bin/llvm-as
export NM=${TOOLCHAIN_DIR}/bin/llvm-nm
export RANLIB=${TOOLCHAIN_DIR}/bin/llvm-ranlib
export STRIP=${TOOLCHAIN_DIR}/bin/llvm-strip
export OBJDUMP=${TOOLCHAIN_DIR}/bin/llvm-objdump
export LD=${TOOLCHAIN_DIR}/bin/lld
export LLVM_INSTALL_PATH=/opt/llvm/clang/v8.0.1
export CFLAGS="-I${LIBEDIT_BASE_PATH}/include"
export CXXFLAGS="-I${LIBEDIT_BASE_PATH}/include"
export LDFLAGS="-L${TOOLCHAIN_DIR}/lib64 -L${LIBEDIT_BASE_PATH}/lib64 -ledit -Wl,-rpath,${LLVM_INSTALL_PATH}/lib64 -Wl,-rpath,${TOOLCHAIN_DIR}/lib64 -Wl,-rpath,${GCC_DIR}/lib64 -Wl,-rpath,${LIBEDIT_BASE_PATH}/lib64 -Wl,-z,origin -Wl,--enable-new-dtags"
OLD_PATH=${PATH}
export PATH=${TOOLCHAIN_DIR}/bin:$PATH
export CC=${TOOLCHAIN_DIR}/bin/clang
export CXX=${TOOLCHAIN_DIR}/bin/clang++
cmake ../ \
   -DPYTHON_EXECUTABLE=/opt/python/v3.6.9/bin/python3 \
   -DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL_PATH} \
   -DCMAKE_C_COMPILER=${TOOLCHAIN_DIR}/bin/clang \
   -DCMAKE_C_LINK_FLAGS="-L${TOOLCHAIN_DIR}/lib64 -Wl,-rpath,${TOOLCHAIN_DIR}/lib64 -Wl,-z,origin -Wl,--enable-new-dtags" \
   -DCMAKE_CXX_COMPILER=${TOOLCHAIN_DIR}/bin/clang++ \
   -DCMAKE_CXX_LINK_FLAGS="-L${TOOLCHAIN_DIR}/lib64 -Wl,-rpath,${TOOLCHAIN_DIR}/lib64 -Wl,-z,origin -Wl,--enable-new-dtags" \
   -Dlibedit_INCLUDE_DIRS=${LIBEDIT_BASE_PATH}/include \
   -Dlibedit_LIBRARIES=${LIBEDIT_BASE_PATH}/lib64 \
   -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
   -DLIBCXX_CXX_ABI=libcxxabi \
   -DLIBCXX_CXX_ABI_LIBRARY_PATH=./lib64 \
   -DLIBCXX_CXX_ABI_INCLUDE_PATHS=./../../libcxxabi/include
   -DLIBCXXABI_LIBCXX_PATH=./../../libcxx \
   -DLIBCXXABI_LIBCXX_INCLUDES=../../libcxx/include \
   -DLLVM_ENABLE_EH=ON \
   -DLLVM_ENABLE_RTTI=ON \
   -DLLVM_BUILD_LLVM_DYLIB=ON \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DLLVM_ENABLE_LIBCXX=ON \
   -DLLVM_LIBDIR_SUFFIX=64 \
   -DLLVM_TARGETS_TO_BUILD=X86 \
   -DLLVM_USE_LINKER=lld \
   -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;openmp" \
   -DLLVM_ENABLE_LTO=Off \

make -j2 2>&1 | tee make.log
export PATH=${OLD_PATH}

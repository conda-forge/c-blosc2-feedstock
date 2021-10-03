#!/bin/bash

rm -rf internal-complibs/lz4-1.9.3
rm -rf internal-complibs/zstd-1.5.0

mkdir build
cd build

if [[ "${target_platform}" != "${build_platform}" ]]; then
    BUILD_TESTS=0
else
    BUILD_TESTS=1
fi

cmake -G "Unix Makefiles" \
      ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE="Release" \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_INSTALL_LIBDIR="${PREFIX}/lib" \
      -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
      -DBUILD_STATIC=0 \
      -DBUILD_SHARED=1 \
      -DBUILD_TESTS=${BUILD_TESTS} \
      -DBUILD_EXAMPLES=0 \
      -DBUILD_BENCHMARKS=0 \
      -DPREFER_EXTERNAL_LZ4=1 \
      -DPREFER_EXTERNAL_ZSTD=1 \
      -DPREFER_EXTERNAL_ZLIB=0 \
      "${SRC_DIR}"

cmake --build .
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
    ctest
fi
cmake --build . --target install

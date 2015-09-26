#!/usr/bin/env sh

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
	echo 'Either $NDK_ROOT should be set or provided as argument'
	echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
	echo "      '${0} /path/to/ndk'"
	exit 1
else
	NDK_ROOT="${1:-${NDK_ROOT}}"
fi

WD=$(readlink -f "`dirname $0`/..")
PROTOBUF_ROOT=${WD}/protobuf
INSTALL_DIR=${WD}/android_lib
N_JOBS=8

cd "${PROTOBUF_ROOT}"
rm -rf build/
mkdir build/
cd build/

cmake -DCMAKE_TOOLCHAIN_FILE=~/android-cmake/android.toolchain.cmake \
      -DANDROID_NDK=${NDK_ROOT} \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="armeabi-v7a-hard with NEON" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/protobuf \
	  -DBUILD_TESTING=OFF \
      ../cmake

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/protobuf"
make install/strip

cd "${WD}"

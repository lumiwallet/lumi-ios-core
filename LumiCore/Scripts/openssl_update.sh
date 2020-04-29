#!/bin/bash

# based on:
# https://github.com/oleganza/CoreBitcoin/blob/master/update_openssl.sh

OPENSSL_VERSION="1.0.1e"

DEVELOPER=`xcode-select -print-path`

IOS_SDK_VERSION=`xcrun -sdk iphoneos --show-sdk-version`
#Fix MacOS 10.15.4
OSX_SDK_VERSION="10.15" #`xcrun -sdk macosx --show-sdk-version`

WORKDIR=${PWD}

IPHONEOS_PLATFORM="${DEVELOPER}/Platforms/iPhoneOS.platform"
IPHONEOS_SDK="${IPHONEOS_PLATFORM}/Developer/SDKs/iPhoneOS${IOS_SDK_VERSION}.sdk"
IPHONEOS_GCC="${DEVELOPER}/usr/bin/gcc"

IPHONESIMULATOR_PLATFORM="${DEVELOPER}/Platforms/iPhoneSimulator.platform"
IPHONESIMULATOR_SDK="${IPHONESIMULATOR_PLATFORM}/Developer/SDKs/iPhoneSimulator${IOS_SDK_VERSION}.sdk"
IPHONESIMULATOR_GCC="${DEVELOPER}/usr/bin/gcc"

MACOS_PLATFORM="${DEVELOPER}/Platforms/MacOSX.platform"
MACOS_SDK="${MACOS_PLATFORM}/Developer/SDKs/MacOSX${OSX_SDK_VERSION}.sdk"
MACOS_GCC="${DEVELOPER}/usr/bin/gcc"

if [ ! -e $IPHONEOS_SDK ]; then
    echo "Error! iOS SDK is not found: ${IPHONEOS_SDK}"
    exit
fi

if [ ! -e $MACOS_SDK ]; then
    echo "Error! OS X SDK is not found: ${MACOS_SDK}"
    exit
fi

rm -rf openssl-${OPENSSL_VERSION}-*
rm -rf openssl

curl -O -L http://www.openssl.org/source/old/1.0.1/openssl-$OPENSSL_VERSION.tar.gz

build()
{
   ARCH=$1
   GCC=$2
   SDK=$3
   rm -rf "openssl-${OPENSSL_VERSION}"
   tar xfz "openssl-${OPENSSL_VERSION}.tar.gz"
   mv "openssl-${OPENSSL_VERSION}" "openssl-${OPENSSL_VERSION}-${ARCH}"
   pushd .
   cd "openssl-${OPENSSL_VERSION}-${ARCH}"
   ./Configure BSD-generic32 &> "../openssl-${OPENSSL_VERSION}-${ARCH}.log"
   perl -i -pe 's|static volatile sig_atomic_t intr_signal|static volatile int intr_signal|' crypto/ui/ui_openssl.c
   perl -i -pe "s|^CC= gcc|CC= ${GCC} -arch ${ARCH}|g" Makefile
   perl -i -pe "s|^CFLAG= (.*)|CFLAG= -isysroot ${SDK} \$1|g" Makefile
   make &> "../openssl-${OPENSSL_VERSION}-${ARCH}.log"
   popd
}

echo "Building OpenSSL for 32-bit iOS simulator"
build "i386" "${IPHONESIMULATOR_GCC}" "${IPHONESIMULATOR_SDK}"

echo "Building OpenSSL for 64-bit iOS simulator"
build "x86_64" "${IPHONESIMULATOR_GCC}" "${IPHONESIMULATOR_SDK}"
mv "openssl-${OPENSSL_VERSION}-x86_64" "openssl-${OPENSSL_VERSION}-x86_64-simulator"

echo "Building OpenSSL for ARM 64-bit"
build "arm64" "${IPHONEOS_GCC}" "${IPHONEOS_SDK}"

echo "Building OpenSSL for ARMv7"
build "armv7" "${IPHONEOS_GCC}" "${IPHONEOS_SDK}"

echo "Building OpenSSL for ARMv7s"
build "armv7s" "${IPHONEOS_GCC}" "${IPHONEOS_SDK}"

rm -rf "openssl-${OPENSSL_VERSION}"

echo "Building OpenSSL for 64-bit OS X"
tar xfz "openssl-${OPENSSL_VERSION}.tar.gz"
mv openssl-${OPENSSL_VERSION} openssl-${OPENSSL_VERSION}-x86_64
cd openssl-${OPENSSL_VERSION}-x86_64
./Configure darwin64-x86_64-cc -shared &> "../openssl-${OPENSSL_VERSION}-x86_64.log"
make &> "../openssl-${OPENSSL_VERSION}-x86_64.log"

cd "${WORKDIR}/.."

echo "Making universal OpenSSL libraries for OS X and iOS"

mkdir Crypto/OpenSSLHeaders/openssl

cp -r ${WORKDIR}/openssl-${OPENSSL_VERSION}-x86_64/include/openssl Crypto/OpenSSLHeaders/

lipo \
    "${WORKDIR}/openssl-${OPENSSL_VERSION}-armv7/libcrypto.a" \
    "${WORKDIR}/openssl-${OPENSSL_VERSION}-armv7s/libcrypto.a" \
    "${WORKDIR}/openssl-${OPENSSL_VERSION}-arm64/libcrypto.a" \
    "${WORKDIR}/openssl-${OPENSSL_VERSION}-x86_64-simulator/libcrypto.a" \
    "${WORKDIR}/openssl-${OPENSSL_VERSION}-i386/libcrypto.a" \
    -create -output Crypto/OpenSSLBinaries/libcrypto-ios.a
    
cp "${WORKDIR}/openssl-${OPENSSL_VERSION}-x86_64/libcrypto.a" "Crypto/OpenSSLBinaries/libcrypto-osx.a"

cd "$WORKDIR"

rm -rf openssl-${OPENSSL_VERSION}-*
rm -rf openssl-${OPENSSL_VERSION}.tar.gz

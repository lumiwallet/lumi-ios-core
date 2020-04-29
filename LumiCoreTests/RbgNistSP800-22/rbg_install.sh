#!/bin/sh

#  rbg_install.sh
#  LumiCoreTests
#
#  Copyright © 2020 LUMI WALLET LTD. All rights reserved.

TEMDIR="/tmp/sts_${RANDOM}"
mkdir "$TEMDIR"

SCRIPT_DIR=`pwd`
RBG_DIR="${SCRIPT_DIR}/rbg"

if [ -d "$RBG_DIR" ]; then
    rm -rf "${RBG_DIR}/*"
else
    mkdir -p "$RBG_DIR"
fi

cd "$TEMDIR"
curl -O -L https://csrc.nist.gov/CSRC/media/Projects/Random-Bit-Generation/documents/sts-2_1_2.zip
unzip *.zip

rm -rf "${RBG_DIR}/*"
cp -r "${TEMDIR}/sts*/sts*/" "${RBG_DIR}/"

cd "$RBG_DIR"
make -f makefile

rm -rf "$TEMP_DIR"

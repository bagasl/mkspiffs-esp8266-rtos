#!/bin/bash
#
# Script used in CI to build all configurations of mkspiffs
#

set -e

# Build configuration for ESP-RTOS (esp8266)
make clean
make dist BUILD_CONFIG_NAME="-esp-rtos-8266" \
    CPPFLAGS="-DSPIFFS_OBJ_META_LEN=4 -DSPIFFS_USE_MAGIC_LENGTH=1 -DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1"
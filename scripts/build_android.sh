#!/bin/bash

# Get the path to the directory containing this script
SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
PROJECT_DIR=$(dirname "$SCRIPT_DIR")

# Exit if ANDROID_NDK_HOME is not set
if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "Please set environment variable ANDROID_NDK_HOME to the path of your Android NDK installation"
    exit 1
fi

#sh -c "cd \"$PROJECT_DIR\" && cargo ndk \
#   -o "$PROJECT_DIR/flutter/android/app/src/main/jniLibs" \
#   -p 21 \
#   -t arm64-v8a \
#   -t armeabi-v7a \
#   -t x86 \
#   -t x86_64 \
#   build --release --package session-ui \
# "

 sh -c "cd \"$PROJECT_DIR\" && cargo ndk \
     -o "$PROJECT_DIR/flutter/android/app/src/main/jniLibs" \
     -p 21 \
     -t arm64-v8a \
     -t armeabi-v7a \
     -t x86 \
      -t x86_64 \
     build --package session-ui --release  \
   "
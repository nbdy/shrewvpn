#!/bin/bash

if [ ! -d build ]; then mkdir build;
else (cd build; make clean); fi

cd build
cmake ..
make -j $(nproc)

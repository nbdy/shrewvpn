#!/bin/bash

sudo apt install -y cmake build-essential bison flex libedit-dev libssl-dev

if [ ! -d build ]; then mkdir build;
else (cd build; make clean); fi

cd build
cmake ..
make -j $(nproc)
sudo make install

sudo ln -s /usr/local/lib/libss_* /lib/x86_64-linux-gnu/
sudo cp /usr/local/etc/iked.conf.sample /usr/local/etc/iked.conf
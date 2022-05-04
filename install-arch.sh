#!/bin/bash

pacman -Syu --noconfirm cmake base-devel bison flex libedit git

if [ ! -d build ]; then mkdir build;
else (cd build; make clean); fi

cd build
cmake ..
make -j $(nproc)
make install

sudo cp /usr/local/etc/iked.conf.sample /usr/local/etc/iked.conf

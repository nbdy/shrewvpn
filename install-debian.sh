#!/bin/bash

./dependencies.sh
./build.sh

sudo make install

sudo ln -s /usr/local/lib/libss_* /lib/x86_64-linux-gnu/
sudo cp /usr/local/etc/iked.conf.sample /usr/local/etc/iked.conf

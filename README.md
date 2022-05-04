### shrewvpn
#### why the git repo?
stuff from the [official site](https://www.shrew.net/download/ike) does not compile on debian buster, since it uses OpenSSL 0.9.
#### what changed?
main changes are in commits [04dd437c15ad46eff10afbdf2de414d4dc91948b](https://github.com/nbdy/shrewvpn/commit/04dd437c15ad46eff10afbdf2de414d4dc91948b) and [e3df127638a0b99f0d7e1f166a32596f2e4145ac](https://github.com/nbdy/shrewvpn/commit/e3df127638a0b99f0d7e1f166a32596f2e4145ac)
#### how to ..
##### .. install
```shell script
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j $(nproc)
make install
# or into a directory
make install DESTDIR=shrewvpn
# or automated
./install-debian.sh
# ./install-arch.sh
```
#####  .. configuring (if you did not run ./install-${YOUR_DIST}.sh)
```shell script
sudo cp /usr/local/etc/iked.conf.sample /usr/local/etc/iked.conf
```
##### .. running
```shell script
sudo iked

ii : created ike socket 0.0.0.0:500
ii : created natt socket 0.0.0.0:4500
## : IKE Daemon, ver 2.2.1
## : Copyright 2013 Shrew Soft Inc.
## : This product linked OpenSSL 1.1.1g  21 Apr 2020

ikec --help

ii : ## : VPN Connect, ver 2.2.1
## : Copyright 2013 Shrew Soft Inc.
## : press the <h> key for help
!! : invalid parameters specified ...
>> : ikec -r "name" [ -u <user> ][ -p <pass> ][ -a ]
 -r	site configuration path
 -u	connection user name
 -p	connection user password
 -a	auto connect
```

#!/bin/bash

apt-get update && apt-get --no-install-recommends -y install wget

shrpx_v=$(wget --no-check-certificate -O - http://github.com/tatsuhiro-t/spdylay/releases | grep -o '[0-9]\.[0-9]\.[0-9]' | head -1)
if [[ ! -f /tmp/spdylay.deb || "$(dpkg-deb --field /tmp/spdylay.deb version)" != "$shrpx_v-1" ]]; then
	apt-get -y install build-essential checkinstall autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev 
	cd / && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v$shrpx_v/spdylay-$shrpx_v.tar.gz
	tar -zxvf spdylay-$shrpx_v.tar.gz && cd spdylay-$shrpx_v/
	autoreconf -i && automake && autoconf && ./configure && make
	checkinstall -y --requires="libevent-openssl-2.0-5, libevent-2.0-5" --install=no --maintainer=tatsuhiro-t
	cp /spdylay-$shrpx_v/spdylay_$shrpx_v-1_amd64.deb /tmp/spdylay.deb
fi
 
nghttp2_v=$(wget --no-check-certificate -O - http://github.com/tatsuhiro-t/nghttp2/releases | grep -o '[0-9]\.[0-9]\.[0-9]' | head -1)
if [[ ! -f /tmp/nghttp2.deb || "$(dpkg-deb --field /tmp/nghttp2.deb version)" != "$nghttp2_v-1" ]]; then
	apt-get -y install build-essential checkinstall autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev libjansson-dev libjemalloc-dev cython python3.4-dev
	cd / && wget --no-check-certificate https://github.com/tatsuhiro-t/nghttp2/releases/download/v$nghttp2_v/nghttp2-$nghttp2_v.tar.gz
	tar -zxvf nghttp2-$nghttp2_v.tar.gz && cd nghttp2-$nghttp2_v
	autoreconf -i && automake && autoconf && ./configure && make
	checkinstall -y --requires="libevent-openssl-2.0-5, libevent-2.0-5, libjemalloc-dev" --install=no --maintainer=tatsuhiro-t
	cp /nghttp2-$nghttp2_v/nghttp2_$nghttp2_v-1_amd64.deb /tmp/nghttp2.deb
fi

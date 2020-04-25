FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG TOOLCHAINS="build-essential automake libtool pkg-config \
                curl git cmake ninja-build python3-pip"

RUN apt-get update && apt-get install ${TOOLCHAINS} -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --user meson

ENV PATH=$PATH:~/.local/bin

RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 \
    && tar -jxvf ./nasm-2.14.02.tar.bz2 && rm ./nasm-2.14.02.tar.bz2 \
    && cd ./nasm-2.14.02 && ./configure --prefix=/usr \
    && make && make install && cd .. && rm -rf ./nasm-2.14.02

RUN git clone -b v1.3.0 --depth=1 https://github.com/yasm/yasm.git \
    && cd ./yasm && ./autogen.sh && ./configure --prefix=/usr \
    && make && make install && cd .. && rm -rf ./yasm
    
RUN git clone -b OpenSSL_1_1_1g --depth=1 https://github.com/openssl/openssl.git \
    && cd ./openssl && ./config --prefix=/usr/local && make && make install \
    && cd .. && rm -rf ./openssl
    
RUN curl -O https://www.zlib.net/zlib-1.2.11.tar.gz \
    && tar -zxvf ./zlib-1.2.11.tar.gz && rm ./zlib-1.2.11.tar.gz \
    && cd ./zlib-1.2.11 \
    && ./configure --prefix=/usr/local && make && make install \
    && cd .. && rm -rf ./zlib-1.2.11

ARG CURL_DEPS="libbrotli-dev libidn2-dev libpsl-dev libssh-dev librtmp-dev heimdal-dev libldap2-dev libxml2-dev"

RUN apt-get update && apt-get install ${CURL_DEPS} -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone -b release-0.1.3 --depth=1 https://github.com/metalink-dev/libmetalink.git \
    && cd ./libmetalink && ./buildconf && ./configure --prefix=/usr \
    && make && make install && cd .. && rm -rf ./libmetalink

RUN git clone -b v1.40.0 --depth=1 https://github.com/nghttp2/nghttp2.git \
    && cd ./nghttp2 && autoreconf -i && automake && autoconf \
    && ./configure --prefix=/usr --enable-lib-only && make && make install \
    && cd .. && rm -rf ./nghttp2

ENV CURL_CHECKOUT_VERSION=7_69_1
ENV CURL_VERSION=7.69.1

RUN git clone -b curl-${CURL_CHECKOUT_VERSION} --depth=1 https://github.com/curl/curl.git \
    && cd ./curl && ./maketgz ${CURL_VERSION} only && ./buildconf \
    && ./configure --prefix=/usr --with-ssl --with-nghttp2 --with-libssh \
                   --with-gssapi --enable-ldap --enable-ldaps --with-libmetalink \
    && make && make install && cd .. && rm -rf ./curl

RUN git clone -b v3.17.1 --depth=1 https://github.com/Kitware/CMake.git \
    && cd ./CMake && ./bootstrap --prefix=/usr && make && make install \
    && cd .. && rm -rf ./CMake

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

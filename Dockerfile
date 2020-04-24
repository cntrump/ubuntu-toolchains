FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG TOOLCHAINS="build-essential automake libtool pkg-config \
                curl git cmake ninja-build python3-pip"

RUN apt-get update && apt-get install ${TOOLCHAINS} -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --user meson

ENV PATH=$PATH:~/.local/bin

RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 \
    && tar -jxvf ./nasm-2.14.02.tar.bz2 && rm ./nasm-2.14.02.tar.bz2 \
    && cd ./nasm-2.14.02 && ./configure --prefix=/usr/local \
    && make && make install && cd .. && rm -rf ./nasm-2.14.02

RUN git clone -b v1.3.0 --depth=1 https://github.com/yasm/yasm.git \
    && cd ./yasm && ./autogen.sh && ./configure --prefix=/usr/local \
    && make && make install && cd .. && rm -rf ./yasm
    
RUN git clone -b OpenSSL_1_1_1g --depth=1 https://github.com/openssl/openssl.git \
    && cd ./openssl && ./config --prefix=/usr/local && make && make install \
    && cd .. && rm -rf ./openssl
    
RUN curl -O https://www.zlib.net/zlib-1.2.11.tar.gz \
    && tar -zxvf ./zlib-1.2.11.tar.gz && cd ./zlib-1.2.11 \
    && ./configure --prefix=/usr/local && make && make install \
    && cd .. && rm -rf ./zlib-1.2.11

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

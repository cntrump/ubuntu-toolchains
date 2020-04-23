FROM ubuntu:18.04

ARG TOOLCHAINS="build-essential automake libtool pkg-config \
                curl git cmake ninja-build python3-pip"

RUN apt-get update && apt-get install ${TOOLCHAINS} -y && apt-get clean

RUN pip3 install --user meson

ENV PATH=$PATH:~/.local/bin

RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 \
    && tar -jxvf ./nasm-2.14.02.tar.bz2 && rm ./nasm-2.14.02.tar.bz2 \
    && cd ./nasm-2.14.02 && ./configure --prefix=/usr/local \
    && make && make install && cd .. && rm -rf ./nasm-2.14.02

RUN git clone -b v1.3.0 --depth=1 https://github.com/yasm/yasm.git \
    && cd ./yasm && ./autogen.sh && ./configure --prefix=/usr/local \
    && make && make install && cd .. && rm -rf ./yasm

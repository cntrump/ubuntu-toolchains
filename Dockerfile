FROM cntrump/ubuntu-template:20.04

ARG TOOLCHAINS="build-essential automake libtool pkg-config \
                curl git cmake ninja-build python3-pip"

RUN apt-get update && apt-get install ${TOOLCHAINS} -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install meson

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

ARG CURL_CHECKOUT_VERSION=7_69_1
ARG CURL_VERSION=7.69.1

RUN git clone -b curl-${CURL_CHECKOUT_VERSION} --depth=1 https://github.com/curl/curl.git \
    && cd ./curl && ./maketgz ${CURL_VERSION} only && ./buildconf \
    && ./configure --prefix=/usr --with-ssl --with-nghttp2 --with-libssh \
                   --with-gssapi --enable-ldap --enable-ldaps --with-libmetalink \
    && make && make install && cd .. && rm -rf ./curl

RUN git clone -b v3.17.1 --depth=1 https://github.com/Kitware/CMake.git \
    && cd ./CMake && ./bootstrap --prefix=/usr && make && make install \
    && cd .. && rm -rf ./CMake

ARG GOLANG_VERSION=1.14.2

RUN curl -O https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm -rf /usr/go && tar -C /usr -xzf ./go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm ./go${GOLANG_VERSION}.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/go/bin

RUN apt-get update && apt-get install software-properties-common -y

COPY llvm.sh ./

RUN chmod +x ./llvm.sh && ./llvm.sh 10 && rm ./llvm.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Ubuntu toolchains

- GCC toolchains
- pkg-config
- autotools
- [ninja](https://ninja-build.org)
- [cmake](https://cmake.org)
- [meson](https://mesonbuild.com)
- [openssl](https://www.openssl.org)
- [nasm](https://nasm.us/)
- [yasm](https://yasm.tortall.net/)
- [zlib](https://www.zlib.net)

## Build your Docker image

`docker pull cntrump/ubuntu-toolchains:latest`

Write your Dockerfile, base on `cntrump/ubuntu-toolchains`:

```docker
FROM cntrump/ubuntu-toolchains:latest

RUN apt-get update && apt-get install ...
...
```

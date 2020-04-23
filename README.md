# Ubuntu toolchains

GCC toolchains

## Build your Docker image

`docker pull cntrump/ubuntu-toolchains:latest`

Write your Dockerfile, base on `cntrump/ubuntu-toolchains`:

```docker
FROM cntrump/ubuntu-toolchains:latest

RUN apt-get update && apt-get install ...
...
```

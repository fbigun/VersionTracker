# Transfer

🍭 集合多个 API 的大文件传输工具

[项目地址](https://github.com/Mikubill/transfer)

本地址为该项目的 `docker image`

`Dockerfile`内容

```Dockerfile
FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates libssl1.1 openssl \
        && rm -rf /var/lib/apt/lists/*

COPY transfer /usr/local/bin/
CMD ["transfer", "--help"]
```

# [shadowsocks](https://github.com/shadowsocks/shadowsocks-libev) and [simple-obfs](https://github.com/shadowsocks/simple-obfs)

> Shadowsocks-libev是用于嵌入式设备和低端盒的轻型安全SOCKS5代理。
> Simple-obfs是一个简单的混淆工具，设计为shadowsocks的插件服务器。

项目地址: [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) and [simple-obfs](https://github.com/shadowsocks/simple-obfs)

官方WIKI: [Shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev#usage) [simple-obfs](https://github.com/shadowsocks/simple-obfs#usage)

## `Dockerfile` 内容

```Dockerfile
FROM debian:buster-slim

LABEL maintainer="fbigun <rsdhlz@gmail.com>" \
      description="ss 轻型安全SOCKS5代理" \
      license="GPL 3.0"

RUN apt-get update \
      && apt-get install -y --no-install-recommends ca-certificates \
      && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY ss-local ss-server obfs-local obfs-server /bin/
```

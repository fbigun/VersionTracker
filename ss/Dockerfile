FROM debian:buster-slim

LABEL maintainer="fbigun <rsdhlz@gmail.com>" \
      description="ss 轻型安全SOCKS5代理" \
      license="GPL 3.0"

RUN apt-get update \
      && apt-get install -y --no-install-recommends ca-certificates \
      && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY ss-local ss-server obfs-local obfs-server /bin/

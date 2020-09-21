FROM debian:buster-slim

LABEL maintainer="fbigun <rsdhlz@gmail.com>" \
      description="frp 是一个可用于内网穿透的高性能的反向代理应用" \
      license="Apache License 2.0"

RUN apt-get update \
      && apt-get install -y --no-install-recommends ca-certificates \
      && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG COMMAND
COPY ${COMMAND} /bin/

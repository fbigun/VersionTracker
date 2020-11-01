FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates libssl1.1 openssl \
        && rm -rf /var/lib/apt/lists/*

COPY transfer /usr/local/bin/
CMD ["transfer", "--help"]

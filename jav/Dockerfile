FROM python:3.8-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG JAV_VERSION=3.8

RUN apt-get update \
      && apt-get install -y --no-install-recommends curl ca-certificates \
      && curl -sSL "https://github.com/yoshiko2/AV_Data_Capture/archive/${JAV_VERSION}.tar.gz" | tar xz \
      && mv AV_Data_Capture-${JAV_VERSION} /jav \
      && pip install --no-cache-dir -r /jav/requirements.txt \
      && apt-get purge -y curl && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /jav

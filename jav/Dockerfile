FROM python:3.8-slim

ARG AV_Data_Capture_VERSION=3.8

RUN apt-get update \
      && apt-get install -y --no-install-recommends wget ca-certificates \
      && wget -O - "https://github.com/yoshiko2/AV_Data_Capture/archive/${AV_Data_Capture_VERSION}.tar.gz" | tar xz \
      && mv AV_Data_Capture-master /jav \
      && pip install --no-cache-dir -r /jav/requirements.txt \
      && apt-get purge -y wget && rm -rf /var/lib/apt/lists/*

WORKDIR /jav

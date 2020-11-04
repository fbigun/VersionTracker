# AV Data Capture (CLI)

> 日本电影元数据 抓取工具 | 刮削器，配合本地影片管理软件 Emby, Jellyfin, Kodi 等管理本地影片，该软件起到分类与元数据（metadata）抓取作用，利用元数据信息来分类，仅供本地影片分类整理使用。

[项目地址](https://github.com/yoshiko2/AV_Data_Capture)

[官方WIKI](https://github.com/yoshiko2/AV_Data_Capture/wiki)

## `Dockerfile` 内容

```Dockerfile
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
```

## 使用方法

```bash
docker run --name jav_test --rm -it fbigun/jav AV_Data_Capture -c config_other.ini
```

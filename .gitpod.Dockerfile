FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN sudo apt-get update \
    && sudo apt-get install -y \
        ffmpeg \
        gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto \
        libssl-dev libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev \
    && sudo rm -rf /var/lib/apt/lists/*

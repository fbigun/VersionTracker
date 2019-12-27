FROM scratch

LABEL maintainer='fbigun'

COPY frps .

ENTRYPOINT ["./frps"]

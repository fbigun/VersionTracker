FROM scratch

LABEL maintainer='fbigun'

COPY frp/frps .

ENTRYPOINT ["./frps"]

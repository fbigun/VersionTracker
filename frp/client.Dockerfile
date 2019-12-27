FROM scratch

LABEL maintainer='fbigun'

COPY frp/frpc .

ENTRYPOINT ["./frpc"]

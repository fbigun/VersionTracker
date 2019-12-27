FROM scratch

LABEL maintainer='fbigun'

COPY frpc .

ENTRYPOINT ["./frpc"]

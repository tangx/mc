FROM alpine:3.12

MAINTAINER MinIO Inc <dev@min.io>

ARG TARGETARCH
RUN apk add --no-cache ca-certificates 'curl>7.61.0' && \
    curl -s -q https://dl.minio.io/client/mc/release/linux-${TARGETARCH}/mc -o /usr/bin/mc && \
    chmod +x /usr/bin/mc && \
    curl -s -q -O https://raw.githubusercontent.com/minio/minio/release/CREDITS

ENTRYPOINT ["mc"]

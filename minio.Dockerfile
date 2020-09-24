FROM alpine:latest

LABEL maintainer="MinIO Inc <dev@min.io>"

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key \
    MINIO_KMS_MASTER_KEY_FILE=kms_master_key \
    MINIO_SSE_MASTER_KEY_FILE=sse_master_key

ARG TARGETARCH
RUN set -exu ; \
     echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
     apk update && apk add --no-cache ca-certificates 'curl>7.61.0' 'su-exec>=0.2' minisign && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     curl -s -q https://dl.min.io/server/minio/release/linux-$TARGETARCH/minio -o /usr/bin/minio && \
     curl -s -q https://dl.min.io/server/minio/release/linux-$TARGETARCH/minio.sha256sum -o /usr/bin/minio.sha256sum && \
     curl -s -q https://dl.min.io/server/minio/release/linux-$TARGETARCH/minio.minisig -o /usr/bin/minio.minisig && \
     curl -s -q https://raw.githubusercontent.com/minio/minio/master/dockerscripts/verify-minio.sh -o /usr/bin/verify-minio.sh && \
     curl -s -q https://raw.githubusercontent.com/minio/minio/master/dockerscripts/docker-entrypoint.sh -o /usr/bin/docker-entrypoint.sh && \
     chmod +x /usr/bin/minio && \
     chmod +x /usr/bin/docker-entrypoint.sh && \
     chmod +x /usr/bin/verify-minio.sh && \
     curl -s -q -O https://raw.githubusercontent.com/minio/minio/master/CREDITS && \
     /usr/bin/verify-minio.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

CMD ["minio"]

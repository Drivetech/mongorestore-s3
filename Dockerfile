FROM alpine:3.7@sha256:0c842418b34ffd6a134dad2e19d6b1f63b98881c2ec67ffd1e6be6b69e97998a

LABEL maintainer "Leonardo Gatica <lgatica@protonmail.com>"

ENV S3_PATH=mongodb AWS_DEFAULT_REGION=us-east-1

RUN apk add --no-cache mongodb-tools py2-pip pv && \
  pip install --no-cache-dir pymongo awscli && \
  mkdir /backup

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY restore.sh /usr/local/bin/restore
COPY mongouri.py /usr/local/bin/mongouri

VOLUME /backup

CMD /usr/local/bin/entrypoint

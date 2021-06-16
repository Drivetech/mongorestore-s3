FROM alpine:3.14@sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0

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

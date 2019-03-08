FROM alpine:3.7@sha256:fea30b82fd63049b797ab37f13bf9772b59c15a36b1eec6b031b6e483fd7f252

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

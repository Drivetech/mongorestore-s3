FROM alpine:3.6@sha256:42c18571af45ffc440bd5127de9ad604f1683e4799dbf7bf588aaee8f95c18f1

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

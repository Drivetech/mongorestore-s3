#!/bin/sh

OPTIONS=`python /usr/local/bin/mongouri`
DB_NAME=`python /usr/local/bin/mongouri database`

# Download backup
aws s3 cp "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}" "/backup/${BACKUP_NAME}"
# Decompress backup
cd /backup/ && tar xzvf $BACKUP_NAME

# Run backup
if [ -n "${COLLECTIONS}" ]; then
  echo $COLLECTIONS | sed -n 1'p' | tr ',' '\n' | while read collection; do
    mongorestore ${OPTIONS} -c ${collection} "/backup/dump/${DB_NAME}/${collection}.bson"
  done
else
  mongorestore ${OPTIONS} "/backup/dump/${DB_NAME}"
fi

# Delete temp files
rm -rf /tmp/dump

# Delete backup files
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls /backup -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls /backup -w 1 | sort | head -n 1)
    rm -rf /backup/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf /backup/*
fi

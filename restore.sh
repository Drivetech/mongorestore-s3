#!/bin/sh

OPTIONS=`python /usr/local/bin/mongouri`
DB_NAME=`python /usr/local/bin/mongouri database`
EXTRA_OPTIONS=${EXTRA:-}

IFS=","
for BACKUP_NAME in $BACKUP_NAMES
do
  # Download backup
  aws s3 cp "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}" "/backup/${BACKUP_NAME}"
  # Decompress backup
  cd /backup/ && tar xzvf $BACKUP_NAME

  # Run backup
  if [ -n "${COLLECTIONS}" ]; then
    for COLLECTION in $COLLECTIONS
    do
      mongorestore ${OPTIONS} -c ${COLLECTION} ${EXTRA_OPTIONS} "/backup/dump/${DB_NAME}/${COLLECTION}.bson"
    done
  else
    mongorestore ${OPTIONS} ${EXTRA_OPTIONS} "/backup/dump/${DB_NAME}"
  fi

  # Delete temp files
  rm -rf /tmp/dump

  # Delete backup files
  rm -rf /backup/*
done


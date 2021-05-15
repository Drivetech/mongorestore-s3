#!/bin/sh

OPTIONS=`python /usr/local/bin/mongouri`
DB_NAME=`python /usr/local/bin/mongouri database`

IFS=","
for BACKUP_NAME in $BACKUP_NAMES
do
  # Get latest backup
  if [ "$BACKUP_NAME" == "latest" ]; then
    BACKUP_NAME=$(aws s3 ls "s3://${S3_BUCKET}/${S3_PATH}/" | tail -1 | awk '{print $NF}')
  fi

  # Download backup
  aws s3 cp "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}" "/backup/${BACKUP_NAME}"
  # Decompress backup with progress
  cd /backup/ && pv $BACKUP_NAME | tar xzf - -C .

  # Run backup
  if [ -n "${COLLECTIONS}" ]; then
    for COLLECTION in $COLLECTIONS
    do
      cmd="mongorestore -v ${OPTIONS} -c ${COLLECTION} /backup/dump/${DB_NAME}/${COLLECTION}.bson"
      echo $cmd
      eval $cmd
    done
  else
    cmd="mongorestore -v ${OPTIONS} /backup/dump/${DB_NAME}"
    echo $cmd
    eval $cmd
  fi

  # Delete backup files
  rm -rf /backup/*
done


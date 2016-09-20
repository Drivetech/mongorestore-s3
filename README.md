# mongorestore-s3

[![Layers](https://images.microbadger.com/badges/image/lgatica/mongorestore-s3.svg)](http://microbadger.com/images/lgatica/mongorestore-s3)
[![Docker Stars](https://img.shields.io/docker/stars/lgatica/mongorestore-s3.svg?style=flat-square)](https://hub.docker.com/r/lgatica/mongorestore-s3)
[![Docker Pulls](https://img.shields.io/docker/pulls/lgatica/mongorestore-s3.svg?style=flat-square)](https://hub.docker.com/r/lgatica/mongorestore-s3/)

> Docker Image with [Alpine Linux](http://www.alpinelinux.org), [mongorestore](https://docs.mongodb.com/manual/reference/program/mongorestore/) and [awscli](https://github.com/aws/aws-cli) for restore mongo backup from s3

## Use

Restore complete database from backup 2016-09-20_06-00-00_UTC.gz in s3

```bash
docker run -d --name mongorestore \
  -v /tmp/backup:/backup
  -e "BACKUP_NAME=2016-09-20_06-00-00_UTC.gz"
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  lgatica/mongorestore-s3
```

Restore only collections collection1 and collection2 from backup 2016-09-20_06-00-00_UTC.gz in s3

```bash
docker run -d --name mongorestore \
  -v /tmp/backup:/backup
  -e "BACKUP_NAME=2016-09-20_06-00-00_UTC.gz"
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "COLLECTIONS=collection1,collection2"
  lgatica/mongorestore-s3
```

## IAM Policity

You need to add a user with the following policies. Be sure to change `your_bucket` by the correct.

```xml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1412062044000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket/*"
            ]
        },
        {
            "Sid": "Stmt1412062128000",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket"
            ]
        }
    ]
}
```

## Extra environmnet

- `S3_PATH` - Default value is `mongodb`. Example `s3://your_bucket/mongodb/`
- `MAX_BACKUPS` - Default not set. If set doing it keeps the last n backups in /backup


## License

[MIT](https://tldrlegal.com/license/mit-license)

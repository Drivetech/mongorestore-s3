# mongorestore-s3

[![dockeri.co](http://dockeri.co/image/lgatica/mongorestore-s3)](https://hub.docker.com/r/lgatica/mongorestore-s3/)

[![Build Status](https://travis-ci.org/lgaticaq/mongorestore-s3.svg?branch=master)](https://travis-ci.org/lgaticaq/mongorestore-s3)

> Docker Image with Alpine Linux, mongorestore and awscli for restore mongo backup from s3

## Use

Restore complete database from backup 2016-09-20_06-00-00_UTC.gz in s3

```bash
docker run -d --name mongorestore \
  -v /tmp/backup:/backup
  -e "BACKUP_NAMES=2016-09-20_06-00-00_UTC.gz"
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
  -e "BACKUP_NAMES=2016-09-20_06-00-00_UTC.gz"
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "COLLECTIONS=collection1,collection2"
  lgatica/mongorestore-s3
```

Restore complete database from backup 2016-09-20_06-00-00_UTC.gz in s3 with "--noIndexRestore"

```bash
docker run -d --name mongorestore \
  -v /tmp/backup:/backup
  -e "BACKUP_NAMES=2016-09-20_06-00-00_UTC.gz"
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e EXTRA="--noIndexRestore"
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
- `EXTRA` - Default not set. Set extra parameters


## License

[MIT](https://tldrlegal.com/license/mit-license)

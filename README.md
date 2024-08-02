# Redis Backup CronJob

This is a simple Docker image that can be used to backup a Redis instance to an S3 bucket.

## Usage

The following is an example of a CronJob that will run a backup every day at 1:00 AM.

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: redis-backup
spec:
  schedule: "0 1 * * *"  # Run daily at 1:00 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: redis-backup
            image: codeheadlabs/redis-awscli:latest
            env:
            - name: REDIS_HOST
              value: "your-redis-service"
            - name: REDIS_PORT
              value: "6379"
            - name: S3_BUCKET
              value: "your-s3-bucket-name"
            - name: AWS_DEFAULT_REGION
              value: "your-aws-region"
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: aws-credentials
                  key: aws-access-key-id
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: aws-credentials
                  key: aws-secret-access-key
          restartPolicy: OnFailure
```

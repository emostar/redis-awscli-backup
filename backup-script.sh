#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Required environment variables
if [ -z "${REDIS_HOST}" ]; then
  echo "REDIS_HOST environment variable is not set."
  exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
  echo "S3_BUCKET environment variable is not set."
  exit 1
fi

# Optional redis connection details
REDIS_PORT=${REDIS_PORT:-6379}

# Backup file details
BACKUP_DIR="/tmp"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="redis_backup_${TIMESTAMP}.rdb"

echo "Starting Redis backup process..."

# Create Redis backup
echo "Creating Redis dump..."
redis-cli -h $REDIS_HOST -p $REDIS_PORT --rdb "${BACKUP_DIR}/${BACKUP_FILE}"

# Compress the backup file
echo "Compressing backup file..."
gzip "${BACKUP_DIR}/${BACKUP_FILE}"
COMPRESSED_FILE="${BACKUP_FILE}.gz"

# Upload to S3
echo "Uploading to S3..."
aws s3 cp "${BACKUP_DIR}/${COMPRESSED_FILE}" "s3://${S3_BUCKET}/${COMPRESSED_FILE}"

# Clean up
echo "Cleaning up temporary files..."
rm "${BACKUP_DIR}/${COMPRESSED_FILE}"

echo "Backup process completed successfully."

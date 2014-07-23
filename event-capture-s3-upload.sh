#!/bin/bash

S3_HOME=/usr/local/bin/s3cmd-1.5.0-beta1
S3_PATH=s3://findly.development/analytics/raw-logs/event-capture
LOG_FILE=$1
LOCK_FILE=/tmp/evcap.lock
FILE_NAME=`hostname`-`date -u +%H%M%S.%s`

# check for lock file
lockfile -r 0 $LOCK_FILE

if [[ $? -ne 0 ]]; then
        # send email alert
        echo `date -u` "Cannot acquire lock - exiting"
        echo `date -u` "Remove lock file and try again:" $LOCK_FILE
        exit 1
fi

cd $LOG_FILE_DIR

# cat all rotated files into a single gzip file
cat $LOG_FILE.* | gzip > $FILE_NAME.gz

# upload to s3 - for hadoop integration folders must prefixed with 'date='
$S3_HOME/s3cmd put $FILE_NAME.gz $S3_PATH/date=`date -u +%Y-%m-%d`/

if [[ $? -ne 0 ]]; then
        # send email alert
        rm -f $FILE_NAME.gz
        echo `date -u` "S3 Upload failed for file: " $FILE_NAME.gz
        echo `date -u` "Remove lock file and try again: " $LOCK_FILE
        exit 1
fi

# remove files
rm -f $LOG_FILE.*
rm -f $FILE_NAME.gz

# remove lock file
rm -f $LOCK_FILE

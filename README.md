# Logrotate to S3 #

This script uses the `logrotate` and `s3cmd` applications to rotate a specific log file and compress and upload to S3

## Pre-requisites ##

For each new environment the following software must be installed:

**s3cmd**

    wget -P /usr/local/bin http://sourceforge.net/projects/s3tools/files/s3cmd/1.5.0-beta1/s3cmd-1.5.0-beta1.tar.gz
    tar -xvf /usr/local/bin/s3cmd-1.5.0-beta1.tar.gz -C /usr/local/bin
    echo 'S3CMD_HOME=/usr/local/bin/s3cmd-1.5.0-beta1' >> /etc/profile

**lockfile**

    apt-get install procmail

## Configuration ##
If the script files are installed into the `/usr/local/bin/event-capture` directory then the only config changed required is in the s3cmd.cfg and event-capture-s3-upload.sh files

**s3cmd.cfg**

Configure the relevant s3 keys for the bucket that needs to store the log data

- access_key = 
- secret_key = 
 

**event-capture-s3-upload.sh**

The root path to store the log data

- S3_PATH=

**event-capture.logrotate**

Configure the specific log(s) to rotate here

## Running hourly within cron ##

    0 * * * * /usr/local/bin/event-capture/logrotate-to-s3-main.sh >> /usr/local/bin/event-capture/cron.log 2>&1

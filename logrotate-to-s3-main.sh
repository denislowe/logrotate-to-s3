#!/bin/bash

#
# Master script file that uses logrotate and s3cmd to rotate and archive log data to s3
#
# The following files must be individually configured for each environment:
# - event-capture.logrotate -> define the log files that need to be archived
# - event-capture-s3-upload.sh -> define the s3 configuration
#

HOME_DIR=/usr/local/bin/event-capture

cd $HOME_DIR

# required if running logrotate as non root user
touch logrotate.status

/usr/sbin/logrotate -f -s logrotate.status event-capture.logrotate

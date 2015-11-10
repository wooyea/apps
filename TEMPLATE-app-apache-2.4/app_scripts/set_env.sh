#!/bin/bash

##############################################################################
# APP set_env common segment. !!! Do not modify !!!
###### APP set_env begin #####################################################

export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APP_DIR_NAME=`basename $APP_DIR`
export APP_NAME=${APP_DIR_NAME:4}

###### APP set_env end   #####################################################

export HTTPD='/usr/sbin/httpd'
export STATUSURL="http://localhost:8088/server-status"

export APACHE_RUN_DIR=$APP_DIR
export APACHE_CONF=$APP_DIR/conf/httpd.conf

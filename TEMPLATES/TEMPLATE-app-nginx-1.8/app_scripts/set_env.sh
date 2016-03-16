#!/bin/bash

##############################################################################
# APPS set_env common segment. !!! Do not modify !!!
###### APPS set_env begin ####################################################

export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APP_DIR_NAME=`basename $APP_DIR`
export APP_NAME=${APP_DIR_NAME:4}

###### APPS set_env end  #####################################################

export NGINX_RUN_HOME=$APP_DIR
export NGINX_BIN=/usr/bin/nginx
export NGINX_CONF=$NGINX_RUN_HOME/etc/nginx.conf
export NGINX_PID=$NGINX_RUN_HOME/var/nginx.pid

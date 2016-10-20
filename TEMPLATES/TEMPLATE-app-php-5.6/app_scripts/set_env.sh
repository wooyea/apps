#!/bin/bash

##############################################################################
# APPS set_env common segment. !!! Do not modify !!!
######APPS set_env begin #####################################################

export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APP_DIR_NAME=`basename $APP_DIR`
export APP_NAME=${APP_DIR_NAME:4}

######APPS set_env end   #####################################################

export PHP_HOME=/usr #A_CHECK
export PHP_RUN_HOME=$APP_DIR
export PHP_INI_DIR=$PHP_RUN_HOME/etc
export PHP_VAR=$PHP_RUN_HOME/var
mkdir -p $PHP_VAR

export PHP_FPM_PID=$APP_DIR/var/php-fpm.pid

export PHP_FPM_CONF=$PHP_RUN_HOME/etc/php-fpm.conf

export PHP_LOG_DIR=$APP_DIR/logs
mkdir -p $PHP_LOG_DIR

export PHP_FPM_BIN=$PHP_HOME/bin/php-fpm

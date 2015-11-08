#!/bin/bash

##############################################################################
# APP set_env common segment. !!! Do not modify !!!
###### APP set_env begin #####################################################

export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APP_NAME=`basename $APP_DIR`

###### APP set_env end   #####################################################

export JAVA_HOME=/data1/common/jdk1.7
#export JAVA_OPTS=

export TOMCAT_HOME=/data1/common/apache-tomcat-7.0.65
export CATALINA_BASE=$APP_DIR
export CATALINA_PID=$APP_DIR/var/${APP_NAME}.pid
export CATALINA_LOG=/log1/sunbuyer/${APP_NAME}
mkdir -p $CATALINA_LOG
export CATALINA_OUT=$CATALINA_LOG/catalina.out
export CATALINA_OPTS=" -DCATALINA_LOG=$CATALINA_LOG"

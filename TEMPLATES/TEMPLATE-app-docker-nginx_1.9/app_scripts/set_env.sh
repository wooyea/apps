#!/bin/bash

##############################################################################
# TGGJ set_env common segment. !!! Do not modify !!!
######TGGJ set_env begin #####################################################
export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
source ${APP_DIR}/../INSTANCE_*
export APP_DIR_NAME=`basename $APP_DIR`
export APP_TYPE="DEFAULT"

export APP_NAME=${APP_DIR_NAME:4}
[ ${APP_NAME:0:7}=="docker-" ] && export APP_TYPE="DOCKER" && \
	export APP_NAME=${APP_NAME:7} && export DOCKER_CONTAINER_NAME=${INSTANCE_NAME}-${APP_NAME}


######TGGJ set_env end   #####################################################

mkdir -p $APP_DIR/{etc,var/cache/nginx,log}

#!/bin/sh

##############################################################################
# APPS common segment. !!! Do not modify !!!
###### APPS begin #############################################################

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`/"$link"
    fi  
done

export PRG_RELATIVE_DIR=`dirname "$PRG"`
source $PRG_RELATIVE_DIR/../../common/header.sh
###### APPS end ##############################################################


app_init() {

   # run as host root
   export RUN_USER_ID=`id -u root`
   export RUN_GROUP_ID=`id -g root`
   su_run "mkdir -p $APP_DIR/var/cache/nginx"

   docker create --net=host \
   --name $DOCKER_CONTAINER_NAME \
   -v ${APP_DIR}/etc/nginx:/etc/nginx  \
   -v ${APP_DIR}/../deploy/nginx:/usr/share/nginx  \
   -v ${APP_LOG_DIR}:/log1 \
   -v ${APP_DIR}/var:/var \
   $APP_INIT_OPTS \
   nginx:1.9 nginx -g "daemon off;"


   # run as host non-root user
   #docker create --net=host -u $RUN_USER_ID:$RUN_GROUP_ID \
   #--name $DOCKER_CONTAINER_NAME \
   #-v ${APP_DIR}/etc/nginx:/etc/nginx  \
   #-v ${APP_LOG_DIR}:/log1 \
   #-v ${APP_DIR}/var:/var \
   #$APP_INIT_OPTS \
   #nginx:1.9 nginx -g "daemon off;"

}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

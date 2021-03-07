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
   export VAR_HOST=$APP_DIR/var
   su_run "mkdir -p ${VAR_HOST}/log/nginx"
   su_run "mkdir -p ${VAR_HOST}/cache/nginx/client_temp"

   docker create --net=host \
   --name $DOCKER_CONTAINER_NAME \
   --restart=always \
   -v ${APP_DIR}/etc/nginx:/etc/nginx  \
   -v ${APP_DIR}/../deploy/nginx:/usr/share/nginx  \
   -v ${APP_DIR}/../deploy/nginx/mirrors:/usr/share/mirrors/  \
   -v ${APP_LOG_DIR}:/log1 \
   -v ${VAR_HOST}:/var \
   $APP_INIT_OPTS \
   nginx:1.15 nginx -g "daemon off;"

}

app_test() {
  docker exec -it $DOCKER_CONTAINER_NAME  bash -c '/usr/sbin/nginx -t'
}

app_reload() {
  docker exec -it $DOCKER_CONTAINER_NAME  bash -c '/usr/sbin/nginx -s reload'
}
##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

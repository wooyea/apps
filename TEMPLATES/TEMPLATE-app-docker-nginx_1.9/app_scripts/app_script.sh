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
source $PRG_RELATIVE_DIR/set_env.sh

###### APPS end ##############################################################

init() {
   docker create --net=host -u $RUN_USER_ID:$RUN_GROUP_ID \
   --name $DOCKER_CONTAINER_NAME \
   -v ${APP_DIR}/etc/nginx:/etc/nginx  \
   -v ${APP_DIR}/var:/var \
   -v ${APP_DIR}/log:/log1 \
   $APP_INIT_OPTS \
   nginx:1.9
}

start() {
   docker start $DOCKER_CONTAINER_NAME
}

stop() {
   docker stop $DOCKER_CONTAINER_NAME
}

kill() {
   docker kill $DOCKER_CONTAINER_NAME
}

clear() {
   docker rm -v $DOCKER_CONTAINER_NAME
}

log() {
   docker logs $DOCKER_CONTAINER_NAME
}

status() {
   docker stats $DOCKER_CONTAINER_NAME
}

case "$1" in
    init)
    init
    ;;
    start)
    start
    ;;
    stop)
    stop
    ;;
    kill)
    kill
    ;;
    clear)
    clear
    ;;
    log)
    log
    ;;
    status)
    status
    ;;
    *)
    echo $"Usage: $0 {init|start|stop|kill|clear|log|status}"
    exit 2
esac

exit $?

#!/bin/sh

##############################################################################
# APPS common header segment. !!! Do not modify !!!
###### APPS header begin #####################################################

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
###### APPS header end #######################################################




# apache run as no-root user
#
#    docker create --name $DOCKER_CONTAINER_NAME \
#        --net=host -u $RUN_USER_ID:$RUN_GROUP_ID \
#        -v ${APP_DIR}/etc/apache2:/etc/apache2 \
#        -v ${APP_DIR}/etc:/usr/local/etc \
#        -v ${APP_DIR}/../websites:/var/websites \
#        -v ${APP_DIR}/var/apache2:/var/apache2 \
#        -v ${APP_DIR}/var/php_session:/var/php_session \
#        -v ${APP_LOG_DIR}:/log1 \
#        registry.aliyuncs.com/wql/php:5.6 apache2-foreground


# apache run as root , privilege ports under 1024 needs root
#    docker create --name $DOCKER_CONTAINER_NAME \
#        --net=host \
#        --cap-add net_bind_service \
#        -v ${APP_DIR}/etc/apache2:/etc/apache2 \
#        -v ${APP_DIR}/etc:/usr/local/etc \
#        -v ${APP_DIR}/../websites:/var/websites \
#        -v ${APP_DIR}/var/apache2:/var/apache2 \
#        -v ${APP_DIR}/var/php_session:/var/php_session \
#        -v ${APP_LOG_DIR}:/log1 \
#        registry.aliyuncs.com/wql/php:5.6 apache2-foreground

init() {

    # run as root
    docker create --name $DOCKER_CONTAINER_NAME \
        --net=host \
        --cap-add net_bind_service \
        -v ${APP_DIR}/etc/apache2:/etc/apache2 \
        -v ${APP_DIR}/etc:/usr/local/etc \
        -v ${APP_DIR}/../websites:/var/websites \
        -v ${APP_DIR}/var/apache2:/var/apache2 \
        -v ${APP_DIR}/var/php_session:/var/php_session \
        -v ${APP_LOG_DIR}:/log1 \
        registry.aliyuncs.com/wql/php:5.6 apache2-foreground

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

remove() {
    docker rm -v $DOCKER_CONTAINER_NAME
}

log() {
    docker logs $DOCKER_CONTAINER_NAME
}

clear() {
    docker rm -v $DOCKER_CONTAINER_NAME
}

restart() {
    docker restart $DOCKER_CONTAINER_NAME
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
    remove)
    remove
    ;;
    log)
    log
    ;;
    clear)
    clear
    ;;
    restart)
    restart
    ;;
    *)
    echo $"Usage: $0 {init|start|stop|kill|remove|log|clear|restart}"
    exit 2
esac

exit $?

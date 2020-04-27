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
#        -v ${APP_DIR}/../deploy:/var/deploy \
#        -v ${APP_DIR}/var/apache2:/var/apache2 \
#        -v ${APP_DIR}/var/php_session:/var/php_session \
#        -v ${APP_LOG_DIR}:/log1 \
#        $APP_INIT_OPTS \
#        --restart=always \
#        registry.aliyuncs.com/wql/php:5.6 apache2-foreground


# apache run as root , privilege ports under 1024 needs root
#    docker create --name $DOCKER_CONTAINER_NAME \
#        --net=host \
#        --cap-add net_bind_service \
#        -v ${APP_DIR}/etc/apache2:/etc/apache2 \
#        -v ${APP_DIR}/etc:/usr/local/etc \
#        -v ${APP_DIR}/../deploy:/var/deploy \
#        -v ${APP_DIR}/var/apache2:/var/apache2 \
#        -v ${APP_DIR}/var/php_session:/var/php_session \
#        -v ${APP_LOG_DIR}:/log1 \
#        $APP_INIT_OPTS \
#        --restart=always \
#        registry.aliyuncs.com/wql/php:5.6 apache2-foreground

app_init() {

    # run as root
    docker create --name $DOCKER_CONTAINER_NAME \
        --net=host \
        --cap-add net_bind_service \
        -v ${APP_DIR}/etc/apache2:/etc/apache2 \
        -v ${APP_DIR}/etc:/usr/local/etc \
        -v ${APP_DIR}/../deploy:/var/deploy \
        -v ${APP_DIR}/var/apache2:/var/apache2 \
        -v ${APP_DIR}/var/php_session:/var/php_session \
        -v ${APP_LOG_DIR}:/log1 \
        $APP_INIT_OPTS \
        --restart=always \
        apps/php:5.6 apache2-foreground

}

app_check() {
    docker exec $DOCKER_CONTAINER_NAME  apache2 -t
}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

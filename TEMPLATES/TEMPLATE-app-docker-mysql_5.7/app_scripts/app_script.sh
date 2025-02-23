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

app_init() {
    
    [ -d $DATA_DIR ] || su_run "mkdir -p $DATA_DIR" 

    docker create --net=host                    \
        --name $DOCKER_CONTAINER_NAME           \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${APP_DIR}/var/mysqld:/var/mysqld    \
        -v ${APP_DIR}/etc/my.cnf:/etc/my.cnf    \
        -v ${APP_DIR}/etc/my.cnf.d:/etc/my.cnf.d    \
        -v ${APP_DIR}/etc/mysql:/etc/mysql      \
        -v ${DATA_DIR}:/var/lib/mysql           \
        -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD   \
        --oom-kill-disable                      \
        --restart=always                        \
        $APP_INIT_OPTS                         \
        mysql:5.7.44
        
}

app_client() {
    docker exec -it $DOCKER_CONTAINER_NAME  bash -c 'export TERM=xterm; mysql --defaults-file=/etc/mysql/my.cnf -S /var/mysqld/mysqld.sock -u root -p'
}

app_client2() {
    docker exec -it $DOCKER_CONTAINER_NAME  bash -c 'export TERM=xterm; mysql -h 127.0.0.1 -u root -p'
}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

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
    
    [ -d $DATA_DIR ] || mkdir $DATA_DIR  || sudo chown $RUN_USER:$RUN_GROUP $DATA_DIR 

    docker create --net=host                    \
        --name $DOCKER_CONTAINER_NAME           \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${APP_DIR}/var/mysqld:/var/mysqld    \
        -v ${APP_DIR}/etc/mysql:/etc/mysql      \
        -v ${DATA_DIR}:/var/lib/mysql           \
        -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD   \
        --oom-kill-disable                      \
        --restart=always                        \
        tggj/mariadb:10.1
        
}

app_client() {
    docker exec -it $DOCKER_CONTAINER_NAME  bash -c 'export TERM=xterm; mysql --defaults-file=/etc/mysql/my.cnf -S /var/mysqld/mysqld.sock -u root -p'
}


##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################
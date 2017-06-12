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

        #-u $RUN_USER_ID:$RUN_GROUP_ID           \
#
    
    docker create --net=host                    \
        --name $DOCKER_CONTAINER_NAME           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${APP_HOST}:/usr/src/myapp		\
        -v ${ATTACHMENT_HOST}:/usr/src/myapp/attachment	\
	--restart=always			\
        -e RMI_HOSTNAME=$MAIN_IP                \
        $APP_INIT_OPTS                          \
        openjdk:8-jdk /usr/src/myapp/scripts/start.sh
#
        
#openjdk:8-jdk 'cd /usr/src/myapp/scripts  && /bin/bash start.sh'


}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

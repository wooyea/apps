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
    
    [ -f "${GERRIT_APP_HOST}/etc/ssh_host_rsa_key" ] || su_run "cp default_keys/* $GERRIT_APP_HOST/etc/ " 
    
    docker create --net=host                    \
        --privileged				\
	 --name $DOCKER_CONTAINER_NAME          \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${GERRIT_DEPLOY_HOST}:/usr/src/myapp \
        $APP_INIT_OPTS                          \
        openjdk:8-jdk ${GERRIT_APP_DOCKER}/bin/gerrit.sh run -d ${GERRIT_APP_DOCKER}
}

app_reindex() {
    
    docker run -it --rm --net=host              \
        --privileged \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${GERRIT_DEPLOY_HOST}:/usr/src/myapp \
        $APP_INIT_OPTS                          \
        openjdk:8-jdk java -jar ${GERRIT_APP_DOCKER}/bin/gerrit.war reindex -d ${GERRIT_APP_DOCKER}
}

app_install() {

    export GERRIT_WAR_HOST=${GERRIT_DEPLOY_HOST}/${GERRIT_WAR}
    [ -f "$GERRIT_WAR_HOST" ] || su_run "mkdir -p ${GERRIT_APP_HOST}  &&  cp $GERRIT_WAR $GERRIT_WAR_HOST " 
    # chcon -Rt svirt_sandbox_file_t $GERRIT_WAR_HOST

    docker run -it --rm --net=host              \
        --privileged \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${GERRIT_DEPLOY_HOST}:/usr/src/myapp \
        $APP_INIT_OPTS                          \
        openjdk:8-jdk java -jar /usr/src/myapp/${GERRIT_WAR} init -d ${GERRIT_APP_DOCKER}

}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

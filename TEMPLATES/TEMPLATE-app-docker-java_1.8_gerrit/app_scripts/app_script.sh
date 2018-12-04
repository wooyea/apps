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

su_run "mkdir -p ${GERRIT_APP_HOST}"

GERRIT_WAR_HOST=${GERRIT_DEPLOY_HOST}/${GERRIT_WAR}
[ -f "$GERRIT_WAR_HOST" ] || echo "$GERRIT_WAR_HOST not found" || exit
chcon -Rt svirt_sandbox_file_t $GERRIT_WAR_HOST

app_init() {
    
    docker create --net=host              \
        --name $DOCKER_CONTAINER_NAME           \
	--privileged				\
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${GERRIT_DEPLOY_HOST}:/usr/src/myapp \
        $APP_INIT_OPTS                          \
        openjdk:8-jdk java -jar /usr/src/myapp/gerrit_app/bin/gerrit.war daemon \
	-d /usr/src/myapp/gerrit_app 
}

app_install() {

    docker run -it --rm --net=host              \
        --name $DOCKER_CONTAINER_NAME           \
	--privileged				\
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${GERRIT_DEPLOY_HOST}:/usr/src/myapp \
        $APP_INIT_OPTS                          \
	openjdk:8u102-jdk java -jar /usr/src/myapp/${GERRIT_WAR} init -d /usr/src/myapp/gerrit_app


}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

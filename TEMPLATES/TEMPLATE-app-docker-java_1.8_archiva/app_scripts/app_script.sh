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

[ -f "${ARCHIVA_APP_HOST}/bin/archiva" ] || echo "archiva all in one dir not found " || exit;
[ -f "${ARCHIVA_APP_HOST}/bin/archiva_docker" ] \
    || su_run "cp ${APP_DIR}/app_scripts/template_archiva_docker ${ARCHIVA_APP_HOST}/bin/archiva_docker" \
    || su_run "chmod +x ${ARCHIVA_APP_HOST}/bin/archiva_docke"

app_init() {
    
    docker create --net=host                    \
        --name $DOCKER_CONTAINER_NAME           \
        -u $RUN_USER_ID:$RUN_GROUP_ID           \
        -v ${APP_LOG_DIR}:/log1                 \
        -v ${ARCHIVA_APP_HOST}:/usr/src/myapp   \
        $APP_INIT_OPTS                          \
        openjdk:8u102-jdk  /usr/src/myapp/bin/archiva_docker start
}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

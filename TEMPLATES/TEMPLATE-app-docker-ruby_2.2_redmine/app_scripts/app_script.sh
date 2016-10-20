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

    docker create --name $DOCKER_CONTAINER_NAME \
        --net=host \
        $APP_INIT_OPTS \
        -v ${APP_DIR}/../deploy/redmine:/usr/workdir \
        -v ${APP_LOG_DIR}:/usr/workdir/log \
        -e RAILS_ENV=production \
        apps/ruby:2.2

        #--restart=always \
#
#        -u $RUN_USER_ID:$RUN_GROUP_ID \

}

##############################################################################
# APPS common footer segment. !!! Do not modify !!!
###### APPS footer begin #####################################################

source $PRG_RELATIVE_DIR/../../common/footer.sh

###### APPS footer end #######################################################

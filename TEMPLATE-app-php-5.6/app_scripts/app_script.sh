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

start() {
    $PHP_FPM_BIN --prefix $PHP_RUN_HOME \
    --fpm-config $PHP_FPM_CONF -c $PHP_RUN_HOME \
    --pid $PHP_FPM_PID
}

stop() {
    /bin/kill `cat $PHP_FPM_PID`
}

case "$1" in
    start)
    start
    ;;
    stop)
    stop
    ;;
    *)
    echo $"Usage: $0 {start|stop}"
    exit 2
esac

exit $?

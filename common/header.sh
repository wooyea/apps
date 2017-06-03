export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APPS_DIR=${APP_DIR}/../
source $APPS_DIR/INSTANCE
export APP_DIR_NAME=`basename $APP_DIR`

OLD_IFS=$IFS
IFS=-

APP_NAME_ARRAY=($APP_DIR_NAME)

export APP_TYPE=${APP_NAME_ARRAY[1]}
export APP_NAME=${APP_NAME_ARRAY[2]}

IFS=$OLD_IFS

export APP_LOG_DIR=$LOG_BASE/$INSTANCE_NAME/$APP_TYPE-$APP_NAME/


get_ip() {
    local  __resultvar=$2
    local  myresult=`ifconfig $1 | awk '/inet /{print $2}'`
    if [[ "$__resultvar" ]]; then
        eval $__resultvar="'$myresult'"
    fi
}
get_ip $MAIN_IF_NAME MAIN_IP

export APP_LOG_DIR=$LOG_BASE/$INSTANCE_NAME/$APP_TYPE-$APP_NAME/


APP_TYPE_COMMON_SCRIPT=$APPS_DIR/common/${APP_TYPE}_common.sh
[ -f $APP_TYPE_COMMON_SCRIPT ] && source $APP_TYPE_COMMON_SCRIPT

SET_ENV_FILE=$PRG_RELATIVE_DIR/set_env.sh
[ -f $SET_ENV_FILE ] && source $SET_ENV_FILE


su_run() {
    if [ "$RUN_USER" = "`whoami`" ]; then
        eval $1
    else
        echo " su to $RUN_USER than run $1" 
        cmd="su - $RUN_USER -c \"$1\""
        eval $cmd
    fi
}

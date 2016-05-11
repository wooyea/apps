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


APP_TYPE_COMMON_SCRIPT=$APPS_DIR/common/${APP_TYPE}_common.sh
[ -f $APP_TYPE_COMMON_SCRIPT ] && source $APP_TYPE_COMMON_SCRIPT

SET_ENV_FILE=$PRG_RELATIVE_DIR/set_env.sh
[ -f $SET_ENV_FILE ] && source $SET_ENV_FILE


su_run() {
    [ "$RUN_USER" = "`whoami`" ] && eval $1 || echo " su to $RUN_USER than run $1" \
         || `su - $RUN_USER -c $1`
}

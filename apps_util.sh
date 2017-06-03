
INSTANCE_PREFIX=INSTANCE_

INSTANCE_FILE="INSTANCE"
INSTANCE_NAME=""
LOG_BASE="/data1/log1/"
DOCKER_TZ=Asia/Shanghai
APP_PREFIX="app-"

[ $0 == "./apps_util.sh" ] || echo "This script must be named as !!apps_util.sh !!!, and must be runed under apps root dir."

APP_DIRS=`find . -maxdepth 1  -name "app-*" -type d `


check_instance () {
    which systemctl 2>&1>/dev/null
    [ $? -eq 0 ] && USE_SYSTEMD=1

    [ -f $INSTANCE_FILE ] && source $INSTANCE_FILE  \
        || echo "file $INSTANCE_FILE not found, exec 'apps_utils init' first."  \
        || exit -1;

}

show_usage () {
    echo $"Usage: $0 {init|list-services|gen-services|install-services|remove-services}"
}


get_instance_settings() {
    check_instance
}

init () {
    
    [ $# -lt 4 ] && echo " wrong params! init  instance_name username groupname main_if_name [path/to/log_base(/data1/log1)] [TZ(Asia/Shanghai)] " && exit 1
    INSTANCE_NAME=$2
    
    [ -f $INSTANCE_FILE ] && echo " File $INSTANCE_FILE is existed." &&  mv $INSTANCE_FILE ${INSTANCE_FILE}_bak_`date +%Y%m%d_%H%M%S`

    echo "create initance $INSTANCE_NAME for $3:$3"

#    touch $INSTANCE_FILE
    RUN_USER=$3
    RUN_GROUP=$4
    RUN_USER_ID=`id -u $RUN_USER`
    RUN_GROUP_ID=`id -g $RUN_GROUP`
    
    MAIN_IF_NAME=$5

    echo "#****** INSTANCE begin ******" >> $INSTANCE_FILE
    echo "export RUN_USER=$RUN_USER" >> $INSTANCE_FILE
    echo "export RUN_USER_ID=${RUN_USER_ID}" >> $INSTANCE_FILE
    echo "export RUN_GROUP=$RUN_GROUP" >> $INSTANCE_FILE
    echo "export RUN_GROUP_ID=${RUN_GROUP_ID}" >> $INSTANCE_FILE
    echo "export INSTANCE_NAME=${INSTANCE_NAME}" >> $INSTANCE_FILE
    [ $# -ge 6 ] && export LOG_BASE=$5
    echo "export LOG_BASE=${LOG_BASE}" >> $INSTANCE_FILE
    [ $# -ge 7 ] && export DOCKER_TZ=$6
    echo "export DOCKER_TZ=${DOCKER_TZ}" >> $INSTANCE_FILE
    echo "export MAIN_IF_NAME=${MAIN_IF_NAME}" >> $INSTANCE_FILE
    echo "#****** INSTANCE end ******" >> $INSTANCE_FILE

    chmod +x $INSTANCE_FILE
    mkdir -p db_data
    mkdir -p deploy
    sudo chown $RUN_USER:$RUN_GROUP apps_util.sh  common  db_data  INSTANCE  readme.txt  TEMPLATES  deploy -R
    
    export INSTANCE_LOG_DIR=$LOG_BASE/$INSTANCE_NAME
    mkdir -p $INSTANCE_LOG_DIR
    sudo chown $RUN_USER:$RUN_GROUP $INSTANCE_LOG_DIR
}

process_services () {
    check_instance

    for DIR in $APP_DIRS
    do
        echo "==== gen service for $DIR ===="

        APP_DIR=$(cd $DIR;pwd)

        case "$1" in
            gen-services)

            cd $DIR/app_services
            rm -f *service
            APP_DIR_NAME=`basename $APP_DIR`
            APP_NAME=${APP_DIR_NAME:4}

            SERVICE_TEMPLATE_FILES=`find ./ -maxdepth 1 -name '*service-template'  `
            for TEMPLATE_PATH in $SERVICE_TEMPLATE_FILES
            do

                TEMPLATE=${TEMPLATE_PATH:2}
                SERVICE_FILE=${INSTANCE_NAME}_${APP_NAME}_${TEMPLATE:0:-9}

                echo "gen [$SERVICE_FILE]"
                cp $TEMPLATE $SERVICE_FILE

                sed -i "s#%APP_DIR%#${APP_DIR}#g"  $SERVICE_FILE
                sed -i "s#%APP_NAME%#${APP_NAME}#g"  $SERVICE_FILE
                sed -i "s#%RUN_USER%#${RUN_USER}#g"  $SERVICE_FILE
                sed -i "s#%RUN_GROUP%#${RUN_GROUP}#g"  $SERVICE_FILE
                sed -i "s#%INSTANCE_NAME%#${INSTANCE_NAME}#g"  $SERVICE_FILE

                # VARS=`grep -e '${[a-zA-Z0-9_-]*}' $SERVICE_FILE -o`
                # # for VAR in $VARS
                # do
                #     #echo $VAR
                # done
            done
            cd -
            ;;
            install-services)

            cd $DIR/app_services
            sudo cp *service /usr/lib/systemd/system/
            cd -
            ;;

        esac
    done



}

list_services() {
    check_instance
    systemctl list-unit-files | grep  $INSTANCE_NAME
   
}

state_services() {
    check_instance
    systemctl list-units | grep  ^$INSTANCE_NAME
   
}

chown_files() {
    check_instance
    source  ./INSTANCE
    sudo chown $RUN_USER:$RUN_GROUP -R $2
   
}

case "$1" in
    init)
    init $*
    ;;
    gen-services)
    process_services $1
    ;;
    install-services)
    process_services $1
    ;;
    enable-services)
    install_services
    ;;
    disable-services)
    install_services
    ;;
    remove-services)
    remove_services
    ;;
    list-services)
    list_services
    ;;
    state-services)
    state_services
    ;;
    chown)
    chown_files $*
    ;;
    *)
    show_usage
    exit 2
esac

exit $?

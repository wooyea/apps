
INSTANCE_PREFIX=INSTANCE_

INSTANCE_FILE=""
INSTANCE_NAME=""

[ $0 == "./apps_util.sh" ] || echo "This script must be named as !!apps_util.sh !!!, and must be runed under apps root dir."

APP_DIRS=`find . -name "app-*" -type d`


check_instance () {
    which systemctl 2>&1>/dev/null
    [ $? -eq 0 ] && USE_SYSTEMD=1

    INSTANCE_FILE_COUNT=`find  . -maxdepth 1 -type f -name ${INSTANCE_PREFIX}* 2>/dev/null | wc -l`
    [ $INSTANCE_FILE_COUNT -eq 0 ] && echo "No instance exist, run ./apps_scripts.sh init {instance_name} first." && exit 1
    [ $INSTANCE_FILE_COUNT -gt 1 ] && echo "More than one file named with prefix INSTANCE_, pls check first" && exit 1
    INSTANCE_FILE=`find  . -maxdepth 1 -type f -name ${INSTANCE_PREFIX}*`

    INSTANCE_NAME=${INSTANCE_FILE:11}
    source $INSTANCE_FILE


}

show_usage () {
    echo $"Usage: $0 {init|list-services|gen-services|install-services|remove-services}"
}


get_instance_settings() {
    check_instance
}

init () {
    [ $# != 1 ] && echo "init  {instance_name}" && exit 1
    INSTANCE_NAME=$1

    echo "create initance $INSTANCE_NAME"

    INSTANCE_FILE=${INSTANCE_PREFIX}${INSTANCE_NAME}

    touch $INSTANCE_FILE
    CURRENT_USER=`whoami`
    CURRENT_GROUP=`groups | awk '{print $1}'`
    echo "export RUN_USER=${CURRENT_USER}" >> $INSTANCE_FILE
    echo "export RUN_GROUP=${CURRENT_GROUP}" >> $INSTANCE_FILE
    chmod +x $INSTANCE_FILE
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

case "$1" in
    init)
    init $2
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
    *)
    show_usage
    exit 2
esac

exit $?

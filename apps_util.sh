
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
    echo $"Usage: $0 {init|gen-services|install-services|remove-services}"
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
}

gen_services () {
    check_instance

    for DIR in $APP_DIRS
    do

        APP_PATH=$(cd $DIR;pwd)
        cd $DIR/app_services
        rm -f *service
        APP_NAME=`basename $APP_PATH`

        SERVICE_TEMPLATE_FILES=`find ./ -maxdepth 1 -name '*service-template'  `
        for TEMPLATE_PATH in $SERVICE_TEMPLATE_FILES
        do
            TEMPLATE=${TEMPLATE_PATH:2}
            SERVICE_FILE=${INSTANCE_NAME}_${APP_NAME}_${TEMPLATE:0:-9}

            cp $TEMPLATE $SERVICE_FILE

            sed -i "s#%APP_PATH%#${APP_PATH}#g"  $SERVICE_FILE
            sed -i "s#%APP_NAME%#${APP_NAME}#g"  $SERVICE_FILE
            sed -i "s#%INSTANCE_NAME%#${INSTANCE_NAME}#g"  $SERVICE_FILE

            VARS=`grep -e '${[a-zA-Z0-9_-]*}' $SERVICE_FILE -o`
            for VAR in $VARS
            do
                echo $VAR
            done
        done

        cd -
    done



}

install_services () {
    echo "xxxx"

}


case "$1" in
    init)
    init $2
    ;;
    gen-services)
    gen_services
    ;;
    install-services)
    install_services
    ;;
    enable-services)
    install_services
    ;;
    disable-services)
    install_services
    ;;
    remove-services)
    install_services
    ;;
    *)
    show_usage
    exit 2
esac

exit $?

#!/bin/bash

#APP_FUNCTIONS=`declare -F | awk '{print $3}' | grep '^app_'`

APP_FUNCTIONS=`declare -F | awk '{print $3}' | grep 'app_' | cut -c 5-`

usage() {
    echo "usage : "
    echo "    available functions - "${APP_FUNCTIONS[@]}
    
    exit 0
}


[ $# -eq 0 ] && usage;

FUNCTION_TO_CALL=$1

for FUN in $APP_FUNCTIONS
do
    if [ "$FUN" = "$FUNCTION_TO_CALL" ]
    then 
        echo "call $FUNCTION_TO_CALL..." 
        eval app_$FUNCTION_TO_CALL $@
        exit
    fi
done

echo "Wrong parameters"
usage

exit $?
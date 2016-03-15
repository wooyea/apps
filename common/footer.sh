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
    [ "$FUN" = "$FUNCTION_TO_CALL" ] && echo "call $FUNCTION_TO_CALL..." && eval app_$FUNCTION_TO_CALL $@ 
done

echo "Wrong parameters"
usage

exit $?
#!/bin/bash

INIT_FILE=app_init.sh

if [ -f "$INIT_FILE" ]; then
    set -x
    ./$INIT_FILE
    [ $? -ne 0 ] && echo "exec $INIT_FILE failed" &&exit -1;
    set -e
fi

exec "$@"

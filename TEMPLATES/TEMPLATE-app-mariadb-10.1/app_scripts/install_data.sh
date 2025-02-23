#!/bin/bash

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

$MYSQL_INSTALL_DB_BIN --basedir=$MARIADB_HOME --defaults-file=$MARIADB_CNF --datadir=$MARIADB_DATA_DIR

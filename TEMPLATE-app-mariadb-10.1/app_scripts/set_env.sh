#!/bin/bash

##############################################################################
# APP set_env common segment. !!! Do not modify !!!
###### APP set_env begin #####################################################

export PRG_DIR=$(cd $PRG_RELATIVE_DIR;pwd)
export APP_DIR=$(cd $PRG_DIR/..;pwd)
export APP_DIR_NAME=`basename $APP_DIR`
export APP_NAME=${APP_DIR_NAME:4}

###### APP set_env end   #####################################################

export MARIADB_HOME=/data1/common/mariadb-10.1


export MYSQLD_BIN=$MARIADB_HOME/bin/mysqld
export MYSQL_INSTALL_DB_BIN=$MARIADB_HOME/scripts/mysql_install_db
export MYSQL_CLIENT_BIN=$MARIADB_HOME/bin/mysql
export MARIADB_DATA_DIR=$APP_DIR/data
export MARIADB_CNF=$APP_DIR/etc/my.cnf

#PID path must be the same with PIDFile in app_services/mysqld.service-template
export MARIADB_PID=$APP_DIR/var/mariadb.pid

mkdir -p $APP_DIR/var/
export MARIADB_SOCKET=$APP_DIR/var/mysql.sock
export MARIADB_LOG_DIR=/log1/sunbuyer/mariadb
mkdir -p $MARIADB_LOG_DIR
export MARIADB_ERROR_LOG=$MARIADB_LOG_DIR/mysql.err.log

export MARIADB_STOP_TIMEOUT=60

export PATH=$MARIADB_HOME/bin:$MARIADB_HOME/sbin:$PATH
export LD_LIBRARY_PATH=$MARIADB_HOME/lib:$LD_LIBRARY_PATH

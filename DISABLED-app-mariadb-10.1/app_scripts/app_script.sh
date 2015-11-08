##############################################################################
# TGGJ common segment. !!! Do not modify !!!
######TGGJ begin #############################################################

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

######TGGJ end ##############################################################
start () {

$MARIADB_HOME/bin/mysqld --defaults-file=$MARIADB_CNF \
 --basedir=$MARIADB_HOME \
 --log-error=$MARIADB_ERR_LOG \
 --socket=$MARIADB_SOCKET  \
 --pid-file=$MARIADB_PID \
 --datadir=$MARIADB_DATA_DIR &

}


stop () {
  /bin/kill `cat $MARIADB_PID` >/dev/null 2>&1
  ret=$?
  if [ $ret -eq 0 ]; then
    TIMEOUT=$MARIADB_STOP_TIMEOUT
    while [ $TIMEOUT -gt 0 ]; do
      /bin/kill -0 "$MARIADB_PID" >/dev/null 2>&1 || break
      sleep 1
      let TIMEOUT=${TIMEOUT}-1
    done
    if [ $TIMEOUT -eq 0 ]; then
      echo "Timeout error occurred trying to stop MySQL Daemon."
      echo $"Stopping $prog: timeout"
    else
      #rm -f "$MARIADB_SOCK"
      echo $"Stopping $prog: finished"
    fi
  else
    echo $"Stopping $prog: failed"
  fi
}


# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo $"Usage: $0 {start|stop}"
    exit 2
esac

exit $?




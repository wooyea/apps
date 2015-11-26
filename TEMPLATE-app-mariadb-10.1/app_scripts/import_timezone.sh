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
$MARIADB_HOME/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | $MYSQL_CLIENT_BIN --defaults-file=$MARIADB_CNF  -S $MARIADB_SOCKET mysql

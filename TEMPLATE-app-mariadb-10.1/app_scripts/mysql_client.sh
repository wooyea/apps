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
$MYSQL_CLIENT_BIN --defaults-file=/opt/scm/tools/mysql/etc/my.cnf  -S /opt/scm/tools/mysql/var/mysql.sock

#!/bin/sh

##############################################################################
# APP common segment. !!! Do not modify !!!
###### APP begin #############################################################

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

###### APP end ###############################################################

#
# The exit codes returned are:
#   XXX this doc is no longer correct now that the interesting
#   XXX functions are handled by httpd
#	0 - operation completed successfully
#	1 -
#	2 - usage error
#	3 - httpd could not be started
#	4 - httpd could not be stopped
#	5 - httpd could not be started during a restart
#	6 - httpd could not be restarted during a restart
#	7 - httpd could not be restarted during a graceful restart
#	8 - configuration syntax error
#
# When multiple arguments are given, only the error from the _last_
# one is reported.  Run "apachectl help" for usage info
#
ACMD="$1"
ARGV="$@"
#
# |||||||||||||||||||| START CONFIGURATION SECTION  ||||||||||||||||||||
# --------------------                              --------------------
#
# a command that outputs a formatted text version of the HTML at the
# url given on the command line.  Designed for lynx, however other
# programs may work.
LYNX="lynx -dump"
#
# Set this variable to a command that increases the maximum
# number of file descriptors allowed per child process. This is
# critical for configurations that use many file descriptors,
# such as mass vhosting, or a multithreaded server.
ULIMIT_MAX_FILES="ulimit -S -n `ulimit -H -n`"
# --------------------                              --------------------
# ||||||||||||||||||||   END CONFIGURATION SECTION  ||||||||||||||||||||

# Set the maximum number of file descriptors allowed per child process.
if [ "x$ULIMIT_MAX_FILES" != "x" ] ; then
    $ULIMIT_MAX_FILES
fi

ERROR=0
if [ "x$ARGV" = "x" ] ; then
    ARGV="-h"
fi

case $ACMD in
start|stop|restart|graceful|graceful-stop)
    $HTTPD -k $ARGV  -d $APP_DIR -f $APACHE_CONF
    ERROR=$?
    ;;
configtest)
    $HTTPD -t
    ERROR=$?
    ;;
status)
    #$LYNX $STATUSURL | awk ' /process$/ { print; exit } { print } '
    ;;
fullstatus)
    $LYNX $STATUSURL
    ;;
*)
    $HTTPD "$@"
    ERROR=$?
esac

exit $ERROR

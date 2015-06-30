#!/bin/sh
#
# ords   Start/Stop the service ords.
#
# chkconfig: 345 90 60
# description: ords is written in java and provides a service.

SERVICE_NAME=ords
USERNAME=ords
ERROR_LOG=/var/logs/ords/err.log
LOG=/var/logs/ords/out.log
SERVICE_HOME=/opt/ords.3.0.0
PATH_TO_WAR=/opt/ords.3.0.0/ords.war
STOP_TIMEOUT_SECS=120

# Derived values:
PID_PATH_NAME=/var/run/${SERVICE_NAME}/${SERVICE_NAME}-pid
JAVA_BIN=${JAVA_HOME}/jre/bin/java

if [ -z "$JAVA_HOME" ]; then
  JAVA_BIN=$(which java)
fi

cd ${SERVICE_HOME}

function is_running() {
  if [ -f $PID_PATH_NAME ]; then
    PID=$(cat $PID_PATH_NAME)
    ps -p ${PID} > /dev/null
    if [ $? -eq 0 ]; then
      return 0
    fi
  fi
  return 1
}

function reload_config() {
  if [[ ${SERVICE_HOME}/params/ords_params.properties -nt ${SERVICE_HOME}/config_updated_at ]]; then
    touch ${SERVICE_HOME}/config_updated_at

    mkdir -p ${SERVICE_HOME}/conf
    su ${USERNAME} -c "cd ${SERVICE_HOME} ; java -jar ords.war configdir ${SERVICE_HOME}/conf "
  fi

  return 0
}


function start_service() {
  echo "Starting $SERVICE_NAME ..."
  if ! is_running; then
    reload_config
    su ${USERNAME} -c "cd ${SERVICE_HOME} ; nohup ${JAVA_BIN} -Dfile.encoding=UTF-8 -jar $PATH_TO_WAR 2>> ${ERROR_LOG} >>${LOG} & echo \$! > $PID_PATH_NAME"
    exit_code=$?
    PID=$(cat $PID_PATH_NAME)
    if [ $exit_code -eq 0 ]; then
      ps -p ${PID} > /dev/null
      if [ $? -ne 0 ]; then
        echo "$SERVICE_NAME errored after starting - NOT started ..."
      else
        echo "Success..."
        # TODO Wait until service up by polling management port...
        exit 0
      fi
    else
      echo "$SERVICE_NAME errored on start up - terminating process ..."
    fi
    kill $PID
    rm -f $PID_PATH_NAME
    exit 1
  else
    echo "$SERVICE_NAME is already running ..."
  fi
}

function stop_service {
  if [ -f $PID_PATH_NAME ]; then
    PID=$(cat $PID_PATH_NAME)
    ps -p ${PID} > /dev/null
    if [ $? -ne 0 ]; then
      echo "$SERVICE_NAME errored after starting ..."
    else
      kill $PID
      COUNTER=$STOP_TIMEOUT_SECS
      while ps -p $PID >/dev/null; do
        COUNTER=$(($COUNTER - 1))
        if [[ $COUNTER -lt 1 ]]; then
          echo "ERROR STOPPING $SERVICE_NAME within ${STOP_TIMEOUT_SECS} seconds."
          exit 1
        else
          printf "."
        fi
        sleep 1
      done
    fi
    echo "$SERVICE_NAME stopped ..."
    rm -f $PID_PATH_NAME
  else
    echo "$SERVICE_NAME is not running ..."
  fi
}

case $1 in
  status)
    if [ -f $PID_PATH_NAME ]; then
      PID=$(cat $PID_PATH_NAME)
      ps -p ${PID} > /dev/null
      if [ $? -eq 0 ]; then
        echo "$SERVICE_NAME is running ..."
        exit 0
      fi
    fi
    echo "$SERVICE_NAME is not running ..."
    exit 3
  ;;
  start)
    start_service
  ;;
  stop)
    stop_service
  ;;
  restart)
    stop_service
    start_service
  ;;
esac

#!/bin/bash
#Nandang Sopyan
#http://nandang.id

IS_ACTIVE=0
DATE=$(date +%d-%m-%Y_%H:%M:%S)
SERVICE_BIN=/usr/sbin/service 
SLEEP_BIN=/bin/sleep
LOG_FILE="mysql_uptime.logs"

check_mysql_status() {
    mysql_status=$($SERVICE_BIN mysql status | grep -c -w "running")

    if [[ $mysql_status -eq 1 ]];then
        IS_ACTIVE=1
    else
        IS_ACTIVE=0
    fi
}

restart_mysql_service() {
    $SLEEP_BIN 2
    echo "Please wait, restarting mysql service..."
    $SERVICE_BIN mysql restart
    echo "Restart complete."
}

logging_it() {
    echo "MySQL was restarted at ${DATE}" >> $LOG_FILE
}

main() {
    check_mysql_status
    if [[ $IS_ACTIVE -eq 0 ]];then
        restart_mysql_service
        logging_it
    else
        echo "MySQL is OK"
    fi
}

main

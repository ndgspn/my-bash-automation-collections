#!/bin/bash
#nandang.id
#jamu ssh untuk server abah

isActive=0
email_addr="your_email@domain.xxx"

check_ssh_status() {
    sshStatus=$(service sshd status | grep -c -w "running")

    if [[ $sshStatus -eq 1 ]];then
        isActive=1
    else
        isActive=0
    fi
}

check_ssh_pid() {
    if [[ -f "/var/run/sshd.pid" ]];then
        isActive=1
    else
        isActive=0
    fi
}

stop_start_ssh() {
    service sshd stop
    sleep 2
    service sshd start
    echo "Still running up the service. Please wait..."
    sleep 5
}

send_email_up() {
    mail -s "ssh service recovery from $(hostname)" $email_addr <<EOF
	    ssh restarted successfully
EOF
}

send_email_failed() {
    mail -s "ssh service recovery failed from $(hostname)" $email_addr <<EOF
	    ssh restart failed!!!
EOF
}


main() {
    check_ssh_status
    check_ssh_pid
    if [[ $isActive -eq 0 ]];then
        echo "sshd services is down. Trying to recover the services..."
	stop_start_ssh
        check_ssh_status
        check_ssh_pid
        if [[ $isActive -eq 0 ]];then
            echo "sshd not recovered. Something may be wrong..."
	    send_email_failed
        else
            echo "sshd restarted sucessfully"
	    send_email_up
        fi
    else
        echo "ssh is Ok"
    fi

}

main

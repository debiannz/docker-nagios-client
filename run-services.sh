#!/bin/sh

shutdown_container()
{
    echo "Stopping container..."
    /sbin/service nrpe stop
    killall reloader.sh
    killall etcdctl
    killall tail
    /sbin/service rsyslog stop
    exit 0
}

trap shutdown_container SIGINT SIGTERM SIGHUP

#fix wrong pid location. 
#`/etc/init.d/nrpe stop' is looking for pid at /var/run/nrpe.pid,
# but default pid_file parameter in /etc/nagios/nrpe.cfg is pid_file=/var/run/nrpe/nrpe.pid
sed -i 's/pid_file=\/var\/run\/nrpe\/nrpe\.pid/pid_file=\/var\/run\/nrpe\.pid/' /etc/nagios/nrpe.cfg

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    /reloader.sh ${ETCDCTL_WATCH} &
fi

/sbin/service rsyslog start
/sbin/service nrpe start

tail -f /var/log/messages &

wait


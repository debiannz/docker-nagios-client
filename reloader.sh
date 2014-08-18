#!/bin/sh

ETCDCTL_WATCH=/services/nagios/reload
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

# first run
cp -f /conf/nagios/nrpe.cfg /etc/nagios/nrpe.cfg

while true ; do
    RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    
    if [ "${RESULT}" == "reload" ] ; then
	echo "Catched reload action. Reloading..."
	cp -f /conf/nagios/nrpe.cfg /etc/nagios/nrpe.cfg
	/sbin/service nrpe restart
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done

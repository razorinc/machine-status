#!/bin/bash

## mu.iface export iface
## mu.host export host
## mu.something export something


function cmdline_parser
{
    for arg in $(cat /proc/cmdline); do
	echo $arg | grep -q mu. ;     
	if [ $? == 0 ]; then
	    key=$(echo $arg | cut -d'=' -f1 | cut -d'.' -f2)
            val=$(echo $arg | cut -d= -f2);
	    declare ${key}=${val}
	fi;
    done
}

default_if=$(netstat -r |grep default|awk '{print $8}')
miface=${${iface}:-$default_if}
receiver=${host:-"http://192.168.100.1:9292"}
mac_address=$(ip link show ${miface}|tail -n1 | tr -s ' ' | sed -e 's/^\s//'|cut -d' ' -f2)
runlevel=$(runlevel|sed -e 's/ //g')

case $runlevel in
    N[2-5])
        action=start
        ;;
    [2-5]0)
        action=stop
        ;;
    [2-5]6)
        action=reboot
        ;;
    *)
        action=br0ken
        ;;
esac

if [ -n "$DEBUG" ]; then
    echo $action
    echo $runlevel
else
    curl -XPOST "${receiver}"/${mac_address}/${action}?runlevel=${runlevel}" >&2
fi

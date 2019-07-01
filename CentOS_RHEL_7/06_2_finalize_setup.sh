#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root ($ sudo -s)"
    exit
fi

. ./config.sh

HOSTNAME=`hostname`

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
    for addr in $(hostname --all-ip-addresses)
    do
        if [ "$node" = "$addr" ]; then
            sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$node/g" /etc/nova/nova.conf;
            echo "Set the proxyclient address of VNCServer ($node)";
            break;
        fi
    done
done

# dhcp

sed -i "s/#enable_isolated_metadata = false/enable_isolated_metadata = true/g" /etc/neutron/dhcp_agent.ini

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

#echo sed -i "s/#enable_isolated_metadata = false/enable_isolated_metadata = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "/enable_isolated_metadata=False/d" /etc/neutron/dhcp_agent.ini
#echo sed -i "s/#force_metadata = false/force_metadata = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "s/#enable_metadata_network = false/enable_metadata_network = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "/enable_metadata_network=False/d" /etc/neutron/dhcp_agent.ini

# metadata

#echo sed -i "s/#nova_metadata_host = 127.0.0.1/nova_metadata_host = `echo $CONTROLLER_NODE`/g" /etc/neutron/metadata_agent.ini
#echo sed -i "s/#nova_metadata_port = 8775/nova_metadata_port = 8775/g" /etc/neutron/metadata_agent.ini

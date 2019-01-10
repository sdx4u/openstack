#!/bin/bash

. ./config.sh

HOSTNAME=`hostname`

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	for addr in $(hostname --all-ip-addresses)
	do
		if [ "$node" = "$addr" ]; then
			sudo sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$node/g" /etc/nova/nova.conf;
			echo "Set the proxyclient address of VNCServer ($node)";
			break;
		fi
	done
done

echo "Please reboot the machine"

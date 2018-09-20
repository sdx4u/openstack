#!/bin/bash

. ./config.sh

HOSTNAME=`hostname`

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	read -p "Is $node your IP address (y/N)?" choice
	if [ "$choice" = "y" ]; then
		sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$node/g" /etc/nova/nova.conf;
		echo "Set the proxyclient address of VNCServer ($node)";
		break;
	fi
done

echo "Please reboot the machine"

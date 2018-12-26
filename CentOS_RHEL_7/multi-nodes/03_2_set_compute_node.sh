#!/bin/bash

. ./config.sh

# tunnel
vi /etc/sysconfig/network-scripts/ifcfg-$TUNNEL_INTERFACE

ifdown $TUNNEL_INTERFACE
ifup $TUNNEL_INTERFACE

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	util/push-key.sh 22 root@$node
done

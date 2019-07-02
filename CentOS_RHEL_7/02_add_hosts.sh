#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root ($ sudo -s)"
    exit
fi

. ./config.sh

if [ -f /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE ]; then
    mv /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE.bak

    cp config/ifcfg-br-ex /etc/sysconfig/network-scripts/ifcfg-br-ex

    sed -i "s/IP_ADDRESS/$EXTERNAL_IP_ADDRESS/g" /etc/sysconfig/network-scripts/ifcfg-br-ex
    sed -i "s/GW_ADDRESS/$EXTERNAL_GW_ADDRESS/g" /etc/sysconfig/network-scripts/ifcfg-br-ex

    cp config/ifcfg-bridge /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE

    sed -i "s/INTERFACE/$EXTERNAL_INTERFACE/g" /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE
fi

util/push-key.sh 22 root@$CONTROLLER_NODE

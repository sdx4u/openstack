#!/bin/bash

. ./config.sh

sudo mv /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE \
        /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE.bak

sudo cp config/ifcfg-br-ex /etc/sysconfig/network-scripts/ifcfg-br-ex

sudo sed -i "s/IP_ADDRESS/$EXTERNAL_IP_ADDRESS/g" \
              /etc/sysconfig/network-scripts/ifcfg-br-ex
sudo sed -i "s/GW_ADDRESS/$EXTERNAL_GW_ADDRESS/g" \
              /etc/sysconfig/network-scripts/ifcfg-br-ex

sudo cp config/ifcfg-bridge /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE

sudo sed -i "s/INTERFACE/$EXTERNAL_INTERFACE/g" \
              /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_INTERFACE

util/push-key.sh 22 root@$CONTROLLER_NODE

echo "Please reboot the machine"

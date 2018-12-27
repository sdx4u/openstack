#!/bin/bash

. ./config.sh

if [ "$OPENSTACK" = "ocata" ]; then
        if [ "$ML2_TYPE" = "vlan" ]; then
                cp config/ocata/answer-vlan.cfg answer.cfg
        elif [ "$ML2_TYPE" = "vxlan" ]; then
                cp config/ocata/answer-vxlan.cfg answer.cfg
        else
                exit
        fi
elif [ "$OPENSTACK" = "pike" ]; then
        if [ "$ML2_TYPE" = "vlan" ]; then
                cp config/queens/answer-vlan.cfg answer.cfg
        elif [ "$ML2_TYPE" = "vxlan" ]; then
                cp config/queens/answer-vxlan.cfg answer.cfg
        else
                exit
        fi
elif [ "$OPENSTACK" = "queens" ]; then
        if [ "$ML2_TYPE" = "vlan" ]; then
                cp config/queens/answer-vlan.cfg answer.cfg
        elif [ "$ML2_TYPE" = "vxlan" ]; then
                cp config/queens/answer-vxlan.cfg answer.cfg
        else
                exit
        fi
else
        exit
fi

sed -i "s/CONTROLLER_NODE/$CONTROLLER_NODE/g" answer.cfg
sed -i "s/EXTERNAL_INTERFACE/$EXTERNAL_INTERFACE/g" answer.cfg
sed -i "s/EXTERNAL_NETWORK/$EXTERNAL_NETWORK.0/g" answer.cfg

# install openstack
sudo packstack --answer-file=answer.cfg

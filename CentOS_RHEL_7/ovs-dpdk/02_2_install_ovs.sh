#!/bin/bash

sudo yum install -y libibverbs

sudo systemctl start openvswitch
sudo systemctl enable openvswitch

sleep 5

sudo ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
sudo systemctl restart openvswitch

echo "Please reboot the machine"

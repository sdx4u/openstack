#!/bin/bash

# install EPEL

yum install epel-release

# install Open vSwitch

yum install openvswitch bridge-utils

# enable Open vSwitch service

systemctl enable openvswitch
systemctl start openvswitch

# create an OVS bridge

echo "Configure an OVS bridge (see network-scripts/*)"

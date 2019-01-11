#!/bin/bash

EX_INT=enp216s0f0
VL_INT=enp59s0f0

systemctl stop dpdk

sed -i "s/#dpdk-devbind/dpdk-devbind/g" /usr/local/bin/boot-dpdk.sh
sed -i "s/#dpdk-devbind/dpdk-devbind/g" /usr/local/bin/kill-dpdk.sh

ovs-vsctl del-port $EX_INT
ovs-vsctl del-port $VL_INT

sed -i "s/ONBOOT=yes/ONBOOT=no/g" /etc/sysconfig/network-scripts/ifcfg-$EX_INT
sed -i "s/ONBOOT=yes/ONBOOT=no/g" /etc/sysconfig/network-scripts/ifcfg-$VL_INT

sed -i "s/#datapath_type = system/datapath_type = netdev/g" /etc/neutron/plugins/ml2/openvswitch_agent.ini
sed -i "s/#vhostuser_socket_dir = \/var\/run\/openvswitch/vhostuser_socket_dir = \/tmp/g" /etc/neutron/plugins/ml2/openvswitch_agent.ini

ovs-vsctl set bridge br-int datapath_type=netdev
ovs-vsctl set bridge br-vlan datapath_type=netdev
ovs-vsctl set bridge br-ex datapath_type=netdev

ovs-vsctl show

echo "Please reboot the system"

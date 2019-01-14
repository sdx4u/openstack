#!/bin/bash

sed -i "s/#datapath_type = system/datapath_type = netdev/g" /etc/neutron/plugins/ml2/openvswitch_agent.ini
sed -i "s/#vhostuser_socket_dir = \/var\/run\/openvswitch/vhostuser_socket_dir = \/tmp/g" \
       /etc/neutron/plugins/ml2/openvswitch_agent.ini

ovs-vsctl set bridge br-int datapath_type=netdev
ovs-vsctl set bridge br-vlan datapath_type=netdev
ovs-vsctl set bridge br-ex datapath_type=netdev

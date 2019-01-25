#!/bin/bash

. ./config.sh

HOSTNAME=`hostname`

sudo sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$CONTROLLER_NODE/g" /etc/nova/nova.conf

. ~/keystonerc_admin

# image

mkdir ~/images; cd ~/images
curl -LO http://www.sdx4u.net/downloads/xenial-server-cloudimg-amd64-disk1_ubuntu.img

openstack image create --public \
  --disk-format qcow2 --container-format bare \
  --file xenial-server-cloudimg-amd64-disk1_ubuntu.img ubuntu_16_04

# public network

openstack network create --external \
  --provider-physical-network extnet \
  --provider-network-type flat public_network

openstack subnet create --network public_network \
  --allocation-pool start=$IP_POOL_START,end=$IP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $EXTERNAL_GW_ADDRESS \
  --subnet-range $EXTERNAL_NETWORK.0/24 public_subnet

# private network

if [ "$ML2_TYPE" = "vlan" ]; then
	openstack network create \
	  --provider-physical-network intnet \
	  --provider-network-type flat private_network
elif [ "$ML2_TYPE" = "vxlan" ]; then
	openstack network create private_network
else
	exit
fi

openstack subnet create --network private_network \
  --allocation-pool start=$VIP_POOL_START,end=$VIP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $INTERNAL_GW_ADDRESS \
  --subnet-range $INTERNAL_NETWORK.0/24 private_subnet

openstack router create private_router
neutron router-interface-add private_router private_subnet
neutron router-gateway-set private_router public_network

# vlan network

if [ "$ML2_TYPE" = "vlan" ]; then
	openstack network create \
	  --provider-physical-network intnet \
	  --provider-network-type vlan vlan_network
elif [ "$ML2_TYPE" = "vxlan" ]; then
	openstack network create vlan_network
else
	exit
fi

openstack subnet create --network vlan_network \
  --allocation-pool start=$VIP_POOL_START,end=$VIP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $INTERNAL_GW_ADDRESS \
  --subnet-range $INTERNAL_NETWORK.0/24 vlan_subnet

openstack router create vlan_router
neutron router-interface-add vlan_router vlan_subnet
neutron router-gateway-set vlan_router public_network

# flavors

#openstack flavor create --vcpus 4 --ram 8192 --disk 20 --id auto ubuntu_huge
#openstack flavor set ubuntu_huge --property hw:mem_page_size=large
#openstack flavor set ubuntu_huge --property aggregate_instance_extra_specs:pinned=false

openstack flavor create --vcpus 4 --ram 8192 --disk 20 --id auto ubuntu_pinned
openstack flavor set ubuntu_pinned --property hw:cpu_policy=dedicated
openstack flavor set ubuntu_pinned --property aggregate_instance_extra_specs:pinned=true

openstack flavor create --vcpus 4 --ram 8192 --disk 20 --id auto ubuntu_pinned
openstack flavor set ubuntu_huge_pinned --property hw:mem_page_size=large
openstack flavor set ubuntu_huge_pinned --property hw:cpu_policy=dedicated
openstack flavor set ubuntu_huge_pinned --property aggregate_instance_extra_specs:pinned=true

echo "Please reboot the machine"

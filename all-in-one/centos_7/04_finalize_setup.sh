#!/bin/bash

. ./config.sh

HOSTNAME=`hostname`

sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$CONTROLLER_NODE/g" /etc/nova/nova.conf

. ~/keystonerc_admin

openstack network create --external \
  --provider-physical-network extnet \
  --provider-network-type flat public_network

openstack subnet create --network public_network \
  --allocation-pool start=$IP_POOL_START,end=$IP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $IP_GW_ADDRESS \
  --subnet-range $EXTERNAL_NETWORK/24 public_subnet

mkdir ~/images
cd ~/images

curl -LO http://www.sdx4u.net/downloads/xenial-server-cloudimg-amd64-disk1_ubuntu.img

openstack image create --public \
  --disk-format qcow2 --container-format bare --min-disk 10 \
  --file xenial-server-cloudimg-amd64-disk1_ubuntu.img ubuntu_16_04

if [ "$ML2_TYPE" = "vlan" ];
then
	openstack network create \
	  --provider-physical-network intnet \
	  --provider-network-type flat private_network
elif [ "$ML2_TYPE" = "vxlan" ];
then
	openstack network create private_network
else
	exit
fi

openstack subnet create --network private_network \
  --allocation-pool start=$VIP_POOL_START,end=$VIP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $VIP_GW_ADDRESS \
  --subnet-range $INTERNAL_NETWORK/24 private_subnet

openstack router create private_router
neutron router-interface-add private_router private_subnet
neutron router-gateway-set private_router public_network

openstack flavor create --vcpus 1 --ram 2048 --disk 10 --id auto ubuntu
openstack flavor create --vcpus 1 --ram 2048 --disk 10 --id auto ubuntu_huge
openstack flavor set ubuntu_huge --property hw:mem_page_size=large

echo "Please reboot the machine"

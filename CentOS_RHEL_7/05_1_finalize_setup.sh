#!/bin/bash

. ./config.sh

HOSTNAME=`hostname`

sudo sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$CONTROLLER_NODE/g" /etc/nova/nova.conf

. ~/keystonerc_admin

# image

mkdir ~/images; cd ~/images

curl -LO http://www.sdx4u.net/downloads/trusty-server-cloudimg-amd64.img

openstack image create --public \
  --disk-format qcow2 --container-format bare \
  --file trusty-server-cloudimg-amd64.img ubuntu_14_04

curl -LO http://www.sdx4u.net/downloads/xenial-server-cloudimg-amd64.img

openstack image create --public \
  --disk-format qcow2 --container-format bare \
  --file xenial-server-cloudimg-amd64.img ubuntu_16_04

curl -LO http://www.sdx4u.net/downloads/bionic-server-cloudimg-amd64.img

openstack image create --public \
  --disk-format qcow2 --container-format bare \
  --file bionic-server-cloudimg-amd64.img ubuntu_18_04

# public network

openstack network create --external \
  --provider-physical-network extnet \
  --provider-network-type flat public_network

openstack subnet create --network public_network \
  --allocation-pool start=$IP_POOL_START,end=$IP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $EXTERNAL_GW_ADDRESS \
  --subnet-range $EXTERNAL_NETWORK.0/24 public_subnet

# private network

openstack network create private_network

openstack subnet create --network private_network \
  --allocation-pool start=$VIP_POOL_START,end=$VIP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $INTERNAL_GW_ADDRESS \
  --subnet-range $INTERNAL_NETWORK.0/24 private_subnet

openstack router create private_router
neutron router-interface-add private_router private_subnet
neutron router-gateway-set private_router public_network

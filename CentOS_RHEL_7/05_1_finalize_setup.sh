#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root"
    exit
fi

. ./config.sh

HOSTNAME=`hostname`

sed -i "s/vncserver_proxyclient_address=$HOSTNAME/vncserver_proxyclient_address=$CONTROLLER_NODE/g" /etc/nova/nova.conf

# dhcp

#echo sed -i "s/#enable_isolated_metadata = false/enable_isolated_metadata = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "/enable_isolated_metadata=False/d" /etc/neutron/dhcp_agent.ini
#echo sed -i "s/#force_metadata = false/force_metadata = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "s/#enable_metadata_network = false/enable_metadata_network = true/g" /etc/neutron/dhcp_agent.ini
#echo sed -i "/enable_metadata_network=False/d" /etc/neutron/dhcp_agent.ini

# metadata

#echo sed -i "s/#nova_metadata_host = 127.0.0.1/nova_metadata_host = `echo $CONTROLLER_NODE`/g" /etc/neutron/metadata_agent.ini
#echo sed -i "s/#nova_metadata_port = 8775/nova_metadata_port = 8775/g" /etc/neutron/metadata_agent.ini

# set admin permission

cd
. ~/keystonerc_admin

# image

yum install -y wget

mkdir ~/images; cd ~/images

wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img

openstack image create --public \
  --disk-format qcow2 --container-format bare \
  --file cirros-0.3.5-x86_64-disk.img cirros_0_3_5

if [ ! -z $1 ]; then
    wget http://www.sdx4u.net/downloads/trusty-server-cloudimg-amd64.img

    openstack image create --public \
      --disk-format qcow2 --container-format bare \
      --file trusty-server-cloudimg-amd64.img ubuntu_14_04

    wget http://www.sdx4u.net/downloads/xenial-server-cloudimg-amd64.img

    openstack image create --public \
      --disk-format qcow2 --container-format bare \
      --file xenial-server-cloudimg-amd64.img ubuntu_16_04

    wget http://www.sdx4u.net/downloads/bionic-server-cloudimg-amd64.img

    openstack image create --public \
      --disk-format qcow2 --container-format bare \
      --file bionic-server-cloudimg-amd64.img ubuntu_18_04

    wget http://www.sdx4u.net/downloads/CentOS-7-x86_64-GenericCloud-1511.qcow2

    openstack image create --public \
      --disk-format qcow2 --container-format bare \
      --file CentOS-7-x86_64-GenericCloud-1511.qcow2 CentOS_7_2

    wget http://www.sdx4u.net/downloads/CentOS-7-x86_64-GenericCloud-1905.qcow2

    openstack image create --public \
      --disk-format qcow2 --container-format bare \
      --file CentOS-7-x86_64-GenericCloud-1905.qcow2 CentOS_7_6
fi

# public network

openstack network create --external \
  --provider-physical-network extnet \
  --provider-network-type flat public_network

openstack subnet create --network public_network \
  --allocation-pool start=$IP_POOL_START,end=$IP_POOL_END \
  --dns-nameserver $DNS_NAMESERVER --gateway $EXTERNAL_GW_ADDRESS \
  --subnet-range $EXTERNAL_NETWORK.0/24 public_subnet

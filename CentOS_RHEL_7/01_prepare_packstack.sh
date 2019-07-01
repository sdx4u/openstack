#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root ($ sudo -s)"
    exit
fi

vi ./config.sh

. ./config.sh

# prerequisites
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# add RDO repository
OS=`grep 'ID="rhel"' /etc/os-release | cut -d '"' -f2 | cut -d '"' -f1`
if [ "$OS" == "rhel" ]; then
    yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
fi

# update current packages
yum update -y

# add openstack repo
if [ "$OPENSTACK" = "ocata" ]; then
    yum install -y centos-release-openstack-ocata
elif [ "$OPENSTACK" = "pike" ]; then
    yum install -y centos-release-openstack-pike
elif [ "$OPENSTACK" = "queens" ]; then
    yum install -y centos-release-openstack-queens
else
    exit
fi

# install packstack
yum install -y openstack-packstack

# install openvswitch
yum install -y openvswitch

# run openvswitch
systemctl enable openvswitch
systemctl start openvswitch

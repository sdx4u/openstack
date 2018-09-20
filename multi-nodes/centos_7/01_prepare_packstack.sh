#!/bin/bash

. ./config.sh

# prerequisites
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# add openstack repo
if [ "$OPENSTACK" = "ocata" ];
then
	yum install -y centos-release-openstack-ocata
elif [ "$OPENSTACK" = "pike" ];
then
	yum install -y centos-release-openstack-pike
elif [ "$OPENSTACK" = "queens" ];
then
	yum install -y centos-release-openstack-queens
else
	exit
fi

# packStack installer
yum install -y openstack-packstack

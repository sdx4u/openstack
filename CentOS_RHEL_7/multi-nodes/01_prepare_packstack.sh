#!/bin/bash

. ./config.sh

# prerequisites
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

#!/bin/bash

. ./config.sh

# prerequisites
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

# add RDO repository
OS=`grep 'ID="rhel"' /etc/os-release | cut -d '"' -f2 | cut -d '"' -f1`
if [ "$OS" == "rhel" ]; then
	sudo yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
fi

# update current packages
sudo yum update -y

# add openstack repo
if [ "$OPENSTACK" = "ocata" ]; then
        sudo yum install -y centos-release-openstack-ocata
elif [ "$OPENSTACK" = "pike" ]; then
        sudo yum install -y centos-release-openstack-pike
elif [ "$OPENSTACK" = "queens" ]; then
        sudo yum install -y centos-release-openstack-queens
else
        exit
fi

# install packstack
sudo yum install -y openstack-packstack

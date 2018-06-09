#!/bin/bash

cd ~
. ./keystonerc_admin

yum install -y wget
wget http://www.sdx4u.net/downloads/trusty-server-cloudimg-amd64-disk1.img
wget http://www.sdx4u.net/downloads/xenial-server-cloudimg-amd64-disk1.img

openstack image create "Ubuntu14.04" --file trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --public
openstack image create "Ubuntu16.04" --file xenial-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --public

cp httpd/conf.d/15-horizon_vhost.conf /etc/httpd/conf.d/15-horizon_vhost.conf
cp neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini

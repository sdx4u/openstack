#!/bin/bash

vi config.sh

. ./config.sh

sudo vi /etc/hosts

sudo apt install -y python-dev libmysqlclient-dev libffi-dev libssl-dev

sudo apt install -y software-properties-common
sudo add-apt-repository cloud-archive:newton
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y python-openstackclient

sudo apt install -y rabbitmq-server
sudo rabbitmqctl add_user openstack $RABBITMQ_PASSWD
sudo rabbitmqctl set_permissions openstack ".*" ".*" ".*"

sudo apt update
sudo apt install -y chrony

sudo mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak
sudo cp chrony.conf /etc/chrony/chrony.conf
sudo sed -i 's/NTP_NETWORK/'$NTP_NETWORK'\/'$NTP_CIDR'/g' /etc/chrony/chrony.conf
sudo service chrony restart

sudo apt install -y memcached python-memcache

sudo mv /etc/memcached.conf /etc/memcached.conf.bak
sudo cp memcached.conf /etc/memcached.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/memcached.conf
sudo service memcached restart

sudo apt install -y mariadb-server python-pymysql

sudo cp 99-openstack.cnf /etc/mysql/mariadb.conf.d/99-openstack.cnf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/mysql/mariadb.conf.d/99-openstack.cnf
sudo service mysql restart

sudo mysql_secure_installation

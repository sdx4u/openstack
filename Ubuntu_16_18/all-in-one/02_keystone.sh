#!/bin/bash

. ./config.sh

cp keystone.sql keystone.query
sed -i 's/KEYSTONE_PASSWD/'$KEYSTONE_PASSWD'/g' keystone.query
sudo mysql -u root -p$ROOT_PASSWD < keystone.query
rm keystone.query

sudo apt install -y keystone

sudo cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.bak
sudo cp keystone.conf /etc/keystone/keystone.conf
sudo sed -i 's/KEYSTONE_PASSWD/'$KEYSTONE_PASSWD'/g' /etc/keystone/keystone.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/keystone/keystone.conf

sudo -- su -s /bin/sh -c "keystone-manage db_sync" keystone

sudo keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
sudo keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

sudo keystone-manage bootstrap --bootstrap-password $ADMIN_PASSWD --bootstrap-admin-url http://$CONTROLLER_IP_ADDRESS:35357/v3/ --bootstrap-internal-url http://$CONTROLLER_IP_ADDRESS:35357/v3/ --bootstrap-public-url http://$CONTROLLER_IP_ADDRESS:5000/v3/ --bootstrap-region-id RegionOne

sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
sudo cp apache2.conf /etc/apache2/apache2.conf

sudo service apache2 restart

sudo rm -f /var/lib/keystone/keystone.db

cp admin.bashrc ~

sed -i 's/ADMIN_PASSWD/'$ADMIN_PASSWD'/g' ~/admin.bashrc
sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' ~/admin.bashrc

. ~/admin.bashrc

openstack project create --domain default --description "Service Project" service

openstack role create user
openstack role delete _member_

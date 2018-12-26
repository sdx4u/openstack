#!/bin/bash

. ./config.sh

cp glance.sql glance.query
sed -i 's/GLANCE_PASSWD/'$GLANCE_PASSWD'/g' glance.query
sudo mysql -u root -p$ROOT_PASSWD < glance.query
rm glance.query

. ~/admin.bashrc

openstack service create --name glance --description "OpenStack Image" image

echo "Type the password of a glance account: "
openstack user create --domain default --password-prompt glance

openstack role add --project service --user glance admin

openstack endpoint create --region RegionOne image public http://$CONTROLLER_IP_ADDRESS:9292
openstack endpoint create --region RegionOne image internal http://$CONTROLLER_IP_ADDRESS:9292
openstack endpoint create --region RegionOne image admin http://$CONTROLLER_IP_ADDRESS:9292

sudo apt-get install -y glance

sudo cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.bak
sudo cp glance-api.conf /etc/glance/glance-api.conf
sudo sed -i 's/GLANCE_PASSWD/'$GLANCE_PASSWD'/g' /etc/glance/glance-api.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/glance/glance-api.conf

sudo cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.bak
sudo cp glance-registry.conf /etc/glance/glance-registry.conf
sudo sed -i 's/GLANCE_PASSWD/'$GLANCE_PASSWD'/g' /etc/glance/glance-registry.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/glance/glance-registry.conf

sudo -- su -s /bin/sh -c "glance-manage db_sync" glance

sudo service glance-registry restart
sudo service glance-api restart

cd ~

wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

openstack image create "cirros" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public

openstack image list

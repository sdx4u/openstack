#!/bin/bash

. ./config.sh

cp nova.sql nova.query
sed -i 's/NOVA_PASSWD/'$NOVA_PASSWD'/g' nova.query
sudo mysql -u root -p$ROOT_PASSWD < nova.query
rm nova.query

. ~/admin.bashrc

openstack service create --name nova --description "OpenStack Compute" compute

echo "Type the password of a nova account: "
openstack user create --domain default --password-prompt nova

openstack role add --project service --user nova admin

openstack endpoint create --region RegionOne compute public http://$CONTROLLER_IP_ADDRESS:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://$CONTROLLER_IP_ADDRESS:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://$CONTROLLER_IP_ADDRESS:8774/v2.1/%\(tenant_id\)s

sudo apt-get install -y nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-compute

sudo cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
sudo cp nova.conf /etc/nova/nova.conf
sudo sed -i 's/RABBITMQ_PASSWD/'$RABBITMQ_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/NOVA_PASSWD/'$NOVA_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/NEUTRON_PASSWD/'$NEUTRON_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/METADATA_SECRET/'$METADATA_SECRET'/g' /etc/nova/nova.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/nova/nova.conf
sudo sed -i 's/LOCAL_IP_ADDRESS/'$LOCAL_IP_ADDRESS'/g' /etc/nova/nova.conf

sudo -- su -s /bin/sh -c "nova-manage api_db sync" nova
sudo -- su -s /bin/sh -c "nova-manage db sync" nova

sudo service nova-api restart
sudo service nova-consoleauth restart
sudo service nova-scheduler restart
sudo service nova-conductor restart
sudo service nova-novncproxy restart

sleep 5

. ~/admin.bashrc

openstack flavor create --ram 512 --disk 1 --vcpus 1 m1.tiny
openstack flavor create --ram 2048 --disk 20 --vcpus 1 m1.small
openstack flavor create --ram 4096 --disk 40 --vcpus 2 m1.medium
openstack flavor create --ram 8192 --disk 80 --vcpus 4 m1.large
openstack flavor create --ram 16384 --disk 160 --vcpus 8 m1.xlarge

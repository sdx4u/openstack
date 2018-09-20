#!/bin/bash

. ./config.sh

cp neutron.sql neutron.query
sed -i 's/NEUTRON_PASSWD/'$NEUTRON_PASSWD'/g' neutron.query
sudo mysql -u root -p$ROOT_PASSWD < neutron.query
rm neutron.query

. ~/admin.bashrc

openstack service create --name neutron --description "OpenStack Networking" network

echo "Type the password of a neutron account: "
openstack user create --domain default --password-prompt neutron

openstack role add --project service --user neutron admin

openstack endpoint create --region RegionOne network public http://$CONTROLLER_IP_ADDRESS:9696
openstack endpoint create --region RegionOne network internal http://$CONTROLLER_IP_ADDRESS:9696
openstack endpoint create --region RegionOne network admin http://$CONTROLLER_IP_ADDRESS:9696

sudo apt-get install -y neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent dnsmasq

sudo cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak
sudo cp neutron.conf /etc/neutron/neutron.conf
sudo sed -i 's/RABBITMQ_PASSWD/'$RABBITMQ_PASSWD'/g' /etc/neutron/neutron.conf
sudo sed -i 's/NEUTRON_PASSWD/'$NEUTRON_PASSWD'/g' /etc/neutron/neutron.conf
sudo sed -i 's/NOVA_PASSWD/'$NOVA_PASSWD'/g' /etc/neutron/neutron.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/neutron/neutron.conf

sudo cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.bak
sudo cp ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini

sudo cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak
sudo cp linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i 's/LOCAL_IP_ADDRESS/'$LOCAL_IP_ADDRESS'/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i 's/PROVIDER_INTERFACE/'$PROVIDER_INTERFACE'/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini

sudo cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.bak
sudo cp l3_agent.ini /etc/neutron/l3_agent.ini

sudo cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.bak
sudo cp dhcp_agent.ini /etc/neutron/dhcp_agent.ini

sudo cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.bak
sudo cp metadata_agent.ini /etc/neutron/metadata_agent.ini
sudo sed -i 's/METADATA_SECRET/'$METADATA_SECRET'/g' /etc/neutron/metadata_agent.ini
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/neutron/metadata_agent.ini

sudo -- su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

sudo service nova-api restart

sudo service neutron-server restart
sudo service neutron-linuxbridge-agent restart
sudo service neutron-dhcp-agent restart
sudo service neutron-metadata-agent restart
sudo service neutron-l3-agent restart

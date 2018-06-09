#!/bin/bash

. ./config.sh

sudo apt-get install -y neutron-linuxbridge-agent

sudo cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.bak
sudo cp neutron.conf /etc/neutron/neutron.conf
sudo sed -i 's/RABBITMQ_PASSWD/'$RABBITMQ_PASSWD'/g' /etc/neutron/neutron.conf
sudo sed -i 's/NEUTRON_PASSWD/'$NEUTRON_PASSWD'/g' /etc/neutron/neutron.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/neutron/neutron.conf

sudo cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak
sudo cp linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i 's/LOCAL_IP_ADDRESS/'$LOCAL_IP_ADDRESS'/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini
sudo sed -i 's/PROVIDER_INTERFACE/'$PROVIDER_INTERFACE'/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini

sudo service nova-compute restart
sudo service neutron-linuxbridge-agent restart

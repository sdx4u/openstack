#!/bin/bash

. ./config.sh

sudo apt install -y nova-compute

sudo cp /etc/nova/nova.conf /etc/nova/nova.conf.bak
sudo cp nova.conf /etc/nova/nova.conf
sudo sed -i 's/RABBITMQ_PASSWD/'$RABBITMQ_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/NOVA_PASSWD/'$NOVA_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/NEUTRON_PASSWD/'$NEUTRON_PASSWD'/g' /etc/nova/nova.conf
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/nova/nova.conf
sudo sed -i 's/LOCAL_IP_ADDRESS/'$LOCAL_IP_ADDRESS'/g' /etc/nova/nova.conf

sudo service nova-compute restart

#!/bin/bash

. ./config.sh

sudo apt-get install -y openstack-dashboard

sudo cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py.bak
sudo cp local_settings.py /etc/openstack-dashboard/local_settings.py
sudo sed -i 's/CONTROLLER_IP_ADDRESS/'$CONTROLLER_IP_ADDRESS'/g' /etc/openstack-dashboard/local_settings.py

sudo service apache2 reload

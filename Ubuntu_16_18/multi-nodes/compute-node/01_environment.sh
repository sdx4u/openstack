#!/bin/bash

vi config.sh

. ./config.sh

sudo vi /etc/hosts

sudo apt install -y python-dev libmysqlclient-dev libffi-dev libssl-dev

sudo apt-get install -y software-properties-common
sudo add-apt-repository cloud-archive:newton
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y python-openstackclient

sudo apt update
sudo apt install -y chrony

sudo mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak
sudo cp chrony.conf /etc/chrony/chrony.conf
sudo sed -i 's/NTP_NETWORK/'$CONTROLLER_IP_ADDRESS'/g' /etc/chrony/chrony.conf
sudo service chrony restart

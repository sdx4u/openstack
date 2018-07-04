#!/bin/bash

. ./config.sh

. ~/admin.bashrc

neutron net-create --shared --provider:physical_network provider --provider:network_type flat extnet
neutron subnet-create --name extnet --allocation-pool start=$START_IP,end=$END_IP --dns-nameserver $DNS_SERVER --gateway $GATEWAY extnet $PROVIDER_NETWORK

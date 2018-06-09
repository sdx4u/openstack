#!/bin/bash

. ./config.sh

. ~/admin.bashrc

neutron net-create --shared --provider:physical_network provider --provider:network_type flat provider
neutron subnet-create --name provider --allocation-pool start=$START_IP,end=$END_IP --dns-nameserver $DNS_SERVER --gateway $GATEWAY provider $PROVIDER_NETWORK

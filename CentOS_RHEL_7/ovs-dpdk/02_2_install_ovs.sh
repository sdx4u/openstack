#!/bin/bash

if [ "$1" = "2.6" ];
then
	mkdir ~/build
	cp ovs/openvswitch-2.6.3.tar.gz ~/build && cd ~/build

	tar xvfz openvswitch-2.6.3.tar.gz
	cd openvswitch-2.6.3

	./boot.sh
	./configure --with-dpdk=$DPDK_BUILD

	make
	make install

	echo "Please reboot the machine"
elif [ "$1" = "2.8" ];
then
        mkdir ~/build
        cp ovs/openvswitch-2.8.4.tar.gz ~/build && cd ~/build

        tar xvfz openvswitch-2.8.4.tar.gz
        cd openvswitch-2.8.4

        ./boot.sh
	./configure --with-dpdk=$DPDK_BUILD

	make
	make install

	echo "Please reboot the machine"
elif [ "$1" = "2.9" ];
then
        mkdir ~/build
        cp ovs/openvswitch-2.9.0.tar.gz ~/build && cd ~/build

        tar xvfz openvswitch-2.9.0.tar.gz
        cd openvswitch-2.9.0

        ./boot.sh
	./configure --with-dpdk=$DPDK_BUILD

	make
	make install

	echo "Please reboot the machine"
else
	echo "$0 [ 2.6 | 2.8 | 2.9 ]"
fi

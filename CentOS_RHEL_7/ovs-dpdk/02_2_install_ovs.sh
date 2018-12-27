#!/bin/bash

if [ "$1" = "2.6" ];
then
	mkdir ~/build
	cp ovs/* ~/build && cd ~/build

	yum install -y libcap libcap-devel libcap-ng-devel
	#yum install -y openvswitch-2.6.3-1.el7.x86_64.rpm

	systemctl start openvswitch
	systemctl enable openvswitch

	sleep 5

	ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
	systemctl restart openvswitch

	echo "Please reboot the machine"
elif [ "$1" = "2.8" ];
then
        mkdir ~/build
        cp ovs/* ~/build && cd ~/build

        yum install -y libcap libcap-devel libcap-ng-devel
        #yum install -y openvswitch-2.8.4-1.el7.centos.x86_64.rpm

        systemctl start openvswitch
        systemctl enable openvswitch

        sleep 5

        ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
        systemctl restart openvswitch

        echo "Please reboot the machine"
else
	echo "$0 [ 2.6 | 2.8 ]"
fi

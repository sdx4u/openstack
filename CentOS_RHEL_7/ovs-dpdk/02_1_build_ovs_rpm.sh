#!/bin/bash

CURR=`pwd`

if [ "$1" = "2.6" ];
then
	mkdir ~/build
	cp ovs/* ~/build && cd ~/build

	sudo yum install -y rpm-build yum-utils \
	            autoconf automake libtool \
	            systemd-units openssl openssl-devel \
	            python tkinter python-twisted-core python-zope-interface python-six \
	            desktop-file-utils \
	            groff graphviz \
	            procps-ng \
	            checkpolicy selinux-policy-devel \
	            libcap libcap-ng-devel \
	            numactl-devel libpcap-devel

	tar xvfz openvswitch-2.6.3.tar.gz
	cd openvswitch-2.6.3

	./boot.sh
	CFLAGS='-march=native' ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-dpdk=$DPDK_BUILD
	sudo make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"
elif [ "$1" = "2.8" ];
then
        mkdir ~/build
        cp ovs/* ~/build && cd ~/build

        sudo yum install -y rpm-build yum-utils \
                    autoconf automake libtool \
                    systemd-units openssl openssl-devel \
                    python tkinter python-twisted-core python-zope-interface python-six \
                    desktop-file-utils \
                    groff graphviz \
                    procps-ng \
                    checkpolicy selinux-policy-devel \
                    libcap libcap-ng-devel \
                    numactl-devel libpcap-devel

        tar xvfz openvswitch-2.8.4.tar.gz
        cd openvswitch-2.8.4

	sed -i "s/BuildRequires: dpdk-devel/#BuildRequires: dpdk-devel/g" rhel/openvswitch-fedora.spec

        ./boot.sh
        CFLAGS='-march=native' ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-dpdk=$DPDK_BUILD
        sudo make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"
else
	echo "$0 [ 2.6 | 2.8 ]"
fi

#!/bin/bash

CURR=`pwd`

OS=`grep 'ID="rhel"' /etc/os-release | cut -d '"' -f2 | cut -d '"' -f1`
if [ "$OS" == "rhel" ]; then
	sudo subscription-manager repos --enable=rhel-7-server-extras-rpms
	sudo subscription-manager repos --enable=rhel-7-server-optional-rpms
fi

if [ "$1" = "2.6" ];
then
	sudo yum install -y ovs_deps/*

	mkdir ~/build
	cp ovs/openvswitch-2.6.3.tar.gz ~/build && cd ~/build

	sudo yum install -y rpm-build yum-utils autoconf automake libtool \
	            systemd-units openssl openssl-devel python-devel \
	            python tkinter python-twisted-core python-zope-interface python-six \
	            desktop-file-utils groff graphviz procps-ng \
	            checkpolicy selinux-policy-devel \
	            libcap libcap-ng-devel numactl-devel libpcap-devel

	tar xvfz openvswitch-2.6.3.tar.gz
	cd openvswitch-2.6.3

	./boot.sh
	CFLAGS='-march=native' ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-dpdk=$DPDK_BUILD
	sudo make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"

	cd ~/build/openvswitch-2.6.3/rpm/rpmbuild/RPMS/x86_64
	sudo yum install -y openvswitch-2.6.3*.rpm
elif [ "$1" = "2.8" ];
then
	sudo yum install -y ovs_deps/*

        mkdir ~/build
        cp ovs/openvswitch-2.8.4.tar.gz ~/build && cd ~/build

        sudo yum install -y rpm-build yum-utils autoconf automake libtool \
                    systemd-units openssl openssl-devel python-devel \
                    python tkinter python-twisted-core python-zope-interface python-six \
                    desktop-file-utils groff graphviz procps-ng \
                    checkpolicy selinux-policy-devel \
                    libcap libcap-ng-devel numactl-devel libpcap-devel

        tar xvfz openvswitch-2.8.4.tar.gz
        cd openvswitch-2.8.4

	sed -i "s/BuildRequires: dpdk-devel/#BuildRequires: dpdk-devel/g" rhel/openvswitch-fedora.spec

        ./boot.sh
        CFLAGS='-march=native' ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-dpdk=$DPDK_BUILD
        sudo make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"

	cd ~/build/openvswitch-2.8.4/rpm/rpmbuild/RPMS/x86_64
	sudo yum install -y openvswitch-2.8.4*.rpm
elif [ "$1" = "2.9" ];
then
	sudo yum install -y ovs_deps/*

        mkdir ~/build
        cp ovs/openvswitch-2.9.0.tar.gz ~/build && cd ~/build

        sudo yum install -y rpm-build yum-utils autoconf automake libtool \
                    systemd-units openssl openssl-devel python-devel \
                    python tkinter python-twisted-core python-zope-interface python-six \
                    desktop-file-utils groff graphviz procps-ng \
                    checkpolicy selinux-policy-devel \
                    libcap libcap-ng-devel numactl-devel libpcap-devel

        tar xvfz openvswitch-2.9.0.tar.gz
        cd openvswitch-2.9.0

	sed -i "s/BuildRequires: dpdk-devel/#BuildRequires: dpdk-devel/g" rhel/openvswitch-fedora.spec

        ./boot.sh
        CFLAGS='-march=native' ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-dpdk=$DPDK_BUILD
        sudo make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"

	cd ~/build/openvswitch-2.9.0/rpm/rpmbuild/RPMS/x86_64
	sudo yum install -y openvswitch-2.9.0*.rpm
else
	echo "$0 [ 2.6 | 2.8 | 2.9 ]"
fi

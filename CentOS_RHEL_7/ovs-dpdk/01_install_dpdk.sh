#!/bin/bash

CURR_DIR=`pwd`

OS=`grep 'ID="rhel"' /etc/os-release | cut -d '"' -f2 | cut -d '"' -f1`
if [ "$OS" == "rhel" ]; then
        sudo subscription-manager repos --enable=rhel-7-server-extras-rpms
        sudo subscription-manager repos --enable=rhel-7-server-optional-rpms
fi

if [ "$1" = "16.11" ];
then
	export DPDK_DIR=/usr/src/dpdk-stable-16.11.7
	export DPDK_TARGET=x86_64-native-linuxapp-gcc
	export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
	export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib

	grep hugepages /etc/default/grub
	if [ $? -ne 0 ]
	then
		echo "Add the following parameters at the end of GRUB_CMDLINE_LINUX in /etc/default/grub"
		echo "default_hugepagesz=1G hugepagesz=1G hugepages=32 hugepagesz=2M hugepages=2048 iommu=on"
	else
		echo "export DPDK_DIR=/usr/src/dpdk-stable-16.11.7" >> ~/.bashrc
		echo "export DPDK_TARGET=x86_64-native-linuxapp-gcc" >> ~/.bashrc
		echo "export DPDK_BUILD=\$DPDK_DIR/\$DPDK_TARGET" >> ~/.bashrc
		echo "export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib" >> ~/.bashrc

		if [ -f /usr/sbin/grub2-mkconfig ]
		then
			sudo grub2-mkconfig -o /boot/grub2/grub.cfg

			sudo yum install -y automake gcc gcc-c++ elfutils-libelf-devel numactl-devel

			mkdir ~/build
			cp dpdk/* ~/build && cd ~/build
			sudo tar xvfJ dpdk-16.11.7.tar.xz -C /usr/src/

			cd $DPDK_DIR
			sudo make install T=$DPDK_TARGET DESTDIR=install

			if [ -z $2 ];
			then
				sudo yum install -y dpdk-16.11.2 dpdk-devel-16.11.2 dpdk-tools-16.11.2
			fi

			sudo cp bin/boot-dpdk.sh /usr/local/bin/boot-dpdk.sh
			sudo cp bin/kill-dpdk.sh /usr/local/bin/kill-dpdk.sh
			sudo cp service/dpdk.service /etc/systemd/system/dpdk.service

			sudo systemctl daemon-reload
			sudo systemctl enable dpdk
			sudo systemctl start dpdk
		fi

		echo "Please reboot the machine"
	fi
elif [ "$1" = "17.05" ];
then
        export DPDK_DIR=/usr/src/dpdk-stable-17.05.2
        export DPDK_TARGET=x86_64-native-linuxapp-gcc
        export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
        export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib

        grep hugepages /etc/default/grub
        if [ $? -ne 0 ]
        then
                echo "Add the following parameters at the end of GRUB_CMDLINE_LINUX in /etc/default/grub"
                echo "default_hugepagesz=1G hugepagesz=1G hugepages=32 hugepagesz=2M hugepages=2048 iommu=on"
        else
                echo "export DPDK_DIR=/usr/src/dpdk-stable-17.05.2" >> ~/.bashrc
                echo "export DPDK_TARGET=x86_64-native-linuxapp-gcc" >> ~/.bashrc
                echo "export DPDK_BUILD=\$DPDK_DIR/\$DPDK_TARGET" >> ~/.bashrc
                echo "export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib" >> ~/.bashrc

                if [ -f /usr/sbin/grub2-mkconfig ]
                then
                        sudo grub2-mkconfig -o /boot/grub2/grub.cfg

                        sudo yum install -y automake gcc gcc-c++ elfutils-libelf-devel numactl-devel

                        mkdir ~/build
                        cp dpdk/* ~/build && cd ~/build
                        sudo tar xvfJ dpdk-17.05.2.tar.xz -C /usr/src/

                        cd $DPDK_DIR
                        sudo make install T=$DPDK_TARGET DESTDIR=install

                        cd $CURR_DIR

			if [ -z $2 ];
			then
				sudo yum install -y dpdk_rpms_1705/*
			fi

			sudo cp bin/boot-dpdk.sh /usr/local/bin/boot-dpdk.sh
			sudo cp bin/kill-dpdk.sh /usr/local/bin/kill-dpdk.sh
			sudo cp service/dpdk.service /etc/systemd/system/dpdk.service

			sudo systemctl daemon-reload
			sudo systemctl enable dpdk
			sudo systemctl start dpdk
                fi

                echo "Please reboot the machine"
        fi
elif [ "$1" = "17.11" ];
then
	export DPDK_DIR=/usr/src/dpdk-stable-17.11.3
	export DPDK_TARGET=x86_64-native-linuxapp-gcc
	export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
	export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib

	grep hugepages /etc/default/grub
	if [ $? -ne 0 ]
	then
		echo "Add the following parameters at the end of GRUB_CMDLINE_LINUX in /etc/default/grub"
		echo "default_hugepagesz=1G hugepagesz=1G hugepages=32 hugepagesz=2M hugepages=2048 iommu=on"
	else
		echo "export DPDK_DIR=/usr/src/dpdk-stable-17.11.3" >> ~/.bashrc
		echo "export DPDK_TARGET=x86_64-native-linuxapp-gcc" >> ~/.bashrc
		echo "export DPDK_BUILD=\$DPDK_DIR/\$DPDK_TARGET" >> ~/.bashrc
		echo "export LD_LIBRARY_PATH=$DPDK_DIR/x86_64-native-linuxapp-gcc/lib" >> ~/.bashrc

		if [ -f /usr/sbin/grub2-mkconfig ]
		then
			sudo grub2-mkconfig -o /boot/grub2/grub.cfg

			sudo yum install -y automake gcc gcc-c++ elfutils-libelf-devel numactl-devel

			mkdir ~/build
			cp dpdk/* ~/build && cd ~/build
			sudo tar xvfJ dpdk-17.11.3.tar.xz -C /usr/src/

			cd $DPDK_DIR
			sudo make install T=$DPDK_TARGET DESTDIR=install

                        cd $CURR_DIR

			if [ -z $2 ];
			then
				sudo yum install -y dpdk_rpms_1711/*
			fi

			sudo cp bin/boot-dpdk.sh /usr/local/bin/boot-dpdk.sh
			sudo cp bin/kill-dpdk.sh /usr/local/bin/kill-dpdk.sh
			sudo cp service/dpdk.service /etc/systemd/system/dpdk.service

			sudo systemctl daemon-reload
			sudo systemctl enable dpdk
			sudo systemctl start dpdk
		fi

		echo "Please reboot the machine"
	fi
else
	echo "$0 [ 16.11 | 17.05 | 17.11 ]"
fi

#!/bin/bash

EX_INT=enp216s0f0
VL_INT=enp59s0f0

modprobe uio
insmod /usr/src/dpdk-stable-17.11.3/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko

# br-ex
#/usr/src/dpdk-stable-17.11.3/usertools/dpdk-devbind.py --bind=igb_uio $EX_INT

# br-vlan
#/usr/src/dpdk-stable-17.11.3/usertools/dpdk-devbind.py --bind=igb_uio $VL_INT

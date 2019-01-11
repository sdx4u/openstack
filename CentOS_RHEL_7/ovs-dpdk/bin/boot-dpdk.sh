#!/bin/bash

EX_INT=enp216s0f0
VL_INT=enp59s0f0

modprobe vfio-pci
/usr/bin/chmod a+x /dev/vfio
/usr/bin/chmod 0666 /dev/vfio/*

# br-ex
#dpdk-devbind --bind=vfio-pci $EX_INT

# br-vlan
#dpdk-devbind --bind=vfio-pci $VL_INT

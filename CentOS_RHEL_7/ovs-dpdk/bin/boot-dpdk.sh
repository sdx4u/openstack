#!/bin/bash

modprobe vfio-pci
/usr/bin/chmod a+x /dev/vfio
/usr/bin/chmod 0666 /dev/vfio/*

#dpdk-devbind --bind=vfio-pci enp59s0f0

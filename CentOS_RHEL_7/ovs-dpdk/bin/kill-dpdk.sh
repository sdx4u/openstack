#!/bin/bash

EX_DEV=0000:d8:00.0
VL_DEV=0000:3b:00.0

# br-ex
#/usr/src/dpdk-stable-17.11.3/usertools/dpdk-devbind.py --bind=ixgbe $EX_DEV

# br-vlan
#/usr/src/dpdk-stable-17.11.3/usertools/dpdk-devbind.py --bind=i40e $VL_DEV

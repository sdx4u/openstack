#!/bin/bash

EX_DEV=0000:d8:00.0
VL_DEV=0000:3b:00.0

# br-ex
#dpdk-devbind --bind=ixgbe $EX_DEV

# br-vlan
#dpdk-devbind --bind=i40e $VL_DEV

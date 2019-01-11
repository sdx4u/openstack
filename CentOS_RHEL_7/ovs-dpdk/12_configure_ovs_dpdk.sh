#!/bin/bash

EX_DEV=0000:d8:00.0
VL_DEV=0000:3b:00.0

ovs-vsctl add-port br-ex dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=$EX_DEV
ovs-vsctl add-port br-vlan dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=$VL_DEV

ovs-vsctl show

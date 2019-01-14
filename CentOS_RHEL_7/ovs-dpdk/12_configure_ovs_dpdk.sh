#!/bin/bash

EX_DEV=0000:d8:00.0
VL_DEV=0000:3b:00.0

ovs-vsctl add-port br-ex dpdk-p0 -- set Interface dpdk-p0 type=dpdk options:dpdk-devargs=$EX_DEV
ovs-vsctl add-port br-vlan dpdk-p1 -- set Interface dpdk-p1 type=dpdk options:dpdk-devargs=$VL_DEV

ovs-vsctl show

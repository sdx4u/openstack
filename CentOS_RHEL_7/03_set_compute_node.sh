#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root ($ sudo -s)"
    exit
fi

. ./config.sh

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
    util/push-key.sh 22 root@$node
done

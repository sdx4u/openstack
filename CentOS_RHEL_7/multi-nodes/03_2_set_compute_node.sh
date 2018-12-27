#!/bin/bash

. ./config.sh

for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	util/push-key.sh 22 root@$node
done

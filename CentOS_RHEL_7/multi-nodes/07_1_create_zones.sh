#!/bin/bash

. ./config.sh

. ~/keystonerc_admin

INDEX=1
for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	nova aggregate-create node$INDEX zone$INDEX
	nova aggregate-add-host $INDEX openstack$INDEX
	INDEX=$(expr $INDEX + 1)
done

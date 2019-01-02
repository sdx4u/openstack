#!/bin/bash

. ./config.sh

. ~/keystonerc_admin

INDEX=1
for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	HOST=`ssh $COMPUTE_NODE hostname`
	nova aggregate-create node$INDEX zone$INDEX
	nova aggregate-add-host $INDEX $HOST
	INDEX=$(expr $INDEX + 1)
done

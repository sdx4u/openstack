#!/bin/bash

. ./config.sh

. ~/keystonerc_admin

INDEX=1
for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	HOST=`ssh $node hostname`

	nova aggregate-create node$INDEX zone$INDEX
	nova aggregate-add-host $INDEX $HOST
	nova aggregate-set-metadata $INDEX pinned=false

	P_INDEX=$(expr $INDEX * 2)

	nova aggregate-create p-node$INDEX p-zone$INDEX
	nova aggregate-add-host $P_INDEX $HOST
	nova aggregate-set-metadata $P_INDEX pinned=true

	INDEX=$(expr $INDEX + 1)
done

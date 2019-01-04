#!/bin/bash

. ./config.sh

. ~/keystonerc_admin

INDEX=1
for node in $(echo $COMPUTE_NODE | sed "s/,/ /g")
do
	HOST=`ssh $node hostname`

	nova aggregate-create node$INDEX zone$INDEX
	nova aggregate-add-host $INDEX $HOST
	#nova aggregate-set-metadata $INDEX pinned=false
	nova aggregate-set-metadata $INDEX pinned=true

	INDEX=$(expr $INDEX + 1)
done

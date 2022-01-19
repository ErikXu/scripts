#!/bin/bash

# Example
# bash nodegroup_describe.sh {Your Node Group Name} {Your Cluster Name}

NODEGROUP=${1}
CLUSTER=${2}

aws eks describe-nodegroup --cluster-name ${CLUSTER} --nodegroup-name ${NODEGROUP} --output json | jq -r .

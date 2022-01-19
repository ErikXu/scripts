#!/bin/bash

# Example
# bash nodegroup_listnode.sh {Your Node Group Name}

NODEGROUP=${1}

kubectl get no -l eks.amazonaws.com/nodegroup=${NODEGROUP} --no-headers=true

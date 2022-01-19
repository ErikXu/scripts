#!/bin/bash

# Example
# bash nodegroup_listpod.sh {Your Node Group Name}

NODEGROUP=${1}

#kubectl get no -l eks.amazonaws.com/nodegroup=${NODEGROUP} --no-headers=true | awk '{print $1}'

NODES=$(kubectl get no -l eks.amazonaws.com/nodegroup=${NODEGROUP} --no-headers=true -o=custom-columns='Name:metadata.name')

for NODE in ${NODES}
do
   echo "Pods of ${NODE}:"
   kubectl get po -A -owide --field-selector spec.nodeName=${NODE}
   echo ""
done

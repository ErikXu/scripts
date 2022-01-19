#!/bin/bash

# Example
# bash nodegroup_export.sh {Your Node Group Name} {Your Cluster Name}

NODEGROUP=${1}
CLUSTER=${2}

DIR=json
mkdir -p ${DIR}

JSON_FILE="${DIR}/${NODEGROUP}.json"

#aws eks describe-nodegroup --cluster-name ${CLUSTER} --nodegroup-name ${NODEGROUP} --output json | jq -r .nodegroup > ${NODEGROUP}.json

aws eks describe-nodegroup --cluster-name ${CLUSTER} --nodegroup-name ${NODEGROUP} --output json \
| jq '.nodegroup | {clusterName:.clusterName, nodegroupName:.nodegroupName, scalingConfig:.scalingConfig, diskSize:.diskSize, subnets:.subnets, instanceTypes:.instanceTypes, amiType:.amiType, remoteAccess:.remoteAccess, nodeRole:.nodeRole, labels:.labels, taints:.taints|[], tags:.tags, clientRequestToken:.clientRequestToken|"", updateConfig:.updateConfig, capacityType:.capacityType}' > ${JSON_FILE}

echo "${NODEGROUP}.json"
cat "${JSON_FILE}"

COMMAND="aws eks create-nodegroup --cli-input-json file://${JSON_FILE}"
echo ""
echo "Using 'vim ${JSON_FILE}' to modify the <nodegroupName> or other field(s) first."
echo "Using '${COMMAND}' to clone the node group."

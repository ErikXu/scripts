#!/bin/bash

# Example
# bash deploy_list_by_replicas.sh 1 default
# bash deploy_list_by_replicas.sh 5 default

CONDITION=${1}
NAMESPACE=${2-default}

kubectl get deploy -n ${NAMESPACE} -o json | jq '[.items[] | {name: .metadata.name, replicas: .spec.replicas}]' | jq --arg CONDITION ${CONDITION} '[.[] | select(.replicas==($CONDITION | tonumber))]'

kubectl get deploy -n ${NAMESPACE} -o json | jq '[.items[] | {name: .metadata.name, replicas: .spec.replicas}]' | jq --arg CONDITION ${CONDITION} '[.[] | select(.replicas==($CONDITION | tonumber))]' | jq '. | length'

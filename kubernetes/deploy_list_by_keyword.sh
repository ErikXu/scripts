#!/bin/bash

# Example
# bash deploy_list_by_keyword.sh xxx default

KEYWORD=${1}
NAMESPACE=${2-default}

kubectl get deploy -n ${NAMESPACE} -o json | jq --arg KEYWORD "${KEYWORD}" '.items[] | select(.spec | tostring | contains($KEYWORD)) | .metadata.name'

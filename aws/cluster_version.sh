#!/bin/bash

# Example
# bash cluster_version.sh {Your Cluster Name}

CLUSTER=${1}

aws eks describe-cluster --name ${CLUSTER} --output json | jq -r '{name:.cluster.name, version:.cluster.version}'

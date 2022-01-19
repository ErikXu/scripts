#!/bin/bash

# Example
# bash cluster_describe.sh {Your Cluster Name}

CLUSTER=${1-default}

aws eks describe-cluster --name ${CLUSTER} --output json | jq -r .

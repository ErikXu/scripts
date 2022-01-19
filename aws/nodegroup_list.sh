#!/bin/bash

# Example
# bash nodegroup_list.sh {Your Cluster Name}

CLUSTER=${1}

./eksctl get ng --cluster ${CLUSTER} -o json | jq '[.[] | {name: .Name, version: .Version}]'

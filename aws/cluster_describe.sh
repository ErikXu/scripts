#!/bin/bash

CLUSTER=${1-default}

aws eks describe-cluster --name ${CLUSTER} --output json | jq -r .

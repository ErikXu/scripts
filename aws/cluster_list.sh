#!/bin/bash

# Example
# bash cluster_list.sh

aws eks list-clusters --output json | jq -r .

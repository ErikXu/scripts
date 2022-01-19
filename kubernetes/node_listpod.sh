#!/bin/bash

# Example
# bash node_listpod.sh {Your Node Name}

NODE=${1}

kubectl get po -A -owide --field-selector spec.nodeName=${NODE}

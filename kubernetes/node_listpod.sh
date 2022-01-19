#!/bin/bash

NODEGROUP=${1}

kubectl get po -A -owide --field-selector spec.nodeName=${NODE}

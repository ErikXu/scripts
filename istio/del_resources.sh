#!/bin/bash

APP=${1}
NAMESPACE=${2:-'default'}

if [ -z "${APP}" ]; then
    echo "APP is empty"
    exit 1
fi

kubectl delete Sidecar ${APP}-sc -n ${NAMESPACE}
kubectl delete DestinationRule ${APP}-dr -n ${NAMESPACE}
kubectl delete VirtualService ${APP}-vs -n ${NAMESPACE}

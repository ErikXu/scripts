#!/bin/bash

APP=${1}
NAMESPACE=${2:-'default'}
VAL=${3}

if [ -z "${APP}" ]; then
    echo "APP is empty"
    exit 1
fi

if [ "${VAL}" == true ]; then
    kubectl patch deployment ${APP} -n ${NAMESPACE} -p '{"spec": {"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}} }'
else
    kubectl patch deployment ${APP} -n ${NAMESPACE} -p '{"spec": {"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"false"}}}} }'
fi

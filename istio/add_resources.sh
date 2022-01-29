#!/bin/bash

APP=${1}
NAMESPACE=${2:-'default'}

if [ -z "${APP}" ]; then
    echo "APP is empty"
    exit 1
fi

cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
metadata:
  name: ${APP}-sc
  namespace: ${NAMESPACE}
spec:
  workloadSelector:
    labels:
      app: ${APP}
  egress:
  - hosts:
    - "istio-system/*"
    - "{your host}/*"
EOF


cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: ${APP}-dr
  namespace: ${NAMESPACE}
spec:
  host: ${APP}.${NAMESPACE}.svc.cluster.local
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
  subsets:
  - name: latest
    labels:
      version: latest
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
EOF


cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ${APP}-vs
  namespace: ${NAMESPACE}
spec:
  hosts:
  - ${APP}.${NAMESPACE}.svc.cluster.local
  http:
  - name: "latest"
    match:
    - uri:
        prefix: "/"
    route:
    - destination:
        host: ${APP}.${NAMESPACE}.svc.cluster.local
        subset: latest
EOF

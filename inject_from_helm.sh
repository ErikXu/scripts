#!/bin/bash

# Template: bash inject_from_helm.sh {your app} {your istio revision} {your namespace}
# Example: bash inject_from_helm.sh nginx 1-12-2 default
# kubectl slice: https://github.com/patrickdappollonio/kubectl-slice
# yq: https://github.com/mikefarah/yq

APP=${1}
VERSION=${2:-'default'}
NAMESPACE=${3:-'default'}

bash add_resource.sh ${APP} ${NAMESPACE}

mkdir -p ./${APP}

helm get manifest ${APP} -n ${NAMESPACE} > ./${APP}/manifest.yaml

kubectl slice -f ./${APP}/manifest.yaml -o ./${APP} --include-kind Deployment --include-name ${APP}

yq -i '.spec.template.metadata.labels.version="latest"' ./${APP}/deployment-${APP}.yaml
APP=${APP} yq -i '.spec.template.metadata.labels.app=strenv(APP)' ./${APP}/deployment-${APP}.yaml
VERSION=${VERSION} yq -i '.spec.template.metadata.labels."istio.io/rev"=strenv(VERSION)' ./${APP}/deployment-${APP}.yaml

istioctl kube-inject -r ${VERSION} -f ./${APP}/deployment-${APP}.yaml -o ./${APP}/deployment-${APP}-inject-${VERSION}.yaml

kubectl apply -f ./${APP}/deployment-${APP}-inject-${VERSION}.yaml -n ${NAMESPACE}

#!/bin/bash

# Template: bash uninject_from_helm.sh {your app} {your istio revision} {your namespace}
# Example: bash uninject_from_helm.sh nginx 1-12-2 default
# kubectl slice: https://github.com/patrickdappollonio/kubectl-slice
# yq: https://github.com/mikefarah/yq

APP=${1}
VERSION=${2:-'default'}
NAMESPACE=${3:-'default'}

bash del_resource.sh ${APP} ${NAMESPACE}

mkdir -p ./${APP}

helm get manifest ${APP} -n ${NAMESPACE} > ./${APP}/manifest.yaml

kubectl slice -f ./${APP}/manifest.yaml -o ./${APP} --include-kind Deployment --include-name ${APP}

#istioctl kube-inject -r ${VERSION} -f ./${APP}/deployment-${APP}.yaml -o ./${APP}/deployment-${APP}-inject-${VERSION}.yaml

#istioctl x kube-uninject -f ./${APP}/deployment-${APP}-inject-${VERSION}.yaml -o ./${APP}/deployment-${APP}-uninject-${VERSION}.yaml

kubectl apply -f ./${APP}/deployment-${APP}.yaml -n ${NAMESPACE}

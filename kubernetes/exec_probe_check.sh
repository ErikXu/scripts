#!/bin/bash

# Example
# bash exec_probe_check.sh check deploy default
# bash exec_probe_check.sh check ds default
# bash exec_probe_check.sh check sts default
# bash exec_probe_check.sh patch deploy default
# bash exec_probe_check.sh patch ds default
# bash exec_probe_check.sh patch sts default

ACTION=${1:-'check'}
TYPE=${2:-'deploy'}
NAMESPACE=${3:-'default'}

APPS=$(kubectl get ${TYPE} -n ${NAMESPACE} -o custom-columns=:metadata.name --no-headers)

if [ "${ACTION}" != "patch" ]; then
  printf "%-20s %-40s %-10s %-10s %-10s %-10s %-40s \n" "NAMESPACE" "CONTAINER" "LIVENESS" "TIMEOUT" "READINESS" "TIMEOUT" "APP"
fi

for APP in ${APPS}
do
  CONTAINERS=$(kubectl get ${TYPE} ${APP} -n ${NAMESPACE} -o jsonpath="{.spec.template.spec.containers[*].name}")
  INDEX=0
  for CONTAINER in ${CONTAINERS}
  do
    LIVENESS=$(kubectl get ${TYPE} ${APP} -n ${NAMESPACE} -o jsonpath="{.spec.template.spec.containers[${INDEX}].livenessProbe.exec}")
    if [ -z "${LIVENESS}" ]
    then
      HAS_LIVENESS=N
    else
      HAS_LIVENESS=Y
    fi

    LIVENESS_TIMEOUT=0
    if [ "${HAS_LIVENESS}" == "Y" ]; then
      LIVENESS_TIMEOUT=$(kubectl get ${TYPE} ${APP} -n ${NAMESPACE} -o jsonpath="{.spec.template.spec.containers[${INDEX}].livenessProbe.timeoutSeconds}")
    fi

    READINESS=$(kubectl get ${TYPE} ${APP} -n ${NAMESPACE} -o jsonpath="{.spec.template.spec.containers[${INDEX}].readinessProbe.exec}")
    if [ -z "$READINESS" ]
    then
      HAS_READINESS=N
    else
      HAS_READINESS=Y
    fi

    READINESS_TIMEOUT=0
    if [ "${HAS_READINESS}" == "Y" ]; then
      READINESS_TIMEOUT=$(kubectl get ${TYPE} ${APP} -n ${NAMESPACE} -o jsonpath="{.spec.template.spec.containers[${INDEX}].readinessProbe.timeoutSeconds}")
    fi

    if [ "${ACTION}" == "patch" ]; then
      if (( ${LIVENESS_TIMEOUT} > 0 )); then
        echo "kubectl patch ${TYPE} ${APP} -n ${NAMESPACE} --type=json -p='[{"op": "replace", "path": "/spec/template/spec/container/${INDEX}/livenessProbe/timeoutSeconds", "value": "10"}]'"
      fi
    fi

    if [ "${ACTION}" == "patch" ]; then
      if (( ${READINESS_TIMEOUT} > 0 )); then
        echo "kubectl patch ${TYPE} ${APP} -n ${NAMESPACE} --type=json -p='[{"op": "replace", "path": "/spec/template/spec/container/${INDEX}/readinessProbe/timeoutSeconds", "value": "10"}]'"
      fi
    fi

    if [ "${ACTION}" != "patch" ]; then
      if [ "${HAS_LIVENESS}" == "Y" ] ||[ "${HAS_READINESS}" == "Y" ]; then
        printf "%-20s %-40s %-10s %-10s %-10s %-10s %-40s \n" ${NAMESPACE} ${CONTAINER} ${HAS_LIVENESS} ${LIVENESS_TIMEOUT} ${HAS_READINESS} ${READINESS_TIMEOUT} ${APP}
      fi
    fi

    (( INDEX += 1 ))
  done
done

echo "End"

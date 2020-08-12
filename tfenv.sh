#!/usr/bin/env bash
set +o xtrace
set -o errexit

TF_011="0.11.14-mesosphere"
TF_012="0.12.25-mesosphere"


PROVIDER="${1}"
UNIVERSAL_INSTALLER_BASE_VERSION="${2}"
MODULEPROVIDER="${3}"

if [[ "${UNIVERSAL_INSTALLER_BASE_VERSION}" == "0.1.x" || "${UNIVERSAL_INSTALLER_BASE_VERSION}" == "0.2.x" ]]; then
  tfenv use "${TF_011}"
elif [[ "${UNIVERSAL_INSTALLER_BASE_VERSION}" == "0.3.x"  ]]; then
  tfenv use "${TF_012}"
else
  tfenv use "${TF_011}"
fi

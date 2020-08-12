#!/usr/bin/env sh
set +o xtrace
set -o errexit

terraform init -upgrade

if terraform --version | grep v0.11; then
  terraform validate -check-variables=false
else
  terraform validate
fi

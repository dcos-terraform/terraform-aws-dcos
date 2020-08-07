#!/usr/bin/env sh
set +o xtrace
set -o errexit

terraform init -upgrade
terraform validate -check-variables=false

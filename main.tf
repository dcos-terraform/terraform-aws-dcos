/**
 * DC/OS on AWS
 * ============
 * Creates a DC/OS Cluster on AWS
 *
 * EXAMPLE
 * -------
 *
 *```hcl
 * module "dcos" {
 *   source  = "dcos-terraform/dcos/aws"
 *   version = "~> 0.1"
 *
 *   cluster_name = "production"
 *   ssh_public_key = "ssh-rsa ..."
 *
 *   num_masters = "3"
 *   num_private_agents = "2"
 *   num_public_agents = "1"
 *
 *   dcos_type = "open"
 *   # dcos_license_key_contents = ""
 * }
 *```
 */

provider "aws" {}

module "dcos-infrastructure" {
  source  = "dcos-terraform/infrastructure/aws"
  version = "~> 0.0"

  cluster_name       = "${var.cluster_name}"
  ssh_public_key     = "${var.ssh_public_key}"
  aws_key_name       = "${var.aws_key_name}"
  num_masters        = "${var.num_masters}"
  num_private_agents = "${var.num_private_agents}"
  num_public_agents  = "${var.num_public_agents}"

  providers = {
    aws = "aws"
  }
}

/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

module "dcos-install" {
  source = "dcos-terraform/dcos-install-remote-exec/null"
  version = "~> 0.0"

  # bootstrap
  bootstrap_ip         = "${module.dcos-infrastructure.bootstrap.public_ip}"
  bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
  bootstrap_os_user    = "${module.dcos-infrastructure.bootstrap.os_user}"
  # master
  master_ips         = ["${module.dcos-infrastructure.masters.public_ips}"]
  master_private_ips = ["${module.dcos-infrastructure.masters.private_ips}"]
  masters_os_user    = "${module.dcos-infrastructure.masters.os_user}"
  num_masters        = "${var.num_masters}"
  # private agent
  private_agent_ips      = ["${module.dcos-infrastructure.private_agents.public_ips}"]
  private_agents_os_user = "${module.dcos-infrastructure.private_agents.os_user}"
  num_private_agents = "${var.num_private_agents}"
  # public agent
  public_agent_ips      = ["${module.dcos-infrastructure.public_agents.public_ips}"]
  public_agents_os_user = "${module.dcos-infrastructure.public_agents.os_user}"
  num_public_agents  = "${var.num_public_agents}"
  # DC/OS options
  dcos_install_mode = "install"
  dcos_cluster_name = "${var.cluster_name}"
  dcos_version      = "${var.dcos_version}"
  dcos_ip_detect_public_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

curl -fsSL http://whatismyip.akamai.com/
EOF
  dcos_ip_detect_contents = <<EOF
#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
EOF
  dcos_fault_domain_detect_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

METADATA="$(curl http://169.254.169.254/latest/dynamic/instance-identity/document 2>/dev/null)"
REGION=$(echo $METADATA | grep -Po "\"region\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)
ZONE=$(echo $METADATA | grep -Po "\"availabilityZone\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)

echo "{\"fault_domain\":{\"region\":{\"name\": $REGION},\"zone\":{\"name\": $ZONE}}}"
EOF
  dcos_type                      = "${var.dcos_type}"
  dcos_license_key_contents      = "${var.dcos_license_key_contents}"
  dcos_master_discovery          = "static"
  dcos_exhibitor_storage_backend = "static"
}

output "bootstrap_ip" {
  value = "${module.dcos-infrastructure.bootstrap.public_ip}"
}

output "master_ips" {
  value = "${module.dcos-infrastructure.masters.public_ips}"
}

output "masters-loadbalancer" {
  description = "This is the load balancer address to access the DC/OS UI"
  value       = "${module.dcos-infrastructure.elb.masters_dns_name}"
}

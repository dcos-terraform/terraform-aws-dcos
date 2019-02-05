variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias = "spoke-1"
}

module "dcos" {
<<<<<<< HEAD
  source  = "git@github.com:dcos-terraform/terraform-aws-dcos?ref=multi-region"
  # version = "~> 0.1.0"
=======
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.1.0"
>>>>>>> 4fa09ef86efda42653994017504c367da5bdea24

  providers = {
    aws = "aws"
  }

  dcos_instance_os    = "coreos_1855.5.0"
  cluster_name        = "region1"
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_version = "1.11.4"

  # dcos_variant              = "ee"
  # dcos_license_key_contents = "${file("./license.txt")}"
  dcos_variant = "open"

  dcos_install_mode = "${var.dcos_install_mode}"
}

module "spoke-1" {
  source  = "git@github.com:bernadinm/terraform-aws-remote-agents"
  #  version = "~> 0.1.0"

  providers = {
    aws   = "aws.spoke-1"
  }

  dcos_instance_os    = "coreos_1855.5.0"
  cluster_name        = "region2"
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]

  bootstrap_ip         = "${module.dcos.infrastructure-bootstrap.public_ip}"
  bootstrap_private_ip = "${module.dcos.infrastructure-bootstrap.private_ip}"
  bootstrap_os_user    = "${module.dcos.infrastructure-bootstrap.os_user}"
  bootstrap_prereq-id  = "${module.dcos.infrastructure-bootstrap.prereq-id}"

  num_private_agents = "2"
  num_public_agents  = "1"

  subnet_range = "172.14.0.0/16"

  dcos_install_mode = "${var.dcos_install_mode}"
}

module "vpc-peering" {
  source  = "dcos-terraform/vpc-peering/aws"
  version = "1.0.0"

  providers = {
    aws.this = "aws"
    aws.peer = "aws.spoke-1"
  }

  peer_region             = "us-east-1"
  this_vpc_id             = "vpc-00000000"
  peer_vpc_id             = "vpc-11111111"
  cross_region_peering    = true
  auto_accept_peering     = true
  create_peering          = true

  tags = {
    Name        = "my-peering-connection"
    Environment = "prod"
  }
}

output "masters-ips-site1" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address-site1" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer-site1" {
  value = "${module.dcos.public-agents-loadbalancer}"
}

output "private-agents-ips-site2" {
  value = "${module.spoke-1.private_agents-ips}"
}

output "public-agents-ips-site2" {
  value = "${module.spoke-1.public_agents-ips}"
}

output "public-agents-loadbalancer-site2" {
  value = "${module.spoke-1.public-agents-loadbalancer}"
}

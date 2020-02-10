variable "cluster_name" {
  description = "Name of the DC/OS cluster"
  default     = "dcos-example"
}

variable "ssh_public_key_file" {
  description = "Path to an SSH public key to be used with the instances. Make sure you added this key to your ssh-agent"
}

variable "tags" {
  description = "Add custom tags to all resources"
  type        = "map"
  default     = {}
}

variable "custom_dcos_download_path" {
  description = "insert location of dcos installer script (optional)"
}

variable "dcos_version" {
  description = "Specify the availability zones to be used"
  default     = "1.11.3"
}

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.0.19"

  cluster_name        = "${var.cluster_name}"
  ssh_public_key_file = "${var.ssh_public_key_file}"
  tags                = "${var.tags}"

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_variant              = "open"
  custom_dcos_download_path = "${var.custom_dcos_download_path}"
  dcos_version              = "${var.dcos_version}"

  dcos_calico_network_cidr = "${var.dcos_calico_network_cidr}"
  subnet_range             = "${var.subnet_range}"
  dcos_calico_vxlan_enabled = "${var.dcos_calico_vxlan_enabled}"

  # uncomment the following lines if MTU is configured
  # dcos_calico_veth_mtu  = "${var.dcos_calico_veth_mtu}"
  # uncomment the following line for VXLAN mode
  # dcos_calico_vxlan_mtu = "${var.dcos_calico_vxlan_mtu}"
  # or uncomment the following line for IP in IP mode
  # dcos_calico_ipinip_mtu = "${var.dcos_calico_ipinip_mtu}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

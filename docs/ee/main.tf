module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-open-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_variant = "ee"
  dcos_license_key_contents = "LICENSE_KEY_HERE"

  
  
}

output "masters-ips" {
  value       = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value       = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}

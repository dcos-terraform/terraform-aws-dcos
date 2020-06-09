output "infrastructure_aws_key_name" {
  description = "This is the AWS key name used for the cluster"
  value       = module.dcos-infrastructure.aws_key_name
}

output "infrastructure_bootstrap_instance" {
  description = "Bootstrap instance ID"
  value       = module.dcos-infrastructure.bootstrap_instance
}

output "infrastructure_bootstrap_public_ip" {
  description = "Public IP of the bootstrap instance"
  value       = module.dcos-infrastructure.bootstrap_public_ip
}

output "infrastructure_bootstrap_private_ip" {
  description = "Private IP of the bootstrap instance"
  value       = module.dcos-infrastructure.bootstrap_private_ip
}

output "infrastructure_bootstrap_os_user" {
  description = "Bootstrap instance OS default user"
  value       = module.dcos-infrastructure.bootstrap_os_user
}

output "infrastructure_masters_instances" {
  description = "Master instances IDs"
  value       = [module.dcos-infrastructure.masters_instances]
}

output "infrastructure_masters_public_ips" {
  description = "Master instances public IPs"
  value       = [module.dcos-infrastructure.masters_public_ips]
}

output "infrastructure_masters_private_ips" {
  description = "Master instances private IPs"
  value       = [module.dcos-infrastructure.masters_private_ips]
}

output "infrastructure_masters_os_user" {
  description = "Master instances OS default user"
  value       = module.dcos-infrastructure.masters_os_user
}

output "infrastructure_masters_aws_iam_instance_profile" {
  description = "Masters instance profile name"
  value       = module.dcos-infrastructure.masters_aws_iam_instance_profile
}

output "infrastructure_private_agents_instances" {
  description = "Private Agent instances IDs"
  value       = [module.dcos-infrastructure.private_agents_instances]
}

output "infrastructure_private_agents_public_ips" {
  description = "Private Agent public IPs"
  value       = [module.dcos-infrastructure.private_agents_public_ips]
}

output "infrastructure_private_agents_private_ips" {
  description = "Private Agent instances private IPs"
  value       = [module.dcos-infrastructure.private_agents_private_ips]
}

output "infrastructure_private_agents_os_user" {
  description = "Private Agent instances OS default user"
  value       = module.dcos-infrastructure.private_agents_os_user
}

output "infrastructure_private_agents_aws_iam_instance_profile" {
  description = "Private Agent instance profile name"
  value       = module.dcos-infrastructure.private_agents_aws_iam_instance_profile
}

//Private Agent
output "infrastructure_public_agents_instances" {
  description = "Public Agent instances IDs"
  value       = [module.dcos-infrastructure.public_agents_instances]
}

output "infrastructure_public_agents_public_ips" {
  description = "Public Agent public IPs"
  value       = [module.dcos-infrastructure.public_agents_public_ips]
}

output "infrastructure_public_agents_private_ips" {
  description = "Public Agent instances private IPs"
  value       = [module.dcos-infrastructure.public_agents_private_ips]
}

output "infrastructure_public_agents_os_user" {
  description = "Public Agent instances OS default user"
  value       = module.dcos-infrastructure.public_agents_os_user
}

output "infrastructure_public_agents_aws_iam_instance_profile" {
  description = "Public Agent instance profile name"
  value       = module.dcos-infrastructure.public_agents_aws_iam_instance_profile
}

output "infrastructure_iam_agent_profile" {
  value       = module.dcos-infrastructure.iam_agent_profile
  description = "Name of the agent profile"
}

output "infrastructure_iam_master_profile" {
  value       = module.dcos-infrastructure.iam_master_profile
  description = "Name of the master profile"
}

output "infrastructure_lb_public_agents_dns_name" {
  description = "This is the load balancer to reach the public agents"
  value       = module.dcos-infrastructure.lb_public_agents_dns_name
}

output "infrastructure_lb_masters_dns_name" {
  description = "This is the load balancer to access the DC/OS UI"
  value       = module.dcos-infrastructure.lb_masters_dns_name
}

output "infrastructure_lb_masters_internal_dns_name" {
  description = "This is the load balancer to access the masters internally in the cluster"
  value       = module.dcos-infrastructure.lb_masters_internal_dns_name
}

output "infrastructure_security_groups_internal" {
  description = "This is the id of the internal security_group that the cluster is in"
  value       = module.dcos-infrastructure.security_groups_internal
}

output "infrastructure_security_groups_admin" {
  description = "This is the id of the admin security_group that the cluster is in"
  value       = module.dcos-infrastructure.security_groups_admin
}

output "infrastructure_vpc_id" {
  description = "This is the id of the VPC the cluster is in"
  value       = module.dcos-infrastructure.vpc_id
}

output "infrastructure_vpc_cidr_block" {
  description = "This is the id of the VPC the cluster is in"
  value       = module.dcos-infrastructure.vpc_cidr_block
}

output "infrastructure_vpc_main_route_table_id" {
  description = "This is the id of the VPC's main routing table the cluster is in"
  value       = module.dcos-infrastructure.vpc_main_route_table_id
}

output "infrastructure_vpc_subnet_ids" {
  description = "This is the list of subnet_ids the cluster is in"
  value       = [module.dcos-infrastructure.vpc_subnet_ids]
}


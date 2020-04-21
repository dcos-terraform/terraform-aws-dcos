output "infrastructure.aws_key_name" {
  description = "This is the AWS key name used for the cluster"
  value       = "${module.dcos-infrastructure.aws_key_name}"
}

output "infrastructure.bootstrap.instance" {
  description = "Bootstrap instance ID"
  value       = "${module.dcos-infrastructure.bootstrap.instance}"
}

output "infrastructure.bootstrap.public_ip" {
  description = "Public IP of the bootstrap instance"
  value       = "${module.dcos-infrastructure.bootstrap.public_ip}"
}

output "infrastructure.bootstrap.private_ip" {
  description = "Private IP of the bootstrap instance"
  value       = "${module.dcos-infrastructure.bootstrap.private_ip}"
}

output "infrastructure.bootstrap.os_user" {
  description = "Bootstrap instance OS default user"
  value       = "${module.dcos-infrastructure.bootstrap.os_user}"
}

output "infrastructure.masters.instances" {
  description = "Master instances IDs"
  value       = ["${module.dcos-infrastructure.masters.instances}"]
}

output "infrastructure.masters.public_ips" {
  description = "Master instances public IPs"
  value       = ["${module.dcos-infrastructure.masters.public_ips}"]
}

output "infrastructure.masters.private_ips" {
  description = "Master instances private IPs"
  value       = ["${module.dcos-infrastructure.masters.private_ips}"]
}

output "infrastructure.masters.os_user" {
  description = "Master instances OS default user"
  value       = "${module.dcos-infrastructure.masters.os_user}"
}

output "infrastructure.masters.aws_iam_instance_profile" {
  description = "Masters instance profile name"
  value       = "${module.dcos-infrastructure.masters.aws_iam_instance_profile}"
}

output "infrastructure.private_agents.instances" {
  description = "Private Agent instances IDs"
  value       = ["${module.dcos-infrastructure.private_agents.instances}"]
}

output "infrastructure.private_agents.public_ips" {
  description = "Private Agent public IPs"
  value       = ["${module.dcos-infrastructure.private_agents.public_ips}"]
}

output "infrastructure.private_agents.private_ips" {
  description = "Private Agent instances private IPs"
  value       = ["${module.dcos-infrastructure.private_agents.private_ips}"]
}

output "infrastructure.private_agents.os_user" {
  description = "Private Agent instances OS default user"
  value       = "${module.dcos-infrastructure.private_agents.os_user}"
}

output "infrastructure.private_agents.aws_iam_instance_profile" {
  description = "Private Agent instance profile name"
  value       = "${module.dcos-infrastructure.private_agents.aws_iam_instance_profile}"
}

//Private Agent
output "infrastructure.public_agents.instances" {
  description = "Public Agent instances IDs"
  value       = ["${module.dcos-infrastructure.public_agents.instances}"]
}

output "infrastructure.public_agents.public_ips" {
  description = "Public Agent public IPs"
  value       = ["${module.dcos-infrastructure.public_agents.public_ips}"]
}

output "infrastructure.public_agents.private_ips" {
  description = "Public Agent instances private IPs"
  value       = ["${module.dcos-infrastructure.public_agents.private_ips}"]
}

output "infrastructure.public_agents.os_user" {
  description = "Public Agent instances OS default user"
  value       = "${module.dcos-infrastructure.public_agents.os_user}"
}

output "infrastructure.public_agents.aws_iam_instance_profile" {
  description = "Public Agent instance profile name"
  value       = "${module.dcos-infrastructure.public_agents.aws_iam_instance_profile}"
}

output "infrastructure.iam.agent_profile" {
  value       = "${module.dcos-infrastructure.iam.agent_profile}"
  description = "Name of the agent profile"
}

output "infrastructure.iam.master_profile" {
  value       = "${module.dcos-infrastructure.iam.master_profile}"
  description = "Name of the master profile"
}

output "infrastructure.lb.public_agents_dns_name" {
  description = "This is the load balancer to reach the public agents"
  value       = "${module.dcos-infrastructure.lb.public_agents_dns_name}"
}

output "infrastructure.lb.masters_dns_name" {
  description = "This is the load balancer to access the DC/OS UI"
  value       = "${module.dcos-infrastructure.lb.masters_dns_name}"
}

output "infrastructure.lb.masters_internal_dns_name" {
  description = "This is the load balancer to access the masters internally in the cluster"
  value       = "${module.dcos-infrastructure.lb.masters_internal_dns_name}"
}

output "infrastructure.security_groups.internal" {
  description = "This is the id of the internal security_group that the cluster is in"
  value       = "${module.dcos-infrastructure.security_groups.internal}"
}

output "infrastructure.security_groups.admin" {
  description = "This is the id of the admin security_group that the cluster is in"
  value       = "${module.dcos-infrastructure.security_groups.admin}"
}

output "infrastructure.vpc.id" {
  description = "This is the id of the VPC the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.id}"
}

output "infrastructure.vpc.cidr_block" {
  description = "This is the id of the VPC the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.cidr_block}"
}

output "infrastructure.vpc.main_route_table_id" {
  description = "This is the id of the VPC's main routing table the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.main_route_table_id}"
}

output "infrastructure.vpc.subnet_ids" {
  description = "This is the list of subnet_ids the cluster is in"
  value       = ["${module.dcos-infrastructure.vpc.subnet_ids}"]
}

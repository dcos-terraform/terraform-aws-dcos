output "infrastructure-bootstrap.instance" {
  description = "Bootstrap instance ID"
  value       = "${module.dcos-infrastructure.bootstrap.instance}"
}

output "infrastructure-bootstrap.public_ip" {
  description = "Public IP of the bootstrap instance"
  value       = "${module.dcos-infrastructure.bootstrap.public_ip}"
}

output "infrastructure-bootstrap.private_ip" {
  description = "Private IP of the bootstrap instance"
  value       = "${module.dcos-infrastructure.bootstrap.private_ip}"
}

output "infrastructure-bootstrap.os_user" {
  description = "Bootstrap instance OS default user"
  value       = "${module.dcos-infrastructure.bootstrap.os_user}"
}

output "infrastructure-bootstrap.prereq-id" {
  description = "Returns the ID of the prereq script for bootstrap (if user_data or ami are not used)"
  value       = "${module.dcos-infrastructure.bootstrap.prereq-id}"
}

output "infrastructure-masters.instances" {
  description = "Master instances IDs"
  value       = ["${module.dcos-infrastructure.masters.instances}"]
}

output "infrastructure-masters.public_ips" {
  description = "Master instances public IPs"
  value       = ["${module.dcos-infrastructure.masters.public_ips}"]
}

output "infrastructure-masters.private_ips" {
  description = "Master instances private IPs"
  value       = ["${module.dcos-infrastructure.masters.private_ips}"]
}

output "infrastructure-masters.os_user" {
  description = "Master instances private OS default user"
  value       = "${module.dcos-infrastructure.masters.os_user}"
}

output "infrastructure-masters.prereq-id" {
  description = "Returns the ID of the prereq script for masters (if user_data or ami are not used)"
  value       = "${module.dcos-infrastructure.masters.prereq-id}"
}

output "infrastructure-private_agents.instances" {
  description = "Private Agent instances IDs"
  value       = ["${module.dcos-infrastructure.private_agents.instances}"]
}

output "infrastructure-private_agents.public_ips" {
  description = "Private Agent public IPs"
  value       = ["${module.dcos-infrastructure.private_agents.public_ips}"]
}

output "infrastructure-private_agents.private_ips" {
  description = "Private Agent instances private IPs"
  value       = ["${module.dcos-infrastructure.private_agents.private_ips}"]
}

output "infrastructure-private_agents.os_user" {
  description = "Private Agent instances private OS default user"
  value       = "${module.dcos-infrastructure.private_agents.os_user}"
}

output "infrastructure-private_agents.prereq-id" {
  description = "Returns the ID of the prereq script for private agents (if user_data or ami are not used)"
  value       = "${module.dcos-infrastructure.private_agents.prereq-id}"
}

//Private Agent
output "infrastructure-public_agents.instances" {
  description = "Public Agent instances IDs"
  value       = ["${module.dcos-infrastructure.public_agents.instances}"]
}

output "infrastructure-public_agents.public_ips" {
  description = "Public Agent public IPs"
  value       = ["${module.dcos-infrastructure.public_agents.public_ips}"]
}

output "infrastructure-public_agents.private_ips" {
  description = "Public Agent instances private IPs"
  value       = ["${module.dcos-infrastructure.public_agents.private_ips}"]
}

output "infrastructure-public_agents.os_user" {
  description = "Private Agent instances private OS default user"
  value       = "${module.dcos-infrastructure.public_agents.os_user}"
}

output "infrastructure-public_agents.prereq-id" {
  description = "Returns the ID of the prereq script for public agents (if user_data or ami are not used)"
  value       = "${module.dcos-infrastructure.public_agents.prereq-id}"
}

output "infrastructure-elb.public_agents_dns_name" {
  description = "This is the load balancer to reach the public agents"
  value       = "${module.dcos-infrastructure.elb.public_agents_dns_name}"
}

output "infrastructure-elb.masters_dns_name" {
  description = "This is the load balancer to access the DC/OS UI"
  value       = "${module.dcos-infrastructure.elb.masters_dns_name}"
}

output "infrastructure-elb.masters_internal_dns_name" {
  description = "This is the load balancer to access the masters internally in the cluster"
  value       = "${module.dcos-infrastructure.elb.masters_internal_dns_name}"
}

output "infrastructure.vpc_id" {
  description = "This is the id of the VPC the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.id}"
}

output "infrastructure.vpc_cidr_block" {
  description = "This is the id of the VPC the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.cidr_block}"
}

output "infrastructure.vpc_main_route_table_id" {
  description = "This is the id of the VPC's main routing table the cluster is in"
  value       = "${module.dcos-infrastructure.vpc.main_route_table_id}"
}

output "infrastructure.security_group_internal_id" {
  description = "This is the id of the internal security_group that the cluster is in"
  value       = "${module.dcos-infrastructure.security_group.internal_id}"
}

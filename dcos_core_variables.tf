# Main Variables
variable "dcos_variant" {
  default = "open"
}

variable "bootstrap_private_ip" {
  default     = ""
  description = "used for the private ip for the bootstrap url"
}

variable "dcos_install_mode" {
  default     = "install"
  description = "specifies which type of command to execute. Options: `install` or `upgrade`"
}

variable "dcos_version" {
  default     = "1.11.4"
  description = "specifies which dcos version instruction to use. Options: `1.9.0`, `1.8.8`, etc. _See [dcos_download_path](https://github.com/dcos/tf_dcos_core/blob/master/download-variables.tf) or [dcos_version](https://github.com/dcos/tf_dcos_core/tree/master/dcos-versions) tree for a full list._"
}

# variable "role" {
#   description = "specifies which dcos role of commands to run. Options: `dcos-bootstrap`, `dcos-mesos-agent-public`, `dcos-mesos-agent` and `dcos-mesos-master`"
# }

# DCOS bootstrap node variables
variable "dcos_security" {
  default     = ""
  description = "[Enterprise DC/OS] set the security level of DC/OS. Default is permissive. (recommended)"
}

variable "dcos_resolvers" {
  default     = ""
  description = "A YAML nested list (-) of DNS resolvers for your DC/OS cluster nodes. (recommended)"
}

variable "dcos_skip_checks" {
  default     = false
  description = "Upgrade option: Used to skip all dcos checks that may block an upgrade if any DC/OS component is unhealthly. (optional) applicable: 1.10+"
}

variable "dcos_oauth_enabled" {
  default     = ""
  description = "[Open DC/OS Only] Indicates whether to enable authentication for your cluster. (optional)"
}

variable "dcos_master_external_loadbalancer" {
  default     = ""
  description = "Allows DC/OS to configure certs around the External Load Balancer name. If not used SSL verfication issues will arrise. EE only. (recommended)"
}

variable "dcos_master_discovery" {
  default     = "static"
  description = "The Mesos master discovery method. The available options are static or master_http_loadbalancer. (recommend the use of master_http_loadbalancer)"
}

variable "dcos_aws_template_storage_bucket" {
  default     = ""
  description = "the aws CloudFormation bucket name (optional)"
}

variable "dcos_aws_template_storage_bucket_path" {
  default     = ""
  description = "the aws CloudFormation bucket path (optional)"
}

variable "dcos_aws_template_storage_region_name" {
  default     = ""
  description = "the aws CloudFormation region name (optional)"
}

variable "dcos_aws_template_upload" {
  default     = ""
  description = "to automatically upload the customized advanced templates to your S3 bucket. (optional)"
}

variable "dcos_aws_template_storage_access_key_id" {
  default     = ""
  description = "the aws key ID for CloudFormation template storage (optional)"
}

variable "dcos_aws_template_storage_secret_access_key" {
  default     = ""
  description = "the aws secret key for the CloudFormation template (optional)"
}

variable "dcos_exhibitor_storage_backend" {
  default     = "static"
  description = "options are aws_s3, azure, or zookeeper (recommended)"
}

variable "dcos_exhibitor_zk_hosts" {
  default     = ""
  description = "a comma-separated list of one or more ZooKeeper node IP and port addresses to use for configuring the internal Exhibitor instances. (not recommended but required with exhibitor_storage_backend set to ZooKeeper. Use aws_s3 or azure instead. Assumes external ZooKeeper is already online.)"
}

variable "dcos_exhibitor_zk_path" {
  default     = ""
  description = "the filepath that Exhibitor uses to store data (not recommended but required with exhibitor_storage_backend set to `zookeeper`. Use `aws_s3` or `azure` instead. Assumes external ZooKeeper is already online.)"
}

variable "dcos_aws_access_key_id" {
  default     = ""
  description = "the aws key ID for exhibitor storage  (optional but required with dcos_exhibitor_address)"
}

variable "dcos_aws_region" {
  default     = ""
  description = "the aws region for exhibitor storage (optional but required with dcos_exhibitor_address)"
}

variable "dcos_aws_secret_access_key" {
  default     = ""
  description = "the aws secret key for exhibitor storage (optional but required with dcos_exhibitor_address)"
}

variable "dcos_exhibitor_explicit_keys" {
  default     = ""
  description = "set whether you are using AWS API keys to grant Exhibitor access to S3. (optional)"
}

variable "dcos_s3_bucket" {
  default     = ""
  description = "name of the s3 bucket for the exhibitor backend (recommended but required with dcos_exhibitor_address)"
}

variable "dcos_s3_prefix" {
  default     = ""
  description = "name of the s3 prefix for the exhibitor backend (recommended but required with dcos_exhibitor_address)"
}

variable "dcos_exhibitor_azure_account_name" {
  default     = ""
  description = "the azure account name for exhibitor storage (optional but required with dcos_exhibitor_address)"
}

variable "dcos_exhibitor_azure_account_key" {
  default     = ""
  description = "the azure account key for exhibitor storage (optional but required with dcos_exhibitor_address)"
}

variable "dcos_exhibitor_azure_prefix" {
  default     = ""
  description = "the azure account name for exhibitor storage (optional but required with dcos_exhibitor_address)"
}

variable "dcos_exhibitor_address" {
  default     = ""
  description = "The address of the load balancer in front of the masters (recommended)"
}

variable "num_of_public_agents" {
  default = ""
}

variable "num_of_private_agents" {
  default = ""
}

variable "dcos_num_masters" {
  default     = ""
  description = "set the num of master nodes (required with exhibitor_storage_backend set to aws_s3, azure, ZooKeeper)"
}

variable "dcos_customer_key" {
  default     = ""
  description = "[Enterprise DC/OS] sets the customer key (optional)"
}

variable "dcos_rexray_config_method" {
  default     = ""
  description = "The REX-Ray configuration method for enabling external persistent volumes in Marathon.  (optional)"
}

variable "dcos_rexray_config_filename" {
  default     = ""
  description = "The REX-Ray configuration filename for enabling external persistent volumes in Marathon. (optional)"
}

variable "dcos_adminrouter_tls_1_0_enabled" {
  default     = ""
  description = "Indicates whether to enable TLSv1 support in Admin Router. (optional)"
}

variable "dcos_adminrouter_tls_1_1_enabled" {
  default     = ""
  description = "Indicates whether to enable TLSv1.1 support in Admin Router. (optional)"
}

variable "dcos_adminrouter_tls_1_2_enabled" {
  default     = ""
  description = "Indicates whether to enable TLSv1.2 support in Admin Router. (optional)"
}

variable "dcos_adminrouter_tls_cipher_suite" {
  default     = ""
  description = "[Enterprise DC/OS] Indicates whether to allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. (optional)"
}

variable "dcos_auth_cookie_secure_flag" {
  default     = ""
  description = "[Enterprise DC/OS] allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. (optional)"
}

variable "dcos_bouncer_expiration_auth_token_days" {
  default     = ""
  description = "[Enterprise DC/OS] Sets the auth token time-to-live (TTL) for Identity and Access Management. (optional)"
}

variable "dcos_superuser_password_hash" {
  default     = ""
  description = "[Enterprise DC/OS] set the superuser password hash (recommended)"
}

variable "dcos_cluster_name" {
  default     = ""
  description = "sets the DC/OS cluster name"
}

variable "dcos_ca_certificate_chain_path" {
  default     = ""
  description = "[Enterprise DC/OS] Path (relative to the $DCOS_INSTALL_DIR) to a file containing the complete CA certification chain required for end-entity certificate verification, in the OpenSSL PEM format. (optional)"
}

variable "dcos_ca_certificate_path" {
  default     = ""
  description = "[Enterprise DC/OS] Path (relative to the $DCOS_INSTALL_DIR) to a file containing a single X.509 CA certificate in the OpenSSL PEM format. (optional)"
}

variable "dcos_ca_certificate_key_path" {
  default = ""
}

variable "dcos_config" {
  default     = ""
  description = "used to add any extra arguments in the config.yaml that are not specified here. (optional)"
}

variable "dcos_custom_checks" {
  default     = ""
  description = "Custom installation checks that are added to the default check configuration process. (optional)"
}

variable "dcos_dns_bind_ip_blacklist" {
  default     = ""
  description = "A list of IP addresses that DC/OS DNS resolvers cannot bind to. (optional)"
}

variable "dcos_enable_gpu_isolation" {
  default     = ""
  description = "Indicates whether to enable GPU support in DC/OS. (optional)"
}

variable "dcos_fault_domain_detect_contents" {
  default = ""

  description = "[Enterprise DC/OS] fault domain script contents. Optional but required if no fault-domain-detect script present."
}

variable "dcos_fault_domain_enabled" {
  default     = ""
  description = "[Enterprise DC/OS] used to control if fault domain is enabled"
}

variable "dcos_gpus_are_scarce" {
  default     = ""
  description = "Indicates whether to treat GPUs as a scarce resource in the cluster. (optional)"
}

variable "dcos_l4lb_enable_ipv6" {
  default     = ""
  description = "A boolean that indicates if layer 4 load balancing is available for IPv6 networks. (optional)"
}

variable "dcos_license_key_contents" {
  default     = ""
  description = "[Enterprise DC/OS] used to privide the license key of DC/OS for Enterprise Edition. Optional if license.txt is present on bootstrap node."
}

variable "dcos_mesos_container_log_sink" {
  default = ""

  description = "The log manager for containers (tasks). The options are to send logs to: 'journald', 'logrotate', 'journald+logrotate'. (optional)"
}

variable "dcos_mesos_dns_set_truncate_bit" {
  default     = ""
  description = "Indicates whether to set the truncate bit if the response is too large to fit in a single packet. (optional)"
}

variable "dcos_mesos_max_completed_tasks_per_framework" {
  default     = ""
  description = "The number of completed tasks for each framework that the Mesos master will retain in memory. (optional)"
}

variable "dcos_ucr_default_bridge_subnet" {
  default     = ""
  description = "IPv4 subnet allocated to the mesos-bridge CNI network for UCR bridge-mode networking. (optional)"
}

variable "dcos_superuser_username" {
  default     = ""
  description = "[Enterprise DC/OS] set the superuser username (recommended)"
}

variable "dcos_telemetry_enabled" {
  default     = ""
  description = "change the telemetry option (optional)"
}

variable "dcos_zk_super_credentials" {
  default     = ""
  description = "[Enterprise DC/OS] set the zk super credentials (recommended)"
}

variable "dcos_zk_master_credentials" {
  default     = ""
  description = "[Enterprise DC/OS] set the ZooKeeper master credentials (recommended)"
}

variable "dcos_zk_agent_credentials" {
  default     = ""
  description = "[Enterprise DC/OS] set the ZooKeeper agent credentials (recommended)"
}

variable "dcos_overlay_enable" {
  default     = ""
  description = "Enable to disable overlay (optional)"
}

variable "dcos_overlay_config_attempts" {
  default     = ""
  description = "Specifies how many failed configuration attempts are allowed before the overlay configuration modules stop trying to configure an virtual network. (optional)"
}

variable "dcos_overlay_mtu" {
  default     = ""
  description = "The maximum transmission unit (MTU) of the Virtual Ethernet (vEth) on the containers that are launched on the overlay. (optional)"
}

variable "dcos_overlay_network" {
  default     = ""
  description = "This group of parameters define an virtual network for DC/OS. (optional)"
}

variable "dcos_dns_search" {
  default     = ""
  description = "A space-separated list of domains that are tried when an unqualified domain is entered. (optional)"
}

variable "dcos_dns_forward_zones" {
  default     = ""
  description = "Allow to forward DNS to certain domain requests to specific server. The [following syntax](https://github.com/dcos/dcos-docs/blob/master/1.10/installing/custom/configuration/configuration-parameters.md#dns_forward_zones) must be used in combination with [Terraform string heredoc](https://www.terraform.io/docs/configuration/variables.html#strings). (optional) (:warning: DC/OS 1.10+)"
}

variable "dcos_master_dns_bindall" {
  default     = ""
  description = "Indicates whether the master DNS port is open. (optional)"
}

variable "dcos_use_proxy" {
  default     = ""
  description = "to enable use of proxy for internal routing (optional)"
}

variable "dcos_http_proxy" {
  default     = ""
  description = "the http proxy (optional)"
}

variable "dcos_https_proxy" {
  default     = ""
  description = "the https proxy (optional)"
}

variable "dcos_no_proxy" {
  default     = ""
  description = " A YAML nested list (-) of addresses to exclude from the proxy. (optional)"
}

variable "dcos_check_time" {
  default     = ""
  description = "check if Network Time Protocol (NTP) is enabled during DC/OS startup. (optional)"
}

variable "dcos_docker_remove_delay" {
  default     = ""
  description = "The amount of time to wait before removing stale Docker images stored on the agent nodes and the Docker image generated by the installer. (optional)"
}

variable "dcos_audit_logging" {
  default     = ""
  description = "[Enterprise DC/OS] enable security decisions are logged for Mesos, Marathon, and Jobs. (optional)"
}

variable "dcos_gc_delay" {
  default     = ""
  description = "The maximum amount of time to wait before cleaning up the executor directories (optional)"
}

variable "dcos_log_directory" {
  default     = ""
  description = "The path to the installer host logs from the SSH processes. (optional)"
}

variable "dcos_process_timeout" {
  default     = ""
  description = "The allowable amount of time, in seconds, for an action to begin after the process forks. (optional)"
}

variable "dcos_cluster_docker_credentials" {
  default     = ""
  description = "The dictionary of Docker credentials to pass. (optional)"
}

variable "dcos_cluster_docker_credentials_dcos_owned" {
  default     = ""
  description = "Indicates whether to store the credentials file in /opt/mesosphere or /etc/mesosphere/docker_credentials. A sysadmin cannot edit /opt/mesosphere directly (optional)"
}

variable "dcos_cluster_docker_credentials_write_to_etc" {
  default     = ""
  description = "Indicates whether to write a cluster credentials file. (optional)"
}

variable "dcos_cluster_docker_credentials_enabled" {
  default     = ""
  description = "Indicates whether to pass the Mesos --docker_config option to Mesos. (optional)"
}

variable "dcos_master_list" {
  default     = ""
  description = "statically set your master nodes (not recommended but required with exhibitor_storage_backend set to static. Use aws_s3 or azure instead, that way you can replace masters in the cloud.)"
}

variable "dcos_public_agent_list" {
  default     = ""
  description = "statically set your public agents (not recommended)"
}

variable "dcos_previous_version" {
  default     = ""
  description = "DC/OS 1.9+ requires users to set this value to ensure users know the version. Terraform helps populate this value, but users can override it here. (recommended)"
}

variable "dcos_previous_version_master_index" {
  default     = "0"
  description = "Used to track the index of master for quering the previous DC/OS version during upgrading. (optional) applicable: 1.9+"
}

variable "dcos_agent_list" {
  default     = ""
  description = "used to list the agents in the config.yaml (optional)"
}

variable "dcos_bootstrap_port" {
  default     = "80"
  description = "used to specify the port of the bootstrap url"
}

variable "dcos_ip_detect_public_filename" {
  default     = "genconf/ip-detect-public"
  description = "statically set your detect-ip-public path"
}

variable "dcos_ip_detect_public_contents" {
  default = ""

  description = " Allows DC/OS to be aware of your publicly routeable address for ease of use (recommended)"
}

variable "dcos_ip_detect_contents" {
  default = ""

  description = "Allows DC/OS to detect your private address. Use this to pass this as an input to the module rather than a file in side your bootstrap node. (recommended)"
}

variable "dcos_rexray_config" {
  default     = ""
  description = "The REX-Ray configuration method for enabling external persistent volumes in Marathon. (optional)"
}

variable "dcos_cluster_docker_registry_url" {
  default     = ""
  description = "The custom URL that Mesos uses to pull Docker images from. If set, it will configure the Mesos’ --docker_registry flag to the specified URL. (optional)"
}

variable "custom_dcos_download_path" {
  default     = ""
  description = "insert location of dcos installer script (optional)"
}

variable "dcos_cluster_docker_registry_enabled" {
  default = ""
}

variable "dcos_enable_docker_gc" {
  default     = ""
  description = "Indicates whether to run the docker-gc script, a simple Docker container and image garbage collection script, once every hour to clean up stray Docker containers. (optional)"
}

variable "dcos_staged_package_storage_uri" {
  default     = ""
  description = "Where to temporarily store DC/OS packages while they are being added. (optional)"
}

variable "dcos_package_storage_uri" {
  default     = ""
  description = "Where to permanently store DC/OS packages. The value must be a file URL. (optional)"
}

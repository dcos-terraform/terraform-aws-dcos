---
layout: layout.pug
excerpt: Guide for DC/OS on AWS using the Universal Installer with Replaceable Masters 
title: DC/OS on AWS using the Universal Installer with Replaceable Masters 
navigationTitle: AWS Terraform with Replaceable Masters
menuWeight: 0
---

<p class="message--warning"><strong>DISCLAIMER: </strong>This installation
method is officially supported by Mesosphere and is used for fast demos and
proofs of concept. The use cases for production in use are being evaluated.
Upgrades are supported using this installation method.</p>


This guide will help users deploy DC/OS on AWS with Replaceable Masters feature enabled. This is a more advanced feature. For begginers and more novice users, please see the [Quick Start Guide](./README.md).

This feature allows for users to store exhibitor backend on S3 and place Master nodes behind a LB in order to keep from having to use a static master list. *On platforms like AWS where internal IPs are allocated dynamically, you should not use a static master list. If a master instance were to terminate for any reason, it could lead to cluster instability. It is recommended to use aws_s3 for the exhibitor storage backend since we can rely on s3 to manage quorum size when the master nodes are unavailable.* We'll walk you through step-by-step on how to:

1) Create an Enterprise DC/OS Cluster on AWS with Replaceable Masters enabled
2) Destroy (Taint) resources that will aide in replacing a Master Node
3) Successfully replace a Master Node
4) Bring your Terraform State back up-to-date

### A few notes before we begin:
    
- Please see more information regarding ["Replaceable Master Nodes"](https://docs.mesosphere.com/1.12/administering-clusters/replacing-a-master-node/#master-discovery-master-http-loadbalancer) for DC/OS. 

- Also see configuration reference for [`master_discovery`](https://docs.mesosphere.com/1.12/installing/production/advanced-configuration/configuration-reference/#master-discovery-required) and [`exhibitor_storage_backend`](https://docs.mesosphere.com/1.12/installing/production/advanced-configuration/configuration-reference/#exhibitor-storage-backend) for more details.

- We will automatically be creating the appropriate S3 bucket based on value for `dcos_s3_bucket`. This currently will need to be manually deleted by the user once the cluster is destroyed.

- We will be automatically creating appropriate IAM profiles for the Masters to provide access to S3 instead of using Secret and Access keys.

# Prerequisites:
Terraform, AWS cloud credentials, SSH keys

## Installing Terraform.
If you're on a Mac environment with [homebrew](https://brew.sh/) installed, simply run the following command:
```bash
brew install terraform
```

Once this command completes, you should be able to run the following command and see output consistent with the version of Terraform you have installed:
```bash
$ terraform version
Terraform v0.11.8
```

For help installing Terraform on a different OS, please see [here](https://www.terraform.io/downloads.html):

## Ensure you have your AWS Cloud Credentials Properly Set up
Please follow the AWS guide [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) how to setup your credentials.

## Add your SSH keys to your ssh agent:

Terraform requires SSH access to the instances you launch as part of your DC/OS cluster. As such, we need to make sure that the SSH key used to SSH to these instances is added to your `ssh-agent`, prior to running `terraform`.

If you need help on creating an SSH key-pair for AWS prior to running the command below, please follow the instructions [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

Otherwise, just run the following command to add your key to the `ssh-agent`:

```bash
ssh-add <path_to_your_private_aws_ssh_key>
```

For Example:
```bash
ssh-add ~/.ssh/aws-id-rsa
```

## Enterprise Edition

DC/OS Enterprise Edition also requires a valid license key provided by Mesosphere that we will pass into our `main.tf` as `dcos_license_key_contents`. For this guide we are going to use the default superuser and password to login:

Username: `bootstrapuser`
Password: `deleteme`

Please note that this should *NOT* be used in a Production environment and you will need generate a password hash.

# Creating a Cluster

1) Let's stary by creating and local folder and cd'ing into. This folder will be used as the staging ground for downloading all required Terraform modules and holding the configuration for the cluster you are about to create. 
```
mkdir dynamic-masters && cd dynamic-masters  
```

2) Once that is done, copy and paste the example code below into a new file and save it as `main.tf` in the newly created folder.

This example codes tells Terrfaorm to create a DC/OS Enterprise 1.12.0 cluster on AWS with:
- 3 Masters
- 2 Private Agents
- 1 Public Agent
- With Replaceable Masters enabled

The following lines are required to enable Replaceable Masters:

Example:
```
  dcos_exhibitor_explicit_keys   = "false"
  dcos_exhibitor_storage_backend = "aws_s3"
  dcos_s3_prefix                 = "exhibitor"
  dcos_s3_bucket                 = "ext-exhibitor-test"
  dcos_aws_region                = "us-east-1" 
  dcos_master_discovery          = "master_http_loadbalancer"
  dcos_exhibitor_address         = "${module.dcos.masters-internal-loadbalancer}" #This is the LB we create with the wrapper script
  dcos_num_masters               = "3"
```

It also specifies that the list of `masters-ips`, the `cluster-address`, and the address of the `public-agents-loadbalancer` should be printed out after cluster creation is complete.

It also specifies that the following output should be printed once cluster creation is complete:
- `master-ips` - A list of Your DC/OS Master Nodes.
- `cluster-address` - The URL you use to access DC/OS UI after the cluster is setup.
- `public-agent-loadbalancer` - The URL of your Public routable services.

```hcl
provider "aws" {
  region = "us-east-1"
}

data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.1.0"

  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]
  num_masters         = "3"
  num_private_agents  = "2"
  num_public_agents   = "1"

  dcos_variant              = "ee"
  dcos_version              = "1.12.0"
  dcos_license_key_contents = "${file("./license.txt")}"
  dcos_install_mode         = "${var.dcos_install_mode}"

  # DC/OS Config values that must be set
  dcos_exhibitor_explicit_keys   = "false"
  dcos_exhibitor_storage_backend = "aws_s3"
  dcos_s3_prefix                 = "exhibitor"
  dcos_s3_bucket                 = "ext-exhibitor"
  dcos_aws_region                = "us-east-1" 
  dcos_master_discovery          = "master_http_loadbalancer"
  dcos_exhibitor_address         = "${module.dcos.masters-internal-loadbalancer}"
  dcos_num_masters               = "3"  
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
```
For simplicity, all variables in this example have been hard-coded.  If you want to change the cluster name or vary the number of masters/agents, feel free to adjust the values directly in this `main.tf`.

You can find additional input variables and their descriptions [here](http://registry.terraform.io/modules/dcos-terraform/dcos/aws/).

3) Create a file called `license.txt` with your Enterprise license key in your current directory.
```
echo 'YOUR-DCOS-LICENSE-asbad-1343x' > license.txt
```

4) Issue the following Terraform Commands to have Terraform initialize, plan and build your cluster.
```
terraform init 
terraform plan -out plan.out 
terraform apply plan.out
```

You will then be able to go to the DC/OS UI by pasting the output of the `cluster-address` into your bowser.  

*NOTE: This method takes a bit longer than normal to become available. Exhibitor and Mesos Masters will have to restart several times before they are ready. Typically takes an additional 5-6 minutes before UI is ready.*

# Replace a Master Node
1) Next we will need to Taint a Master Node's resources (Master 1 in this case). This will mark resources to be destroyed and recreated. Currently this will need to be done in 2 separate steps: The Instance and Prereqs resource and then the DC/OS Master install resource. *THIS IS STILL A WORK IN PROGRESS AND WILL BE SIMPLIFIED IN THE FUTURE.* This will handle all the necessary steps to get remove the olde Master node from the cluster and then add the new one in its place. Commands have been provided for the user to simply copy and paste. 

The following shows how we perform this for the Master 1 node. 

Pro Tip, you can use the following one-liner to help taint resources. You can use this to taint any resources from the output of:

```
terraform state list
```

```
# Taint Master 1 Instance and Prereqs. 
echo module.dcos.module.dcos-infrastructure.module.dcos-master-instances.module.dcos-master-instances.aws_instance.instance[0] | sed 's/module\.//g;s/\(.*\)\.\(.*\.\)/\1\ \2/;s/]//g;s/\[/\./g' | xargs terraform taint -module

echo module.dcos.module.dcos-infrastructure.module.dcos-master-instances.module.dcos-master-instances.null_resource.instance-prereq[0] | sed 's/module\.//g;s/\(.*\)\.\(.*\.\)/\1\ \2/;s/]//g;s/\[/\./g' | xargs terraform taint -module
```

Have Terraform destroy and redeploy the tainted Master Node.
```
terraform plan -out plan.out 
terraform apply plan.out
```

*This will destroy the Master node, create a new one and then reinstall the prereqs necessary to install DC/OS. You will eventually see the old Master node go unhealthy and then disappear from the DC/OS UI as well as lose connection in Exhibitor UI.*

2) Once the new Master is created and the DC/OS prereqs have completed, you will need to taint the Master's DC/OS install resource to have DC/OS installed. This part is tricky currently due to the way that we currently provision and upgrade our DC/OS clusters with the DC/OS Install module. Since each Master Node is installed one at a time and then the Agent Nodes simaltaneously, certain parts of the process will fail due to DC/OS already being installed on the node. This is fine and when this happens, you can `untaint` the current resource to move on. 

Example:
```
module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 (remote-exec): Checking if DC/OS is already installed: FAIL (Currently installed)

module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 (remote-exec): Found an existing DC/OS installation. To reinstall DC/OS on this this machine you must
module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 (remote-exec): first uninstall DC/OS then run dcos_install.sh. To uninstall DC/OS, follow the product
module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 (remote-exec): documentation provided with DC/OS.


Error: Error applying plan:

1 error(s) occurred:

* module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1: error executing "/tmp/terraform_948165397.sh": Process exited with status 1

Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.


####### You can simply untaint the resource and move on! ######

echo module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 | sed 's/module\.//g;s/\(.*\)\.\(.*\.\)/\1\ \2/;s/]//g;s/\[/\./g'| xargs terraform untaint -module
```

Taint Master 1 master install resource and begin from there:
```
echo module.dcos.module.dcos-install.module.dcos-masters-install.null_resource.master1 | sed 's/module\.//g;s/\(.*\)\.\(.*\.\)/\1\ \2/;s/]//g;s/\[/\./g'| xargs terraform taint -module
```

Deploy new changes to Terraform. 
```
terraform plan -out plan.out 
terraform apply plan.out
```

As mentioned, if the install fails due to DC/OS already being installed, just **untaint** that resource and move on.

**The Fun Part!** Once you find the correct Master to run the install on, you can actually watch DC/OS Replace the older Master Node with the new! During the Master install on the new master, login and tail the journal for the `dcos-exhibitor` service (It might take a sec for this service to appear depending on where the install process is).

```
sudo journalctl -fu dcos-exhibitor

...
...
...

# Eventually you will see a message like:
Dec 17 16:45:59 master-4-dcos-test1d38gb start_exhibitor.py[3414]: INFO  com.netflix.exhibitor.core.activity.ActivityLog  Automatic Instance Management will change the server list: 1:172.31.0.8,2:172.31.0.9,3:172.31.0.7 ==> 1:172.31.0.8,3:172.31.0.7,4:172.31.0.11 [ActivityQueue-0]

...
...
...
```

Exhibitor is replacing the old instance with the new. Once you see exhibitor begin accepting connections, tail the journal of the `dcos-mesos-master` service and you will begin to see syncing ZK.

```
sudo journalctl -fu dcos-mesos-master

...
...
...

# Eventually you will see messages like:
Dec 17 16:48:19 master-4-dcos-test1d38gb systemd[1]: Starting Mesos Master: distributed systems kernel...
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7818]: PING ready.spartan (127.0.0.1) 56(84) bytes of data.
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7818]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.024 ms
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7818]: --- ready.spartan ping statistics ---
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7818]: 1 packets transmitted, 1 received, 0% packet loss, time 0ms
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7818]: rtt min/avg/max/mdev = 0.024/0.024/0.024/0.000 ms
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/all/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/default/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/docker0/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/dummy0/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/eth0/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/lo/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/minuteman/rp_filter: 2
Dec 17 16:48:19 master-4-dcos-test1d38gb mesos-master[7821]: /proc/sys/net/ipv4/conf/spartan/rp_filter: 2
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Clearing proxy environment variables
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Setting ENABLE_CHECK_TIME to true
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: Checking whether time is synchronized using the kernel adjtimex API.
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: Time can be synchronized via most popular mechanisms (ntpd, chrony, systemd-timesyncd, etc.)
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: Time is in sync!
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] PID 5578 has command line [b'/opt/mesosphere/active/java/usr/java/bin/java', b'-Dzookeeper.log.dir=/var/lib/dcos/exhibitor/zookeeper', b'-Dzookeeper.root.logger=INFO,CONSOLE', b'-cp', b'/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../build/classes:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../build/lib/*.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/slf4j-log4j12-1.7.25.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/slf4j-api-1.7.25.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/netty-3.10.6.Final.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/log4j-systemd-journal-appender-1.3.2.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/log4j-jna-4.2.2.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/log4j-1.2.17.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/jline-0.9.94.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../lib/audience-annotations-0.5.0.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../zookeeper-3.4.13.jar:/opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../src/java/lib/*.jar:/var/lib/dcos/exhibitor/conf:', b'-Djna.tmpdir=/var/lib/dcos/exhibitor/tmp', b'-Dzookeeper.DigestAuthenticationProvider.superDigest=super:lK75jTNcA+U9vtVEw5vB51mj/w4=', b'-Dcom.sun.management.jmxremote', b'-Dcom.sun.management.jmxremote.local.only=false', b'org.apache.zookeeper.server.quorum.QuorumPeerMain', b'/var/lib/dcos/exhibitor/conf/zoo.cfg']
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] PID file hasn't been modified. ZK still seems to be at that PID.
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Shortcut succeeeded, assuming local zk is in good config state, not waiting for quorum.
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-diagnostics
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-checks
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-backup
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-cluster-linker
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-ca
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/dcos-iam-ldap-sync
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/history-service
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/marathon
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/mesos
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/mesos-dns
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/metronome
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/signal-service
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/etc/telegraf
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/pki/CA/certs
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/pki/CA/private
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/pki/tls/certs
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/pki/tls/private
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Make sure directory exists: /run/dcos/pki/cockroach
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Using super credentials for Zookeeper
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Connecting to 127.0.0.1:2181
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Zookeeper connection established, state: CONNECTED
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [DEBUG] bootstrapping dcos-mesos-master
Dec 17 16:48:21 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Initializing ACLs for znode /
...
...
...
Dec 17 16:48:26 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Reaching consensus about znode /dcos/master/secrets/zk/dcos_backup_master
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Consensus znode /dcos/master/secrets/zk/dcos_backup_master already exists
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] ensure_zk_path(/dcos/master/secrets/zk, [ACL(perms=1, acl_list=['READ'], id=Id(scheme='digest', id='dcos-master:fMkMgKtR6Fl+wYKfdJg75Th6Vsc='))])
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Reaching consensus about znode /dcos/master/secrets/zk/dcos_bouncer
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Consensus znode /dcos/master/secrets/zk/dcos_bouncer already exists
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] ensure_zk_path(/dcos/master/secrets/zk, [ACL(perms=1, acl_list=['READ'], id=Id(scheme='digest', id='dcos-master:fMkMgKtR6Fl+wYKfdJg75Th6Vsc='))])
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Reaching consensus about znode /dcos/master/secrets/zk/dcos_cluster_linker
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Consensus znode /dcos/master/secrets/zk/dcos_cluster_linker already exists
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] ensure_zk_path(/dcos/master/secrets/zk, [ACL(perms=1, acl_list=['READ'], id=Id(scheme='digest', id='dcos-master:fMkMgKtR6Fl+wYKfdJg75Th6Vsc='))])
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Reaching consensus about znode /dcos/master/secrets/zk/dcos_cockroach
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] Consensus znode /dcos/master/secrets/zk/dcos_cockroach already exists
Dec 17 16:48:27 master-4-dcos-test1d38gb mesos-master[7839]: [INFO] ensure_zk_path(/dcos/master/secrets/zk, [ACL(perms=1, acl_list=['READ'], id=Id(scheme='digest', id='dcos-master:fMkMgKtR6Fl+wYKfdJg75Th6Vsc='))])
...
...
...
```

3) The Agent Node(s) install will fail as mentioned and you will need to untaint the resources to finally get your Terraform state back. You can use the following for loop to clean it up:
```
for i in `terraform state list | grep agents-install.null_resource` ; do echo $i | sed 's/module\.//g;s/\(.*\)\.\(.*\.\)/\1\ \2/;s/]//g;s/\[/\./g' | xargs terraform untaint -module ; done
```

At anytime, you can also check your see bucket/prefix and download the file and view its contents. See [example](../exhibitor-file.example).


# Deleting Your Cluster
If you ever decide you would like to destroy your cluster, simply run the following command and wait for it to complete:

```bash
terraform destroy
```

<p class="message--note"><strong>NOTE: </strong>Running this command will cause your entire cluster and all at its associated resources to be destroyed. Only run this command if you are absolutely sure you no longer need access to your cluster.</p>

You will be required to enter ‘yes’ to ensure you know what you are doing.
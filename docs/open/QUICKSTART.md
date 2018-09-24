# Quick Start Guide

If you’re new to Terraform and/or want to deploy DC/OS on AWS quickly and effortlessly - please follow this guide.  We’ll walk you through step-by-step on:


- Creating a DC/OS OSS Cluster
- Scaling the cluster
- Upgrading the cluster
- Deleting the cluster

# Prerequisites: 
Terraform, cloud credentials, and SSH keys:

## You’ll need Terraform.
If you're on a Mac environment with homebrew installed, run this command.
```bash
brew install terraform
```

For help installing Terraform on a different OS, see [here](https://www.terraform.io/downloads.html):


## Ensure AWS Default Region
Current Terraform AWS Provider requires that the default region variable be set. You can set the default region using the following command:
```bash
export AWS_DEFAULT_REGION="desired-aws-region"
```
Example:
```bash
export AWS_DEFAULT_REGION="us-east-1"
```

Ensure it is set:
```bash
> echo $AWS_DEFAULT_REGION
us-east-1
```

## Add your keys to your ssh agent:

```bash
ssh-add <path_to_your_private_ssh_key>
```


# Creating a Cluster

1) Let’s start by creating a local folder.

```bash
mkdir dcos-tf-aws-demo && cd dcos-tf-aws-demo 
```

2) Copy and paste the example code below into a new file and save it as `main.tf` in our folder.

The example code below creates a DC/OS OSS 1.11.4 cluster on AWS with:
- 1 Master
- 2 Private Agents
- 1 Public Agent

```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-open-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_variant = "open"
  
  
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
``` 

For simplicity and example purposes, our variables are hard-coded.  If you have a desired cluster name or amount of masters/agents, feel free to adjust the values directly in this `main.tf`. You can find additional input variables and their descriptions [here](http://registry.terraform.io/modules/dcos-terraform/dcos/aws/).

Note that you will get the following outputs from this `main.tf` once the cluster is built:
- ```master-ips``` - A list of Your DC/OS Master Nodes.
- ```cluster-address``` - This will be the URL you use to access DC/OS UI after the cluster is setup.
- ```public-agent-loadbalancer``` - This will be the URL of your Public routable services.


3) Next, let’s initialize our modules.  Make sure you’re in the dcos-tf-aws-demo folder with `main.tf`.  

```bash
terraform init
```

<p align=center>
<img src="../images/install/terraform-init.png" />
</p>


Every time you run terraform plan, the output will always detail the resources your plan will be adding, changing or destroying.  Since we are creating our DC/OS cluster for the very first time, our output tells us that our plan will result in adding 38 pieces of infrastructure/resources.

The next step is to get Terraform to build/deploy our plan.  Run the command below.

```bash
terraform apply
```

Once Terraform has completed applying our plan, you should see an output similar to the one below.  You can now enter in the URL output to access your DC/OS cluster in the browser of your choice (Chrome, Safari recommended).  

<p align=center>
<img src="../images/install/terraform-apply.png" />
</p>

And congratulations - you’re done!  In just 4 steps, you’ve successfully installed a DC/OS cluster on AWS!

<p align=center>
<img src="../images/install/dcos-login.png"
</p>

<p align=center>
<img src="../images/install/dcos-ui.png"
</p>

# Scaling Your Cluster
1) To scale the number of agents (private or public) in your cluster, simply increase the value set for the `num_private_agents` and/or `num_public_agents` in your `main.tf` file. In this example we are going to scale our cluster from 2 Private Agents to 3.


```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-open-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "3"
  num_public_agents  = "1"

  dcos_variant = "open"
  
  
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
```

2) Now that we’ve made changes to our `main.tf`, we need to re-run our new execution plan.  

There will be 3 resources added as a result of scaling up our cluster’s Private Agents (1 instance resource & 2 null resources which handle the DC/OS installation & prerequisites behind the scenes).

3) Now that our plan is set, just like before, let’s get Terraform to build/deploy it.

```bash
terraform apply
```

<p align=center>
<img src="../images/scale/terraform-apply.png" />
</p>

Once you see an output like the message above, check your DC/OS cluster.  

You should see now 4 total nodes connected like below via the DC/OS UI.

<p align=center>
<img src="../images/scale/node-count-4.png" />
</p>


# Upgrading Your Cluster
Next, let’s upgrade our cluster.

You can use DC/OS Terraform to not only install, but to maintain and upgrade your cluster to newer versions of DC/OS quickly and effortlessly.

Let’s go back to our `main.tf` and specify an additional parameter.  You can check the many parameters available for you to add in `main.tf` to get the most power out of DC/OS Terraform [here](http://registry.terraform.io/modules/dcos-terraform/dcos/aws/). In the meantime, we’ll just focus on one - `dcos_install_mode`.

Since we’re upgrading, we set this parameter to `upgrade`. 

1) Add additional line to `main.tf` to flag triggers for upgrade procedure. 

```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-open-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "3"
  num_public_agents  = "1"

  dcos_variant = "open"
  dcos_install_mode = "upgrade"
   
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
```


2) Now that our execution plan is set, just like before, let’s get Terraform to build/deploy it.

```bash
terraform apply
```

Once the apply is completed successfully, you can now verify that the cluster was upgraded via the DC/OS UI.

<p align=center>
<img src="../images/upgrade/cluster-details.png" />
</p>

3) Once your have upgraded your cluster successfully, you will either need to completely remove the line containing `dcos_install_mode` or change the value back to `install`. *Failing to do this will cause issues if or when trying to scale your cluster*.



# Deleting Your Cluster
If you’re done and would like to destroy your DC/OS cluster and its associated resources, simply run the following command:

```bash
terraform destroy 
```

You will be required to enter ‘yes’ to ensure you want to destroy your cluster.

<p align=center>
<img src="../images/destroy/terraform-destory.png" />
</p>

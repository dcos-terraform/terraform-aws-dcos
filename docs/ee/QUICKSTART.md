# Quick Start Guide

If you’re new to Terraform and/or want to deploy DC/OS on AWS quickly and effortlessly - please follow this guide.  We’ll walk you through step-by-step on:


- Creating a DC/OS EE Cluster
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

DC/OS Enterprise Edition also requires a valid license key provided by Mesosphere that we will pass into our `main.tf` as `dcos_license_key_contents`. You are also going to be required to generate a password hash (see next step below) that you will also pass to the in the `main.tf` to set the password for your desired superuser. 


# Generating Password Hash
For Enterprise Edition, you need to generate a password hash for the superuser account in the cluster. You can generate this hash downloading the installation script and running the following:

```bash
sudo bash dcos_generate_config.ee.sh --hash-password <superuser_password>
```

We are going to pass the generated value as the value for `dcos_superuser_password_hash` in our `main.tf`.

You can see more information on the Official DC/OS Docs site [here](https://docs.mesosphere.com/1.11/installing/production/deploying-dcos/installation/#set-up-a-super-user-password-enterprise).

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
- admin as the superuser username

```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-ee-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_variant = "ee"
  dcos_license_key_contents = "LICENSE_KEY_HERE"
  dcos_superuser_password_hash = "HASH_VALUE_GENERATED_FROM_ABOVE"
  dcos_superuser_username = "admin"
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

4) Next, we’ll run the execution plan and save this plan to a static file - in this case, `plan.out`. Writing our execution plan to a file allows for us to pass the execution plan to the apply and helps us guarantee accuracy of our plan. Note that this file is ONLY readable by Terraform.

```bash
terraform plan -out=plan.out
```

Afterwards, we should see a message like the one below, confirming that we have successfully saved to the `plan.out` file.  This file should appear in your dcos-tf-aws-demo folder alongside `main.tf`.

<p align=center>  
<img src="../images/install/terraform-plan.png" />
</p>

Every time you run terraform plan, the output will always detail the resources your plan will be adding, changing or destroying.  Since we are creating our DC/OS cluster for the very first time, our output tells us that our plan will result in adding 38 pieces of infrastructure/resources.

5) The next step is to get Terraform to build/deploy our plan.  Run the command below.

```bash
terraform apply plan.out
```

Once Terraform has completed applying our plan, you should see an output similar to the one below.  You can now enter the `cluster-address` output to access your DC/OS cluster in the browser of your choice (Chrome, Safari recommended).  

<p align=center>
<img src="../images/install/terraform-apply.png" />
</p>

And congratulations - you’re done!  In just 4 steps, you’ve successfully installed a DC/OS cluster on AWS!

You can now login with your superuser and password.

# Scaling Your Cluster
1) To scale the number of agents (private or public) in your cluster, simply increase the value set for the `num_private_agents` and/or `num_public_agents` in your `main.tf` file. In this example we are going to scale our cluster from 2 Private Agents to 3.


```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"

  cluster_name="my-ee-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "3"
  num_public_agents  = "1"

  dcos_variant = "ee"
  dcos_license_key_contents = "LICENSE_KEY_HERE"
  dcos_superuser_password_hash = "HASH_VALUE_GENERATED_FROM_ABOVE"
  dcos_superuser_username = "admin"
  
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

```bash
terraform plan -out=plan.out
``` 

Doing this helps us to ensure that our state is stable and to confirm that we will only be creating the resources necessary to scale our Private Agents to the desired number.

<p align=center>
<img src="../images/scale/terraform-plan.png" />
</p>

You should see a message similar to above.  There will be 3 resources added as a result of scaling up our cluster’s Private Agents (1 instance resource & 2 null resources which handle the DC/OS installation & prerequisites behind the scenes).

3) Now that our plan is set, just like before, let’s get Terraform to build/deploy it.

```bash
terraform apply plan.out
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

  cluster_name="my-ee-dcos-cluster"
  ssh_public_key_file="~/.ssh/id_rsa.pub"

  num_masters        = "1"
  num_private_agents = "3"
  num_public_agents  = "1"

  dcos_variant = "ee"
  dcos_license_key_contents = "LICENSE_KEY_HERE"
  dcos_superuser_password_hash = "HASH_VALUE_GENERATED_FROM_ABOVE"
  dcos_superuser_username = "admin"
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

2) Let’s run our execution plan.  

```bash
terraform plan -out=plan.out
```

You should see an output like below.

<p align=center>
<img src="../images/upgrade/terraform-plan.png" />
</p>

If you are interested in learning more about the upgrade procedure that Terraform performs, please see the official [DC/OS Upgrade documentation](https://docs.mesosphere.com/1.11/installing/production/upgrading/). 


3) Now that our execution plan is set, just like before, let’s get Terraform to build/deploy it.

```bash
terraform apply plan.out
```

Once the apply is completed successfully, you can now verify that the cluster was upgraded via the DC/OS UI.

<p align=center>
<img src="../images/upgrade/cluster-details.png" />
</p>

4) Once your have upgraded your cluster successfully, you will either need to completely remove the line containing `dcos_install_mode` or change the value back to `install`. *Failing to do this will cause issues if or when trying to scale your cluster*.



# Deleting Your Cluster
If you’re done and would like to destroy your DC/OS cluster and its associated resources, simply run the following command:

```bash
terraform destroy 
```

You will be required to enter ‘yes’ to ensure you want to destroy your cluster.

<p align=center>
<img src="../images/destroy/terraform-destory.png" />
</p>
# DC/OS Open Source simple cluster
In this example we spawn a simple cluster with just one master, two agents and one public agent.

# `main.tf`
Just do an copy of `main.tf` in a local folder and `cd` into it.

# `cluster.tfvars`
For this cluster we need to set your ssh public key..

if you already have a ssh key. Just read the public key content and assign it to the terraform variable. Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

```bash
# or similar depending on your environment
echo "ssh_public_key=\"$(cat ~/.ssh/id_rsa.pub)\"" >> cluster.tfvars
# lets set the clustername
echo "cluster_name=\"my-open-dcos-cluster\"" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
echo "tags={Owner = \"$(whoami)\", Expires = \"2h\"}" >> cluster.tfvars
```

# `terraform init`
Doing terraform init lets terraform download all the needed modules to spawn DC/OS Cluster on AWS

# terraform plan
We expect your aws environment is properly setup. Check it with issuing `aws sts get-caller-identity`.

We now create the terraform plan which gets applied later on.
```bash
terraform plan --var-file cluster.tfvars -out=cluster.plan
```

# terraform apply
Now we're applying our plan

```bash
terraform apply "cluster.plan"
```
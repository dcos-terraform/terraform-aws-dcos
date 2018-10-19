# DC/OS Open Source from Pull-Request
In this example we spawn a development cluster from a Pull-Request build.

# [`main.tf`](./main.tf?raw=1)
Just do an copy of [`main.tf`](./main.tf?raw=1) in a local folder and `cd` into it.

# `cluster.tfvars`
For this cluster, we need to set your ssh public key. If you already have a ssh key, just assign the path to the key to the terraform variable.

Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

```bash
# or similar depending on your environment
echo "ssh_public_key_file=\"~/.ssh/id_rsa.pub\"" >> cluster.tfvars
# lets set the clustername
echo "cluster_name=\"my-ee-cluster\"" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
echo "tags={owner = \"$(whoami)\", expiration = \"2h\"}" >> cluster.tfvars
# we have to explicitly set the version.
echo "dcos_version=\"1.10.8\""
# now we have to provider the link to dcos_generate_config.sh
echo "custom_dcos_download_path=\"https://downloads.dcos.io/dcos/testing/pull/3303/dcos_generate_config.sh\""
```

## admin_ips (optional)
For accessing your dcos-masters we only allow access for certain IPs. By adding a lists `admin_ips` you could control this. *If you do now specify `admin_ips` we try to detect your current public IP and use this address. These addresses have to be written in CIDR format. So for single addresses use `1.2.3.4/32`

### allow your company net

```bash
echo "admin_ips=[\"1.2.3.0/24\", \"3.2.1.0/24\"]" >> cluster.tfvars
```

### allow all (be sure what you're doing)
```bash
echo "admin_ips=[\"0.0.0.0/0\"]" >> cluster.tfvars
```

# AWS
DC/OS Terraform is using the [AWS Default Credentials Chain](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html). To change REGION or Account you can use the [AWS Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html)

## Change region (optional)
Changing the default region ( the one you specified with `aws configure` )

```bash
# Change the default region to us-east-1
$ export AWS_DEFAULT_REGION="us-east-1" 
```

## Change profile (optional)
If you want to use a second profile for deploying you can use `AWS_PROFILE` variable

```bash
$ export AWS_PROFILE=my-second-profile
```

# terraform init
Doing terraform init lets terraform download all the needed modules to spawn DC/OS Cluster on AWS

```bash
$ terraform init
```

# terraform plan
We expect your aws environment is properly setup. Check it with issuing `aws sts get-caller-identity`.

We now create the terraform plan which gets applied later on.
```bash
$ terraform plan --var-file cluster.tfvars -out=cluster.plan
```

# terraform apply
Now we're applying our plan

```bash
$ terraform apply "cluster.plan"
```

in the output section you will find the hostname of your cluster. With this hostname you'll be able to access the cluster.

# terraform destroy
If you want to destroy your cluster again use

```bash
$ terraform destroy --var-file cluster.tfvars
```

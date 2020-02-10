# DC/OS Open Source simple cluster
In this example we spawn a simple cluster with just one master, two agents and one public agent.

# [`main.tf`](./main.tf?raw=1)
Just do an copy of [`main.tf`](./main.tf?raw=1) in a local folder and `cd` into it.

# `cluster.tfvars`
For this cluster, we need to set your ssh public key. If you already have a ssh key, just assign the path to the key to the terraform variable.

Also you should set a cluster name. It gets tagged with this name so you can easily identify the nodes of your cluster.

```bash
# or similar depending on your environment
echo "ssh_public_key_file=\"~/.ssh/id_rsa.pub\"" >> cluster.tfvars
# lets set the clustername
echo "cluster_name=\"my-open-dcos-cluster\"" >> cluster.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
echo "tags={owner = \"$(whoami)\", expiration = \"2h\"}" >> cluster.tfvars
```

## calico configurations

### configure Calico network CIDR
```bash
# calico network CIDR should not overlap the subnet used for infrastructure network.
echo "dcos_calico_network_cidr=\"192.168.0.0/16\"" >> cluster.tfvars
echo "subnet_range=\"172.16.0.0/16\"" >> cluster.tfvars
```

### overlay networking option

To enable VXLAN mode is enabled, execute
```bash
# VXLAN mode is also enabled by default
echo "dcos_calico_vxlan_enabled=\"true\"" >> cluster.tfvars
```

Or, to enable IP in IP mode instead, execute
```bash
echo "dcos_calico_vxlan_enabled=\"false\"" >> cluster.tfvars
```

### Determine MTU size

default Calico interfaces MTU size is based on the ordinary Ethernet MTU, e.g. 1500. Suppose VXLAN mode is used, and the cluster will be deployed on AWS instances supporting Jumbo frames(9001 MTU), the MUT size for different network interfaces should be, in VXLAN mode,
```bash
echo "dcos_calico_veth_mtu=\"8951\"" >> cluster.tfvars
echo "dcos_calico_vxlan_mtu=\"9001\"" >> cluster.tfvars
```
Or in IP in IP mode,
```bash
echo "dcos_calico_veth_mtu=\"8981\"" >> cluster.tfvars
echo "dcos_calico_ipinip_mtu=\"9001\"" >> cluster.tfvars
```

## admin_ips (optional)
For accessing your dcos-masters we only allow access for certain IPs. By adding a lists `admin_ips` you could control this. If you do now specify `admin_ips` we try to detect your current public IP and use this address. These addresses have to be written in CIDR format. So for single addresses use `1.2.3.4/32`

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

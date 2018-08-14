DC/OS on AWS
============
Creates a DC/OS Cluster on AWS

EXAMPLE
-------

```hcl
module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.1"

  cluster_name = "mydcoscluster"
  ssh_public_key = "ssh-rsa ..."

  num_masters = "3"
  num_private_agents = "2"
  num_public_agents = "1"

  dcos_type = "open"
  # dcos_license_key_contents = ""
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_key_name | Specify the aws ssh key to use. We assume its already loaded in your SSH agent. Set ssh_public_key to none | string | `` | no |
| cluster_name | Name of the DC/OS cluster | string | `dcos-example` | no |
| dcos_license_key_contents | [Enterprise DC/OS] used to privide the license key of DC/OS for Enterprise Edition. Optional if license.txt is present on bootstrap node. | string | `` | no |
| dcos_type |  | string | `open` | no |
| dcos_version | Specify the availability zones to be used | string | `1.11.3` | no |
| num_masters | Specify the amount of masters. For redundancy you should have at least 3 | string | `3` | no |
| num_private_agents | Specify the amount of private agents. These agents will provide your main resources | string | `2` | no |
| num_public_agents | Specify the amount of public agents. These agents will host marathon-lb and edgelb | string | `1` | no |
| ssh_public_key | Specify a SSH public key in authorized keys format (e.g. "ssh-rsa ..") to be used with the instances. Make sure you added this key to your ssh-agent | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| masters-loadbalancer | This is the load balancer address to access the DC/OS UI |


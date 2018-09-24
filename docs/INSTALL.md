# Install DC/OS on AWS

## Prerequisites
- [Terraform 0.11.x](https://www.terraform.io/downloads.html)
- [AWS SSH Keys](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- [AWS IAM Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

## Getting Started

1. [Create installer directory](#create-installer-directory)
2. [Initialize Terraform](#initialize-terraform)
3. [Configure AWS keys](#configure-aws-ssh-keys)
4. [Configure and deploy DC/OS](#configure-and-deploy-dcos)


## Create Installer Directory

Make your directory where Terraform will download and place your Terraform infrastructure files.

```bash
mkdir dcos-installer
cd dcos-installer
```

## Initialize Terraform

Run this command below to have Terraform initialized from this repository. There is **no git clone of this repo required** as Terraform performs this for you.

```
terraform init -from-module github.com/dcos-terraform/terraform-aws-dcos
```

## `cluster_profile.tfvars`

```bash
# or similar depending on your environment
echo "ssh_public_key_file=\"~/.ssh/id_rsa.pub\"" >> cluster_profile.tfvars
# lets set the clustername
echo "cluster_name=\"my-open-dcos-cluster\"" >> cluster_profile.tfvars
# we at mesosphere have to tag our instances with an owner and an expire date.
echo "tags={owner = \"$(whoami)\", expiration = \"2h\"}" >> cluster_profile.tfvars
```

## Configure AWS SSH Keys

You can either upload your existing SSH keys or use an SSH key already created on AWS. 

* **Upload existing key**:
    To upload your own key not stored on AWS, read [how to import your own key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws)  
    
* **Create new key**:
    To create a new key via AWS, read [how to create a key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) 
    
When complete, retrieve the key pair name and ensure that it matches the `ssh_key_name` in your cluster_profile.tfvars. 

**Note**: The cluster_profile.tfvars always takes precedence over the [variables.tf](../variables.tf) and is **best practice** for any variable changes that are specific to your cluster. 

When you have your key available, you can use ssh-add.

```bash
ssh-add ~/.ssh/path_to_you_key.pem
```

**Note**: When using an SSH agent it is best to add the command above to your `~/.bash_profile`. Next time your terminal gets reopened, it will reload your keys automatically.

## Configure AWS IAM Keys

You will need your AWS `aws_access_key_id` and `aws_secret_access_key`. If you don't have one yet, you can get them from the [AWS access keys documentation](
http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html). 

When you get them, you can install it in your home directory. The default location is `$HOME/.aws/credentials` on Linux and macOS, or `"%USERPROFILE%\.aws\credentials"` for Windows users.

Here is an example of the output when you're done:

```bash
$ cat ~/.aws/credentials
[default]
aws_access_key_id = ACHEHS71DG712w7EXAMPLE
aws_secret_access_key = /R8SHF+SHFJaerSKE83awf4ASyrF83sa471DHSEXAMPLE
```

**Note**: `[default]` is the name of the `aws_profile`. You may select a different profile to use in Terraform by adding it to your `cluster_profile.tfvars` as `aws_profile = "<INSERT_CREDENTIAL_PROFILE_NAME_HERE>"`.

## Configure And Deploy DC/OS

### Deploying with Custom Configuration

The default variables are tracked in the [variables.tf](../variables.tf) file. Since this file can be overwritten during updates when you may run `terraform get --update` when you fetch new releases of DC/OS to upgrade to, it's best to use the [cluster_profile.tfvars](../cluster_profile.tfvars.example) and set your custom Terraform and DC/OS flags there. This way you can keep track of a single file that you can use manage the lifecycle of your cluster.

#### Supported Operating Systems

Here is the [list of operating systems supported](https://github.com/dcos-terraform/terraform-aws-tested-oses/tree/master/platform/cloud/aws).

#### Supported DC/OS Versions

Here is the list of DC/OS versions supported on dcos-terraform natively:

- [OSS Versions](https://github.com/dcos-terraform/terraform-template-dcos-core/tree/master/open/dcos-versions)
- [Enterprise Versions](https://github.com/dcos-terraform/terraform-template-dcos-core/tree/master/ee/dcos-versions)

**Note**: Master DC/OS version is not meant for production use. It is only for CI/CD testing.

To apply the configuration file, you can use this command below.

```bash
terraform apply -var-file cluster_profile.tfvars
```

## Advanced YAML Configuration

We have designed this project to be flexible. Here are the example working variables that allows very deep customization by using a single `tfvars` file.

For advanced users with stringent requirements, here are DC/OS flag examples you can simply paste in `cluster_profile.tfvars`.

```bash
$ cat cluster_profile.tfvars
dcos_version = "1.11.1"
os = "centos_7.3"
num_masters = "3"
num_private_agents = "2"
num_public_agents = "1"
ssh_key_name = "default" 
dcos_cluster_name = "DC/OS Cluster"
dcos_cluster_docker_credentials_enabled =  "true"
dcos_cluster_docker_credentials_write_to_etc = "true"
dcos_cluster_docker_credentials_dcos_owned = "false"
dcos_cluster_docker_registry_url = "https://index.docker.io"
dcos_use_proxy = "yes"
dcos_http_proxy = "example.com"
dcos_https_proxy = "example.com"
dcos_no_proxy = <<EOF
# YAML
 - "internal.net"
 - "169.254.169.254"
EOF
dcos_overlay_network = <<EOF
# YAML
    vtep_subnet: 44.128.0.0/20
    vtep_mac_oui: 70:B3:D5:00:00:00
    overlays:
      - name: dcos
        subnet: 12.0.0.0/8
        prefix: 26
EOF
dcos_rexray_config = <<EOF
# YAML
  rexray:
    loglevel: warn
    modules:
      default-admin:
        host: tcp://127.0.0.1:61003
    storageDrivers:
    - ec2
    volume:
      unmount:
        ignoreusedcount: true
EOF
dcos_cluster_docker_credentials = <<EOF
# YAML
  auths:
    'https://index.docker.io/v1/':
      auth: Ze9ja2VyY3licmljSmVFOEJrcTY2eTV1WHhnSkVuVndjVEE=
EOF
```
**Note**: The YAML comment is required for the DC/OS specific YAML settings.

## Documentation

1. Deploying on AWS
2. [Upgrading DC/OS](./UPGRADE.md)
3. [Maintaining Nodes](./MAINTAIN.md)
4. [Destroy](./DESTROY.md)

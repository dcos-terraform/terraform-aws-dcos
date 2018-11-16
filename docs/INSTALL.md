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
curl -O https://raw.githubusercontent.com/dcos-terraform/terraform-aws-dcos/master/docs/published/main.tf
terraform init
```

## Modify main.tf variables

```bash
# edit the main.tf file
vi main.tf # change "ssh_public_key_file" to your local file ssh path and other variables you desire
```

## Configure AWS SSH Keys

You can either upload your existing SSH keys or use an SSH key already created on AWS.

* **Upload existing key**:
    To upload your own key not stored on AWS, read [how to import your own key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws).


* **Create new key**:
    To create a new key via AWS, read [how to create a key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair).

When you have your key available, you can use ssh-add.

```bash
ssh-add ~/.ssh/path_to_your_key.pem
```

**NOTE:** When using an SSH agent it is best to add the command above to your `~/.bash_profile`. Next time your terminal gets reopened, it will reload your keys automatically.

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

## Configure And Deploy DC/OS

### Deploying with Custom Configuration

The default variables inputs are tracked in the [terraform-aws-dcos](https://registry.terraform.io/modules/dcos-terraform/dcos/aws) terraform registry.


#### Supported Operating Systems

Here is the [list of operating systems supported](https://github.com/dcos-terraform/terraform-aws-tested-oses/tree/master/platform/cloud/aws).

#### Supported DC/OS Versions

Here is the list of DC/OS versions supported on dcos-terraform natively:

- [OSS Versions](https://github.com/dcos-terraform/terraform-template-dcos-core/tree/master/open/dcos-versions)
- [Enterprise Versions](https://github.com/dcos-terraform/terraform-template-dcos-core/tree/master/ee/dcos-versions)

**NOTE:** Master DC/OS version is not meant for production use. It is only for CI/CD testing.

Use the following command to apply the configuration file and to accept all the default variables; otherwise following the instructions in this guide.

```bash
terraform apply

```

## Advanced YAML Configuration

The configuration templates using Terraform are designed to be flexible. Here is an example of working variables that allows deep customization by using a single `main.tf` file.

For advanced users with stringent requirements, paste the DC/OS flag examples in `main.tf` file.
The default variables inputs are tracked in the [terraform-aws-dcos](https://registry.terraform.io/modules/dcos-terraform/dcos/aws) terraform registry.


```bash
$ cat main.tf
...
module "dcos" {
  source = "dcos-terraform/dcos/aws"

  # additional example variables in the module
  dcos_version = "1.11.5"
  dcos_instance_os = "centos_7.3"
  num_masters = "3"
  num_private_agents = "2"
  num_public_agents = "1"
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
**NOTE:** The YAML comment is required for the DC/OS specific YAML settings.

## Documentation

1. Deploying on AWS
2. [Upgrading DC/OS](./UPGRADE.md)
3. [Maintaining Nodes](./MAINTAIN.md)
4. [Destroy](./DESTROY.md)

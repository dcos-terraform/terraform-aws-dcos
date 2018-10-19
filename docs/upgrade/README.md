# Upgrading DC/OS  

You can upgrade your DC/OS cluster with a single command. This terraform script was built to perform installs and upgrades from the inception of this project. With the upgrade procedures below, you can also have finer control on how masters or agents upgrade at a given time. This will give you the ability to change the parallelism of master or agent upgrades.

### DC/OS Upgrades

#### Rolling Upgrade

##### Prerequisite:
Update your terraform scripts to gain access to the latest DC/OS version with this command below. Please make sure you meet the current upgrade version conditions here [https://docs.mesosphere.com/1.11/installing/oss/upgrading/#supported-upgrade-paths](https://docs.mesosphere.com/1.11/installing/oss/upgrading/#supported-upgrade-paths).

```
terraform get --update
# change dcos_version = "<desired_version>" in main.tf
```

##### Upgrade DC/OS Command

```bash
terraform apply -var dcos_install_mode=upgrade
```

## Documentation

1. [Deploying on AWS](./INSTALL.md)
2. Upgrading DC/OS
3. [Maintaining Nodes](./MAINTAIN.md)
4. [Destroy](./DESTROY.md)

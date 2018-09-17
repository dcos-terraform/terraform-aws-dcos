# Maintenance

If you would like to add more or remove (private) agents or public agents from your cluster, you can do so by telling terraform your desired state and it will make sure it gets you there.

## Adding Agents

```bash
# update num_private_agents = "5" in cluster_profile.tfvars
terraform apply -var-file cluster_profile.tfvars
```

## Removing Agents

```bash
# update num_private_agents = "2" in cluster_profile.tfvars
terraform apply -var-file cluster_profile.tfvars
```

**Important**: Always remember to save your desired state in your `cluster_profile.tfvars`

## Documentation

1. [Deploying on AWS](./INSTALL.md)
2. [Upgrading DC/OS](./UPGRADE.md)
3. Maintaining Nodes
4. [Destroy](./DESTROY.md)

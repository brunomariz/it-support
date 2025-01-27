# Slurm Ansible Project

## Sources

- General installation:

  - https://www.linkedin.com/pulse/step-by-step-slurm-installation-mike-vanhorn/
  - https://www.lncc.br/~brunoaf/SD06.pdf

- Building slurm RPMs: https://slurm.schedmd.com/quickstart_admin.html#rpmbuild

## Prerequisites

- Setting appropriate IPs and DNS records.

- Before running this project, make sure either the password, shadow, and group files are synced, or that you have installed some LDAP service on the nodes, using the ipa ansible project, for example.

## Variables

### Vault

- FreeIPA vault secrets

### Inventory vars:

### Import file vars:

- FreeIPA variables

## Usage

> Note: make sure your inventory has a "headnode" or "computenodes" group or both

Installs and configures slurm on new headnode and compute nodes

```
ansible-playbook -K -e @../ipa/vault/secrets.enc -e @vault/secrets.enc --ask-vault-pass  -i inventory/rocky playbook.yaml
```

Installs and configures slurm on compute nodes

```
ansible-playbook -K -e @../ipa/vault/secrets.enc -e @vault/secrets.enc --ask-vault-pass  -i inventory/computenodes playbook.yaml
```

Installs and configures slurm on new headnode

```
ansible-playbook -K -e @../ipa/vault/secrets.enc -e @vault/secrets.enc --ask-vault-pass  -i inventory/headnode playbook.yaml
```

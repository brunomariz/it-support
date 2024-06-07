# Ansible

Ansible is an automation tool developed by RedHat which uses python to run tasks on hosts through ssh connections.

## Roles

Roles can be used to group tasks and make them usable in different scenarios

### iptables

The iptables role configures rules set in the `roles/iptables/templates/iptables-proxmox.sh` file. These rules were developed with use in a proxmox machine in mind, to allow it to have VMs with private IPs. In other words, this role configures a PVE node to act as a NAT gateway for it's VMs.

Sources:

- https://youtube.com/playlist?list=PLvadQtO-ihXt5k8XME2iv0cKpKhcYqe7i&feature=shared
- https://www.youtube.com/watch?v=ITYMeRE455g

Nomenclature:

- PVE node: proxmox host server
- VM: a virtual machine created inside the PVE node
- Enterprise Lan: the lan where all the enterprise equipment is, including the PVE node (for example, 10.10.10.0/24)
- PVE lan: the NAT lan inside the PVE node to be used only by it's VMs (in this example, 192.168.1.0/24)

For this role configuration to work, it is necessary to setup the PVE node and the VM as such:

#### PVE Node

- Leave the default configuration as is, which means a Linux Bridge interface (vmbr0) with designated port enp1s0f0 (or whatever is the physical interface name on the machine), IPv4 in the Enterprise lan (10.10.10.11) and appropriate gateway (10.10.10.1)
- Set the ssh port to another value other than 22 (in this case 3232)
- Add another Linux Bridge interface to the PVE node with IPv4: 192.168.1.1/24, called vmbr1
- Run the ansible role to setup packet and port forwarding, masquerading, etc

#### VMs

- Set the IPv4 to some value in the PVE lan, such as 192.168.1.10/24
- Set the gateway to the PVE node's IP in the PVE lan (192.168.1.1)
- Set the DNS to whatever is appropriate (in this case, 10.10.10.4)
- In the Hardware tab, set the Network Device to vmbr1

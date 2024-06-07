#!/bin/bash

# Save current configs, just in case
iptables-save > /tmp/iptables-rules-save-$(date +%s)-filter
iptables-save -t nat > /tmp/iptables-rules-save-$(date +%s)-nat

# Reset configurations
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -t nat -F

# Set rules for filter table
# Set rules for input chain
iptables -A INPUT -j ACCEPT -i lo -m comment --comment "loopback"
iptables -A INPUT -j ACCEPT -p icmp --icmp-type 8 -m comment --comment "ping"
iptables -A INPUT -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED -m comment --comment "already established connections"
iptables -A INPUT -j ACCEPT -p tcp --dport {{IPTABLES_PROXMOX_SERVER_SSH_PORT}} -m comment --comment "ssh"
iptables -A INPUT -j ACCEPT -p tcp --dport 8006 -m comment --comment "proxmox web"
iptables -A INPUT -j ACCEPT -p tcp --dport 443 -m comment --comment "https"
# Set input chain default to drop
iptables -P INPUT DROP
# Set output chain default to accept
iptables -P OUTPUT ACCEPT
# Set rules for forwarding chain. These route traffic from the labs private network to the PVE node's private network.
iptables -A FORWARD -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED -m comment --comment "established traffic"
iptables -A FORWARD -j ACCEPT -i {{ IPTABLES_PROXMOX_LAN_INTERFACE_NAME }} -o {{ IPTABLES_PROXMOX_WAN_INTERFACE_NAME }} -m comment --comment "outbound traffic from lan"
# Necessary for port forwarding
iptables -A FORWARD -j ACCEPT -p tcp --dport 22 -d {{ IPTABLES_PROXMOX_VM_IP }} -m comment --comment "ssh to VM"
# Set forward chain default to drop
iptables -P FORWARD DROP

# Set rules nat table
# Prerouting chain
# Port forwarding
iptables -t nat -A PREROUTING -j DNAT --to-destination {{ IPTABLES_PROXMOX_VM_NAT_LAN_IP }} -p tcp --dport 22 -d {{ IPTABLES_PROXMOX_PVE_ENTERPRISE_LAN_IP }} -m comment --comment "forward PVE port 22 -> VM port 22"
# Postrouting chain
# Necessary to route traffic from the labs private network to the PVE node's private network.
iptables -t nat -A POSTROUTING -o {{ IPTABLES_PROXMOX_WAN_INTERFACE_NAME }} -j MASQUERADE -m comment --comment "masquerade lan->wan"

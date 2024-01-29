## Use cases

- Custom local hostnames
  - SSH to local network servers by hostname (instead of typing IP)
  - Use local network web apps by hostname (instead of IP)
- Local DNS caching

## Prerequisites

- Set local static IP on server (in this case, 192.168.15.200)

## Creating local DNS server with dnsmasq

- Reference: https://wiki.archlinux.org/title/dnsmasq#Adding_a_custom_domain

Server OS: Rocky Linux (Alternative Raspberry Pi build)
Client OS: Ubuntu

- Install dnsmasq

### Configuration (on the Server)

- Configure dnsmasq by editing `/etc/dnsmasq.conf` and adding these lines to the top of the file:

```shell
# Or which to listen on by address (remember to include 127.0.0.1 if
# you use this.)
listen-address=::1,127.0.0.1,192.168.15.200
# Set the number of cached domain names with cache-size=size (the default is 150 and the hard limit is 10000):
cache-size=1000
# To validate DNSSEC load the DNSSEC trust anchors provided by the dnsmasq package and set the option dnssec:
# conf-file=/usr/share/dnsmasq/trust-anchors.conf
# dnssec
# add no-resolv so dnsmasq does not needlessly read /etc/resolv.conf which only contains the localhost addresses of itself
no-resolv
# Google's nameservers, for example
server=8.8.8.8
server=8.8.4.4
# It is possible to add a custom domain to hosts in your (local) network:
# In this example it is possible to ping a host/device (e.g. defined in your /etc/hosts file) as hostname.gres
local=/gres/
domain=gres
# expand-hosts to add the custom domain to hosts entries:
expand-hosts
...
# Configuration file for dnsmasq.
#
...
```

### DNS addresses file and forwarding (manual option) (on the Server)

To manually forward the dns to external dns servers, the `/etc/resolv.conf` must be correctly configured.

#### Note:

>`/etc/resolv.conf`: This file determines which dns servers your computer will use. It can be manually edited, 
but it will be overwritten on NetworkManager restart. Therefore, it is better to edit the NetworkManager's
configurations and let it automatically generate a new `resolv.conf`file

- Edit NetworkManager settings to generate new `resolv.conf` file, using localhost as the IP of the DNS server

```shell
$ nmcli connection modify 'connection-name' ipv4.dns 127.0.0.1
$ nmcli connection modify 'connection-name' ipv4.dns-options trust-ad
$ nmcli connection modify 'connection-name' ipv4.ignore-auto-dns yes
$ nmcli connection modify 'connection-name' ipv6.dns ::1
$ nmcli connection modify 'connection-name' ipv6.dns-options trust-ad
$ nmcli connection modify 'connection-name' ipv6.ignore-auto-dns yes
```

- Then restart NetworkManager.service.
- 
```shell
$ systemctl restart NetworkManager
```

### Setting host names (on the Server)

- Edit `/etc/hosts` to add hostnames to the dns server

```
127.0.0.1		localhost.localdomain localhost
192.168.15.200		perola

::1	localhost6.localdomain6 localhost6
```

### Edit DNS configuration on the Client

- Set DNS server IP to the local DNS server's IP

```shell
$ nmcli connection modify 'connection-name' ipv4.dns 192.168.15.200
$ nmcli connection modify 'connection-name' ipv4.dns-options trust-ad
$ nmcli connection modify 'connection-name' ipv4.ignore-auto-dns yes
```

- Set ipv4 dns priority to be higher than ipv6 dns priority

```shell
$ nmcli con mod 'connection-name' ipv6.dns-priority 51
$ nmcli con mod 'connection-name' ipv4.dns-priority 50
```

- Restart NetworkManager to regenerate `/etc/resolv.conf`

```shell
systemctl restart NetworkManager
```

- Check changes

```shell
resolvectl
```

```shell
...
Current DNS Server: 192.168.15.200
DNS Servers: 192.168.15.200
...
```

### Test custom domain names (on the Client)

```shell
dig perola.gres.home
```

```shell
; <<>> DiG 9.16.1-Ubuntu <<>> perola.gres.home
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14428
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;perola.gres.home.		IN	A

;; ANSWER SECTION:
perola.gres.home.	0	IN	A	192.168.15.200

;; Query time: 7 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: dom jan 28 23:46:36 -03 2024
;; MSG SIZE  rcvd: 61
```

![image](https://github.com/brunomariz/it-support/assets/48870924/91327a9e-5bea-478d-a555-fd25fc06a96e)




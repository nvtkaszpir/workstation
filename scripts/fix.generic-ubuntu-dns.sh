#!/bin/bash
# see:
# https://github.com/lavabit/robox/issues/11
# https://github.com/lavabit/robox/issues/54

# exit if we are not on modern ubuntu version
test -d /etc/netplan || exit 0

# Reset netplan config, not really needed; just to clearly indicate no fixed dns is used
tee <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      optional: true
      nameservers:
        addresses: []
EOF
netplan generate
systemctl restart systemd-networkd.service
systemctl restart ifplugd.service

# Remove fixed DNS entries and disable DNSSEC, disable flaky caching, or emdns
tee <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=
FallbackDNS=
Domains=
#LLMNR=no
#MulticastDNS=no
DNSSEC=no
Cache=no
DNSStubListener=yes
EOF

systemctl daemon-reload
systemctl restart systemd-resolved

echo "Fixed networking."

# verify with: systemd-resolve --status

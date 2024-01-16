#!/bin/bash

sed -r -i 's/^#DNSSEC=.*$/DNSSEC=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#DNSOverTLS=.*$/DNSOverTLS=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#Cache=.*$/Cache=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#DNS=.*$/DNS=1.1.1.2#cloudflare-dns.com 2606:4700:4700::1112#cloudflare-dns.com/m' /etc/systemd/resolved.conf
sed -r -i 's/^#FallbackDNS=.*$/FallbackDNS=8.8.4.4#dns.google 2001:4860:4860::8844#dns.google/m' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

if [ "$(timeout 10 ping -c1 google.com 2>/dev/null)" = "" ]; then
  sed -r -i 's/^DNSSEC=.*$/DNSSEC=allow-downgrade/m' /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
fi

if [ "$(timeout 10 ping -c1 google.com 2>/dev/null)" = "" ]; then
  sed -r -i 's/^DNSSEC=/#DNSSEC=/m' /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
fi

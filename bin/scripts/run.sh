#!/bin/bash

cd $(dirname "$0")
dir="$PWD"

bash ./install.sh

rpm-ostree apply-live --allow-replacement

bash ./setup.sh

rkhunter --update -q
rkhunter --propupd -q

sed -r -i 's/^#DNSSEC=.*$/DNSSEC=yes/m' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

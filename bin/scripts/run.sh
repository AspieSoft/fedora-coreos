#!/bin/bash

cd $(dirname "$0")
dir="$PWD"

echo "$1"

if test -f "$1"; then
  exit
fi

if ! test -f "/etc/postinst/install.done"; then
  echo -e "\rInstalling Core..."

  bash ./install.sh

  #rpm-ostree apply-live --allow-replacement

  touch "/etc/postinst/install.done"
  systemctl --no-block reboot
  exit
fi

echo -e "\rInstalling..."

bash ./setup.sh

rkhunter --update -q
rkhunter --propupd -q

sed -r -i 's/^#DNSSEC=.*$/DNSSEC=yes/m' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

touch "$1"
systemctl --no-block reboot

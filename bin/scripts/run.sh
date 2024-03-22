#!/bin/bash

cd $(dirname "$0")
dir="$PWD"

if test -f /var/lib/coreos-postinst.stamp; then
  exit
fi

if ! test -f "/etc/postinst/install-done.stamp"; then
  echo -e "\rInstalling Core..."

  bash ./install.sh

  #rpm-ostree apply-live --allow-replacement

  touch "/etc/postinst/install-done.stamp"
  systemctl --no-block reboot
  exit
fi

echo -e "\rInstalling..."

bash ./setup.sh

rkhunter --update
rkhunter --propupd

sed -r -i 's/^#DNSSEC=.*$/DNSSEC=yes/m' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

touch /var/lib/coreos-postinst.stamp
systemctl --no-block reboot

#todo: allow user to select profile after install (may add a manual script to run)
# note: cli profile should always be run on init, and if the user selects cli, nothing needs to be rerun
# may store this script in files instead, and have this as the on first boot menu

#!/bin/bash

#* upgrade prefoemance
rpm-ostree install --allow-inactive preload
systemctl enable preload --now

systemctl enable tlp --now
tlp start

systemctl enable thermald --now

#* install programing languages
npm config set prefix ~/.npm
#todo: fix getting stuck in npm install (may move this to run after a reboot on an auto update service)
# may also need to reboot before running setup service
npm -g i npm
npm -g i yarn

#* setup security
gitVer="$(curl --silent 'https://api.github.com/repos/AspieSoft/linux-clamav-download-scanner/releases/latest' | grep '"tag_name":' | sed -E 's/.*\"([^\"]+)\".*/\1/')"
if [ "$gitVer" != "" -a "$(echo "$gitVer" | sed -E 's/v?[0-9\.]*//g')" = "" ] && [ ! -f "$dir/../files/etc/linux-clamav-download-scanner/version.txt" -o "$gitVer" != "$(cat "$dir/../files/etc/linux-clamav-download-scanner/version.txt")" ]; then
  git clone https://github.com/AspieSoft/linux-clamav-download-scanner.git "/etc/linux-clamav-download-scanner"
else
  cp -rf "$dir/../files/etc/linux-clamav-download-scanner" "/etc/linux-clamav-download-scanner"
fi
bash /etc/linux-clamav-download-scanner/install.sh --force
rm -rf /etc/linux-clamav-download-scanner


#* install package managers
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak remote-add --if-not-exists rhel https://flatpaks.redhat.io/rhel.flatpakrepo
flatpak update -y --noninteractive

ln -s /var/lib/snapd/snap /snap
systemctl enable snapd --now
snap refresh #fix: not seeded yet will trigger and fix itself for the next command
snap install core
snap refresh core
snap refresh

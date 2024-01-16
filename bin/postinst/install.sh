#!/bin/bash

function curl-write-if-ok {
  if curl -s --head --request GET "$1" | grep -E "200 OK|HTTP/[0-9]+ 200" > /dev/null; then
    curl "$1" -o "$2" --create-dirs
  fi
}

bash ./dns.sh

rpm-ostree install --allow-inactive firewalld qemu-guest-agent tuned
rpm-ostree override remove cifs-utils samba-common-libs samba-client-libs libsmbclient libwbclient samba-common sssd-krb5-common sssd-ipa sssd-nfs-idmap sssd-ldap sssd-client sssd-ad sssd-common sssd-krb5 sssd-common-pac
sed -i 's/nullok//g' /etc/pam.d/system-auth

bash ./harden.sh

#* install repos
rpm-ostree install --allow-inactive https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
curl-write-if-ok "https://copr.fedorainfracloud.org/coprs/elxreno/preload/repo/fedora-$(rpm -E %fedora)/elxreno-preload-fedora-$(rpm -E %fedora).repo" "/etc/yum.repos.d/elxreno-preload.repo"

#* upgrade prefoemance
rpm-ostree install --allow-inactive tlp tlp-rdw thermald

# sed -r -i 's/^GRUB_TIMEOUT=(.*)$/GRUB_TIMEOUT=0/m' /etc/default/grub
# update-grub
# grub2-editenv - set menu_auto_hide=1
# grub2-mkconfig -o /etc/grub2-efi.cfg
# grub2-mkconfig -o /etc/grub2.cfg

#* install programing languages
rpm-ostree install --allow-inactive python python3 python-pip python3-pip
rpm-ostree install --allow-inactive gcc-c++ make gcc
rpm-ostree install --allow-inactive java-1.8.0-openjdk java-11-openjdk java-latest-openjdk
rpm-ostree install --allow-inactive git nodejs npm
rpm-ostree install --allow-inactive golang pcre-devel

#* setup security
rpm-ostree install --allow-inactive fail2ban clamav clamd clamav-update
rpm-ostree install --allow-inactive cronie pwgen rkhunter

#* install package managers
rpm-ostree install --allow-inactive flatpak snapd

#* install common packages
rpm-ostree install --allow-inactive nano neofetch btrfs-progs lvm2 xfsprogs udftools p7zip p7zip-plugins hplip hplip-gui inotify-tools guvcview

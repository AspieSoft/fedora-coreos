#!/bin/bash

cd $(dirname "$0")
dir="$1"

function curl-install-if-ok {
  local skipDownload="0"
  if [ "$dir" != "" -a -f "$2" ]; then
    modtime="$(stat -c "%y" "$2" | sed -E 's/^([0-9\-]*).*$/\1/')"
    if ! [ "$(date -d "$modtime" +%Y)" -lt "$(date +%Y)" -o "$(date -d "$modtime" +%m)" -lt "$(date +%m)" ]; then
      local skipDownload="1"
    fi
  elif [ "$dir" = "" -a -f "$PWD/../files/$2" ]; then
    modtime="$(stat -c "%y" "$2" | sed -E 's/^([0-9\-]*).*$/\1/')"
    if [ "$(date -d "$modtime" +%Y)" -le "$(date +%Y)" -o "$(date -d "$modtime" +%m)" -lt "$(date +%m)" ]; then
      local skipDownload="1"
    fi
  fi

  if [ "$skipDownload" != "1" ] && curl -s --head --request GET "$1" | grep -E "200 OK|HTTP/[0-9]+ 200" > /dev/null; then
    curl "$1" -o "$2" --create-dirs
  elif [ "$dir" = "" -a -s "$PWD/../files/$2" ]; then
    cp -f "$PWD/../files/$2" "$2"
  else
    mkdir -p "$(dirname "$2")"
    touch "$2"
  fi
}

curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf" "$dir/etc/modprobe.d/30_security-misc.conf"

curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc.conf" "$dir/etc/sysctl.d/30_security-misc.conf"
if [ -s "$dir/$2" ]; then
  sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=1/g' "$dir/etc/sysctl.d/30_security-misc.conf"
  sed -i 's/net.ipv4.icmp_echo_ignore_all=1/net.ipv4.icmp_echo_ignore_all=0/g' "$dir/etc/sysctl.d/30_security-misc.conf"
  sed -i 's/net.ipv6.icmp_echo_ignore_all=1/net.ipv6.icmp_echo_ignore_all=0/g' "$dir/etc/sysctl.d/30_security-misc.conf"
fi

curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf" "$dir/etc/sysctl.d/30_silent-kernel-printk.conf"
curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc_kexec-disable.conf" "$dir/etc/sysctl.d/30_security-misc_kexec-disable.conf"
curl-install-if-ok "https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf" "$dir/etc/chrony.conf"

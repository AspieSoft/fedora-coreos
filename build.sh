#!/bin/bash

cd $(dirname "$0")
dir="$PWD"

#* compile coreos ignition file
butane coreos.bu.yml > coreos.ign


#* install files locally
bash ./bin/scripts/harden.sh "$dir/bin/files"

gitVer="$(curl --silent 'https://api.github.com/repos/AspieSoft/linux-clamav-download-scanner/releases/latest' | grep '"tag_name":' | sed -E 's/.*\"([^\"]+)\".*/\1/')"
if [ "$gitVer" != "" -a "$(echo "$gitVer" | sed -E 's/v?[0-9\.]*//g')" = "" ]; then
  if [ ! -f "$dir/bin/files/etc/linux-clamav-download-scanner/version.txt" -o "$gitVer" != "$(cat "$dir/bin/files/etc/linux-clamav-download-scanner/version.txt")" ]; then
    rm -rf "$dir/bin/files/etc/linux-clamav-download-scanner"
    git clone https://github.com/AspieSoft/linux-clamav-download-scanner.git "$dir/bin/files/etc/linux-clamav-download-scanner"
    rm -rf "$dir/bin/files/etc/linux-clamav-download-scanner/.git"
  fi
  echo "$gitVer" > "$dir/bin/files/etc/linux-clamav-download-scanner/version.txt"
fi


#* compress bin directory
tar -czf coreos.tar.xz ./bin/*
sum=$(sha512sum coreos.tar.xz | sed -E 's/\s+.*$//')
gzip --best --force coreos.tar.xz
sed -r -i "s/\"sha512-0000[^\"]+\"/\"sha512-$sum\"/" coreos.ign

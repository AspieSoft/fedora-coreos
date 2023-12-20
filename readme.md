# fedora coreos ignition file

[![donation link](https://img.shields.io/badge/buy%20me%20a%20coffee-paypal-blue)](https://paypal.me/shaynejrtaylor?country.x=US&locale.x=en_US)

Notice: This repo is currently in pre-alpha, and might not always be here. It is public to make testing in a vm easier.

## Installation

```shell script
sudo coreos-installer install /dev/sda --ignition-url https://raw.githubusercontent.com/AspieSoft/fedora-coreos/main/coreos.ign

# or temporary redirect
sudo coreos-installer install /dev/sda -I https://test.aspiesoft.com/coreos.ign

reboot
```

## Default Login

User: core
Password: 1234

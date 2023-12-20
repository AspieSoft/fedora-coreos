# fedora coreos ignition file

[![donation link](https://img.shields.io/badge/buy%20me%20a%20coffee-paypal-blue)](https://paypal.me/shaynejrtaylor?country.x=US&locale.x=en_US)

Notice: This module is currently in beta, and might not always be here. It is public to make testing in a vm easier.

## Installation

```shell script
sudo coreos-installer install /dev/sda --ignition-url https://raw.githubusercontent.com/AspieSoft/fedora-coreos/main/coreos.ign

# or temporary redirect
sudo coreos-installer install /dev/sda --ignition-url https://test.aspiesoft.com/coreos.ign

reboot
```

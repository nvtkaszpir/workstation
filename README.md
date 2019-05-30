# About

Provisioning for my working station using Ansible.

# Requirements

To run locally:
* [vagrant](https://www.vagrantup.com/)
* linux host with quemu-kvm to spawn virutal machine (virtualbox/windows not tested)
* working [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)
* access to internet to download dependencies
* run `vagrant up`
* full run should take about 20 minutes (installing desktop on server)
* run from host `scripts/test_in_vagrant.sh` to fetch also ara reports
* after run you can exec `scripts/ara.sh` to see ansible runs results via web
* re-run `scripts/test_in_vagrant.sh` and hit refresh in ara web

# asciinema / images

[![asciicast](https://asciinema.org/a/249319.svg)](https://asciinema.org/a/249319)

[![asciicast](https://asciinema.org/a/249326.svg)](https://asciinema.org/a/249326)

![ara web preview](ara.png "ARA web preview example")


# TODO
* guest: apt settings (retries)
* guest: dnsmasq
* guest: smartgit
* ci: linters to hthml
* guest: apt dist-upgrade
* guest: system reboot if required
* ansible: retries?

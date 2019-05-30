# About
Provisioning for my working station using Ansible.


# Requirements

To run locally:
* [vagrant](https://www.vagrantup.com/)
* linux host with quemu-kvm to spawn virutal machine (virtualbox/windows not tested)
* access to internet to download dependencies
* run `vagrant up`
* full run should take about 20 minutes (installing desktop on server)
* after run you can exec `scripts/ara.sh` to see ansible results.

# TODO
* guest: apt settings (retries)
* guest: dnsmasq
* guest: smartgit
* ci: linters to hthml
* guest: apt dist-upgrade
* guest: system reboot if required
* ansible: retries?

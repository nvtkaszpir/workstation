# -*- mode: ruby -*-
# vi: set ft=ruby :

V_CPU = ENV['V_CPU'] || 4 # in cores
V_MEM = ENV['V_MEM'] || 1024 # in megabytes per core
V_MEM_TOTAL = V_MEM.to_i * V_CPU.to_i
SYNC_TYPE = "rsync" # how to sync files in vagrant, for lxc rsync is suggested


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.enabled = false
  end

  config.vm.synced_folder ".", "/vagrant",
    type: SYNC_TYPE,
    rsync__verbose: true,
    rsync__exclude: [".vagrant/", "./reports/"]

  # providers
  config.vm.provider "virtualbox" do |v|
    v.cpus = V_CPU
    v.memory = V_MEM_TOTAL
  end

  config.vm.provider :libvirt do |libvirt, override|
    # this is vagrant, vm is disposable, so set up supper agressive disk access
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.cpus = V_CPU
    libvirt.memory = V_MEM_TOTAL
    libvirt.random_hostname = true
    libvirt.video_type = 'qxl'
    libvirt.graphics_type = 'spice'
    libvirt.video_vram = '16384'
    libvirt.volume_cache = 'unsafe'

  end

  config.vm.define "u2004" do |s|
    s.vm.box = "generic/ubuntu2004"
    s.vm.box_version = "3.1.22"
    s.vm.network "private_network", ip: "192.168.50.10"
  end

  config.vm.provision "net",
    type: "shell",
    path: "scripts/fix.generic-ubuntu-dns.sh",
    privileged: true,
    run: "always"

  config.vm.provision "common",
    type: "shell",
    path: "scripts/common.sh",
    privileged: true,
    run: "always"

  config.vm.provision "test",
    type: "shell",
    path: "scripts/test.sh",
    privileged: true,
    run: "always"

end

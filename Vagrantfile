
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
    vb.memory = 256
    vb.cpus = 1
  end
  config.vm.define "router-1" do |router1|
    router1.vm.box = "minimal/trusty64"
    router1.vm.hostname = "router-1"
    router1.vm.network "private_network", virtualbox__intnet: "broadcast_router_1", auto_config: false
    router1.vm.network "private_network", virtualbox__intnet: "broadcast_inter", auto_config: false
    router1.vm.provision "shell", path: "router-1to2.sh"
  end
  config.vm.define "router-2" do |router2|
    router2.vm.box = "minimal/trusty64"
    router2.vm.hostname = "router-2"
    router2.vm.network "private_network", virtualbox__intnet: "broadcast_host_c", auto_config: false
    router2.vm.network "private_network", virtualbox__intnet: "broadcast_inter", auto_config: false
    router2.vm.provision "shell", path: "router-2to1.sh"
  end
  config.vm.define "switch" do |switch|
    switch.vm.box = "minimal/trusty64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_router_1", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    switch.vm.provision "shell", path: "switch.sh"
  end
  config.vm.define "host-1-a" do |host1a|
    host1a.vm.box = "minimal/trusty64"
    host1a.vm.hostname = "host-1-a"
    host1a.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    host1a.vm.provision "shell", path: "host-1-a.sh"
  end
  config.vm.define "host-1-b" do |host1b|
    host1b.vm.box = "minimal/trusty64"
    host1b.vm.hostname = "host-1-b"
    host1b.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    host1b.vm.provision "shell", path: "host-1-b.sh"
  end
  config.vm.define "host-2-c" do |host2c|
    host2c.vm.box = "minimal/trusty64"
    host2c.vm.hostname = "host-2-c"
    host2c.vm.network "private_network", virtualbox__intnet: "broadcast_host_c", auto_config: false
    host2c.vm.provision "shell", path: "host-2-c.sh"
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos1706_v0.2.0"

#DHCP Server Configuration
  config.vm.define "dhcp" do |dhcp|
    dhcp.vm.network "public_network", bridge:"eno1", ip:"192.168.137.2", netmask: "255.255.255.0"
    dhcp.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "dhcp"
    end
  end
  
#Mirror Server Configuration  
  config.vm.define "mirror" do |mirror|
    mirror.vm.network "public_network", bridge:"eno1", ip:"192.168.137.3", netmask: "255.255.255.0"
    mirror.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "mirror"
      chef.add recipe "httpd"
    end
  end
  
end


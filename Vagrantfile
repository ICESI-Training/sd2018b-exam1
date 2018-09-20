# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos1706_v0.2.0"

  config.vm.define "dhcp" do |dhcp|
    dhcp.vm.network "public_network", bridge:"eno1", ip:"192.168.137.62", netmask: "255.255.255.0"
    dhcp.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "dhcp"
    end
  end  
end


# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos1706_v0.2.0"

#DHCP Server Configuration - provisioning
  config.vm.define "dhcp" do |dhcp|
    dhcp.vm.network "public_network", bridge:"eno1", ip:"192.168.137.2", netmask: "255.255.255.0"
    dhcp.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "dhcp"
    end
  end
  
#Mirror Server Configuration  - provisioning
  config.vm.define "mirror" do |mirror|
    mirror.vm.network "public_network", bridge:"eno1", ip:"192.168.137.3", netmask: "255.255.255.0"
    mirror.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "mirror"
      chef.add_recipe "httpd"
    end
  end

#Continuous Integration Server Configuration - provisioning
  config.vm.define "ci" do |ci|
    ci.vm.network "public_network", bridge:"eno1", ip:"192.168.137.4", netmask: "255.255.255.0"
    ci.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "ciserver"
    end
  end

#Mirror CLient Configuration - provisioning
  config.vm.define "mirror_client" do |mirror_client|
    mirror_client.vm.network "public_network", bridge: "eno1", type: "dhcp"
    mirror_client.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	chef.add_recipe "httpd"
        chef.add_recipe "mirror_client"
        end
   end

end

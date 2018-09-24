# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.box = "centos_v0.2.0"

   
   config.vm.define "server_dhcp" do |server_dhcp|
    server_dhcp.vm.network "public_network", bridge: "eno1", ip: "192.168.131.31", netmask: "255.255.255.0"
    server_dhcp.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "dhcp_server"
        end
   end
   
   config.vm.define "server_mirror" do |server_mirror|
    server_mirror.vm.network "public_network", bridge: "eno1", ip: "192.168.131.15", netmask: "255.255.255.0"
    server_mirror.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "httpd"
        chef.add_recipe "mirror_server"
        end
   end

   config.vm.define "yum_client" do |yum_client|
    yum_client.vm.network "public_network", bridge: "eno1", type: "dhcp"
    yum_client.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "httpd"
        chef.add_recipe "mirror_client"
        end
   end

   config.vm.define "ci_server" do |ci_server|
    ci_server.vm.network "public_network", bridge: "eno1", ip: "192.168.131.16", netmask: "255.255.255.0"
    ci_server.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "httpd"
        end
   end

end

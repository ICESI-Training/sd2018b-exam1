# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
   config.vm.box = "centos1706_v0.2.0"


   config.vm.define "dhcp_server" do |dhcp_server|
    dhcp_server.vm.network "public_network", bridge: "eno1", ip: "192.168.140.2", netmask: "255.255.255.0"
    dhcp_server.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "dhcp_server"
        end
   end

#   config.vm.define "yum_mirror_server" do |yum_mirror_server|
#    server_mirror.vm.network "public_network", bridge: "eno1", ip: "192.168.130.3", netmask: "255.255.255.0"
#    server_mirror.vm.provision :chef_solo do |chef|
#    	chef.install = false
#    	chef.cookbooks_path = "cookbooks"
#        chef.add_recipe "httpd"
#        chef.add_recipe "mirror_server"
#        end
#   end

#   config.vm.define "yum_client" do |yum_client|
#    yum_client.vm.network "public_network", bridge: "eno1", type: "dhcp"
#    yum_client.vm.provision :chef_solo do |chef|
#    	chef.install = false
#    	chef.cookbooks_path = "cookbooks"
#        chef.add_recipe "httpd"
#        chef.add_recipe "yum_client"
#        end
#   end

#   config.vm.define "ci_server" do |ci_server|
#    ci_server.vm.network "public_network", bridge: "eno1", ip: "192.168.130.4", netmask: "255.255.255.0"
#    ci_server.vm.provision :chef_solo do |chef|
#    	chef.install = false
#    	chef.cookbooks_path = "cookbooks"
#        chef.add_recipe "httpd"
#        end
#   end

end

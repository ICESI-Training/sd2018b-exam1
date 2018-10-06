# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

#DHCP--------------------------------------------------------------------------------------

  config.vm.define "DHCP_Server" do |dhcpServer|
    dhcpServer.vm.box = "centos1706_v0.2.0"
    dhcpServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.150", netmask: "255.255.255.0"
    dhcpServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "dhcpd"
    end  
  end

#CI------------------------------------------------------------------------------------------

  config.vm.define "CI_Server" do |ciServer|
    ciServer.vm.box = "centos1706_v0.2.0"
    ciServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.151", netmask: "255.255.255.0"
    ciServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "ci"
    end
  end

#Mirror--------------------------------------------------------------------------------------

  config.vm.define "Mirror_Server" do |mirrorServer|
    mirrorServer.vm.box = "centos1706_v0.2.0"
    mirrorServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.152", netmask: "255.255.255.0"
    mirrorServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "mirror"
    end
  end

#Client--------------------------------------------------------------------------------------

  config.vm.define "YUM_Client" do |mirrorClient|
    mirrorClient.vm.box = "centos1706_v0.2.0"
    mirrorClient.vm.network "public_network", bridge: "eno1", type: "dhcp"
    mirrorClient.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
        chef.add_recipe "client"
    end
  end
#--------------------------------------------------------------------------------------------

end

# -*- mode: ruby -*-/Users/juliand7gj/Downloads/sd2018b-exam1-jgonzalez-sd2018b-exam1/Vagrantfile
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 config.vm.box = "centos1706_v0.2.0"

#DHCP--------------------------------------------------------------------------------------

  config.vm.define "DHCP_Server" do |dhcpServer|
    dhcpServer.vm.box = "centos1706_v0.2.0"
    dhcpServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.20", netmask: "255.255.255.0"
    dhcpServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "dhcpd"
	chef.add_recipe "httpd"
    end  
  end

#Mirror--------------------------------------------------------------------------------------

  config.vm.define "Mirror_Server" do |mirrorServer|
    mirrorServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.22", netmask: "255.255.255.0"
    mirrorServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
	chef.add_recipe "httpd"
       chef.add_recipe "mirror"
    end
  end

#Client--------------------------------------------------------------------------------------

  config.vm.define "YUM_Client" do |mirrorClient|
    mirrorClient.vm.network "public_network", bridge: "eno1", type: "dhcp"
    mirrorClient.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	chef.add_recipe "httpd"
        chef.add_recipe "client"
	
    end
  end
#CI--------------------------------------------------------------------------------------------

  config.vm.define "CI_Server" do |ciServer|
    ciServer.vm.box = "centos1706_v0.2.0"
    ciServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.21", netmask: "255.255.255.0"
    ciServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "ci"
	chef.add_recipe "httpd"
    end
  end


end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos"

  config.vm .define "dhcp_server" do |dhcp_server|
    dhcp_server.vm.network "public_network", bridge:"eno1", ip: "192.168.131.102", netmask: "255.255.255.0"
    dhcp_server.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "dhcp_server"
      chef.add_recipe "httpd"
      end
  end

  config.vm .define "mirror_server" do |mirror_server|
    mirror_server.vm.network "public_network", bridge:"eno1", ip: "192.168.131.103", netmask: "255.255.255.0"
    mirror_server.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "httpd"
      chef.add_recipe "mirror_server"
      end
  end

  config.vm .define "ci_server" do |ci_server|
    ci_server.vm.network "public_network", bridge:"eno1", type: "dhcp"
    ci_server.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "ci_server"
      chef.add_recipe "httpd"
      end
  end

  config.vm .define "mirror_client" do |mirror_client|
    mirror_client.vm.network "public_network", bridge:"eno1", type: "dhcp"
    mirror_client.vm.provision :chef_solo do |chef|
      chef.install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "httpd"
      chef.add_recipe "mirror_client"
      end
  end

end

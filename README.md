## sd-exam1

**Nombre:** Angie Lorena Pérez    
**Código:** A00242068  
**Materia:** Sistemas distribuidos  
**Correo:** lorena9221@hotmail.com  
**Repositorio:** https://github.com/


## Objectives

* To autonomously carry out the automatic provisioning of infrastructure.
* Diagnose and execute autonomously the necessary actions to achieve stable infrastructures.

### Suggested technologies for the development of the examination
* Vagrant
* Box del sistema operativo CentOS7
* Repositorio Github
* Python3
* Librerias Python3: Flask, Connexion, Fabric
* Ngrok

## Description
You must deploy a platform that meets the following requirements:

You must have a Github repository that corresponds to a fork in the repository **sd2018b-exam1** 
The repository must have a Vagrantfile that allows the deployment of three virtual machines with the following features:
  * CentOS7 DHCP Server
  * CentOS7 CI Server
  * CentOS7 YUM Mirror Server
  * CentOS7 YUM Client
  
  ![](imagenes/01_diagrama_despliegue.png) 
  
  
  ## Solution

 The Linux commands necessary for the provisioning of the requested services are the following:
 
 The following shows the order in which the machines are executed.By using the ```vagrant up``` command.

 
 ```
 config.vm.define :dhcp do |dhcp|
  dhcp.vm.box = "centos1706_v0.2.0"
  dhcp.vm.network "public_network", bridge:"eno1", ip:"192.168.130.125", netmask:"255.255.255.0"
  config.vm.provision :chef_solo do |chef|
		chef.install = false
		chef.cookbooks_path = "cookbooks"
		chef.add_recipe "dhcp"
	end
 end

 config.vm.define :mirror_server do |mirror_server|
  mirror_server.vm.box = "centos1706_v0.2.0"
  mirror_server.vm.network "public_network", bridge:"eno1", ip:"192.168.130.10", netmask:"255.255.255.0"
  mirror_server.vm.provision :chef_solo do |chef|
		chef.install = false
  		chef.cookbooks_path = "cookbooks"
    chef.add_recipe "httpd"
		chef.add_recipe "mirror_server"
	end
 end

  config.vm.define :ci_server do |ci_server|
  ci_server.vm.box = "centos1706_v0.2.0"
  ci_server.vm.network :public_network, bridge: "eno1", ip:"192.168.130.3"
  ci_server.vm.provision :chef_solo do |chef|
		chef.install = false
		chef.cookbooks_path = "cookbooks"
 		chef.add_recipe "ci_server"
	end
 end

 
  
  config.vm.define :mirror_client do |mirror_client|
  mirror_client.vm.box = "centos1706_v0.2.0"
  mirror_client.vm.network "public_network", bridge:"eno1", ip:"192.168.130.8", netmask:"255.255.255.0"
  mirror_client.vm.provision :chef_solo do |chef|
		chef.install = false
		chef.cookbooks_path = "cookbooks"
		chef.add_recipe "mirror_client"
	 end
 end
 
 ```
 
 **dhcp configuration:**
 
 
  
  
  
  

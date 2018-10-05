### Examen 1
**Universidad ICESI**  
**Curso:** Sistemas Distribuidos  
**Docente:** Daniel Barragán C.  
**Tema:** Automatización de infraestructura  
**Correo:** daniel.barragan at correo.icesi.edu.co  
**Estudiante:** Jonatan Ordoñz Burbano  
**Código:** A00054000

### Description  
This document describes the configuration of virtual machines to meet the requirements of exam 1 for the course of distributed systems at Icesi University in the 2018b period.

![](imgs/01_diagrama_despliegue.png)  
**Figure 1**. Deployment diagram

### Network Configuration  
For the dhcp_server, yum_mirror_server and ci_server machines, the ips assignment is done manually. Only the yum_client is deployed with an ip assigned by dhcp service in the dhcp_server. The installation of dependencies and files in the virtual machines, a process known as provisioning, is done with the provisioning manager Chef.

| name of the machine | Ip            | Type of assignment |
| ------------------- | ------------- | ------------------ |
| dhcp_server         | 192.168.140.2 | manual             |
| yum_mirror_server   | 192.168.140.3 | manual             |
| ci_server           | 192.168.140.4 | manual             |
| yum_client          | dynamic       | dhcp_server        |
**Table 1**. Network description for the virtual machines

### Deployment description  
The deployment of the machines is done in the following order:
1. dhcp_server
1. yum_mirror_server
1. yum_client
1. ci_server

The order of deployment can be observed in the ``Vagranfile`` file in the root of this repository. Here is the deployment configuration of the Vagrantfile file:

```
config.vm.define "dhcp_server" do |dhcp_server|
 dhcp_server.vm.network "public_network", bridge: "eno1", ip: "192.168.140.2", netmask: "255.255.255.0"
 dhcp_server.vm.provision :chef_solo do |chef|
   chef.install = false
   chef.cookbooks_path = "cookbooks"
     chef.add_recipe "dhcp_server"
     end
end

config.vm.define "yum_mirror_server" do |yum_mirror_server|
 yum_mirror_server.vm.network "public_network", bridge: "eno1", ip: "192.168.140.3", netmask: "255.255.255.0"
 yum_mirror_server.vm.provision :chef_solo do |chef|
   chef.install = false
     chef.add_recipe "yum_mirror_server"
     end
end

config.vm.define "yum_client" do |yum_client|
 yum_client.vm.network "public_network", bridge: "eno1", type: "dhcp"
 yum_client.vm.provision :chef_solo do |chef|
   chef.install = false
   chef.cookbooks_path = "cookbooks"
     chef.add_recipe "yum_mirror_client"
     end
end

config.vm.define "ci_server" do |ci_server|
 ci_server.vm.network "public_network", bridge: "eno1", ip: "192.168.140.4", netmask: "255.255.255.0"
 ci_server.vm.provision :chef_solo do |chef|
   chef.install = false
   chef.cookbooks_path = "cookbooks"
     chef.add_recipe "ci_server"
     end
end
```
We perform the provisioning of the machines by executing the ``vagrant up`` command. Next we will describe the recipes necessary to deploy each machine and its function.

#### dhcp_server  
This virtual machine is the first to be provisioned. This is provisioned with a dhcp service that provides ips in the range 192.168.140.20 to 192.168.140.100.

We can see the order of execution of the recipes in the file ``default.rb`` in the folder ``cookbooks/dhcp_server/recipes``. Here is the content of the file:
```
vi cookbooks/dhcp_server/recipes/default.rb
---
include_recipe 'dhcp_server::dhcp_install'
include_recipe 'dhcp_server::dhcp_conf'
include_recipe 'dhcp_server::dhcp_init'
---
```
The first recipe that is run is ``dhcp_install.rb``. This recipe installs the dhcp service in the machine. Then the contents of the file:
```
vi cookbooks/dhcp_server/recipes/dhcp_install.rb
---
bash 'dhcp_install' do
    user 'root'
    code <<-EOH
        yum install dhcp -y
    EOH
end
---
```
The second recipe that is executed is ``dhcp_conf.rb``. This recipe copies the configuration file ``dhcp.conf`` in the route ``cookbooks/dhcp_server/files/default`` into the machine in the path ``/etc/dhcp``. Here is the content of the files:
```
vi cookbooks/dhcp_server/recipes/dhcp_conf.rb
---
cookbook_file '/etc/dhcp/dhcpd.conf' do
    source 'dhcpd.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
---
```
```
vi cookbooks/dhcp_server/files/default/dhcp.conf
---
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
# option domain-name "example.org";
# option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# Configuring subnet and iprange
 subnet 192.168.140.0 netmask 255.255.255.0 {
 range 192.168.140.20 192.168.140.100;
# Specify DNS server ip and additional DNS server ip
 option domain-name-servers 8.8.8.8;
# Specify Domain Name
# option domain-name "itzgeek.local";
# Default Gateway
 option routers 192.168.130.1;
# option broadcast-address 192.168.140.255;
# Specify Default and Max lease time
 default-lease-time 600;
 max-lease-time 7200;
}
---
```
The last recipe that is executed is ``dhcp_init.rb`` that is responsible for starting the dhcp service from the configuration of the configuration file. Here is the content:
```
vi cookbooks/dhcp_server/recipes/dhcp_init.rb
---
bash 'dhcp_init' do
    user 'root'
    code <<-EOH
        systemctl start dhcpd.service
	      systemctl enable dhcpd.service
    EOH
end
---
```
We enter the machine through the command ``vagrant ssh dhcp_server`` and we see that the dhcp service is running with the ``systemctl status dhcp`` command. Below is a picture of the virtual machine with the service running:

![](imgs/1. dhcp status.png)  
**Figure 1**. Deployment diagram

# Distributed Systems Exam 1  
**Icesi University**  
**Course**: Distributed Systems  
**Name**: Nicolas Recalde Miranda  
**Student Github Username**: nikoremi97  
**Student ID**: A00065888  
**Topic**:Infrastructure automatization  
**Git URL**: https://github.com/nikoremi97/sd2018b-exam1.git

## Objectives  
* To make infrastructure provisioning in an autonomous way  
* To diagnose and execute in an autonomous way the actions needed to achive stable infrastructure  

## Technologies applied  
* Vagrant
* CentOS7
* Github
* Python3
* Python3 libraries: Flask, Connection, Fabric
* Ngrok  

## Description  
what is aim to do is simulate and deploy an enterprise infrastructure environment. The infrastructure consists on several virtual machines (VMs) of CentOS7. Where we have a DHCP_Server that assigns an ip for the rest of virtual machines (VM), a YUM Mirror_Server which has all packages to download from it, a client who download Mirror's packages and a Continous Integration Server (CI_Server) that updates Mirror's packages. The configuration is as follow:  
* DHCP Server (192.168.131.151): asigns an IP address to the other VM's. The network address is 192.168.131.0/24 with gateway 192.168.130.1.    
* YUM Mirror Server (192.168.131.152): Contains all packages of the enterprise to deliver to a client. The Mirror_Server gets the packages names are obtained via a JSON file (packages.json) which is in the root folder of this repository.  
* YUM Client (address obtained by dhcp): a client who can download packages from Mirror_Server.  
* CI_Server (address obtained by dhcp): this VM has a Flask application with and endpoint using RESTful architecture. The application gets a new Pull Request's content and look for the packages.json file. Using SSH, the endpoint runs the required commands to update the YUM Mirror Server packages. A Webhook is configure on this Github repository and is attached to a Pull Request on the endpoint.  

The architecture diagram is presented as follows:  
![][1]
**Figure 1.** Architecture diagram.
## Solution   
### Provisioning VMs  
Vagrant is used to provision all VMs with the correct configuration. The Vagrantfile is located in the "exam1" folder. The provisioning of each VM is described by Chef recipes located in the cookbooks folder.
## References  
* https://developer.github.com/v3/guides/building-a-ci-server/
* https://developer.github.com/v3/repos/statuses/
* https://developer.github.com/webhooks/configuring/#using-ngrok
* https://ngrok.com/docs
* https://github.com/ICESI/so-microservices-python-part1/tree/master/03_intro_swagger  


[1]: images/01_diagrama_despliegue.png

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
Vagrant is used to provision all VMs with the correct configuration. The Vagrantfile is located in the "exam1" folder. The provisioning of each VM is described by Chef recipes located in the cookbooks folder. In this folder you will find the next cookbooks:  
**dhcp**  
Cookbook that provisions the DHCP Server. Contains the next recipes:  
* dhcp_init: install dhcp into the server. 
* dhcp_config: create and replace the dhcpd.conf file.  
* dhcp_restart: enable and restart the dchpd service.  

**mirror**  
Cookbook that provisions the YUM Mirror Server. Contains the next recipes:  
* packages_config: creates a local packages.json file to provision the server.  
* packages_download: creates a python file to process download and the packages.json file content.  
* mirror_config: set up a yum repository.  
* mirror_packages: executes python file to download packages from packages.json and put them in the mirror.   
* sshd_config: create and replace the sshd_config file in order to access to this VM via CI_Server.  
* sshd_restart: restart the sshd.service to load new configuration.   

**httpd**  
Cookbook that provisions the  YUM Mirror Server. Contains the next recipes:  
* httpd_install: install the httpd service   
* httpd_config: enable and start the httpd.service   

**client**  
Cookbook that provisions the YUM Client. Contains the next recipes:  
* hosts_config: create and replace the /etc/hosts file. 
* repo_delete: delete everything on /etc/yum.repos.d/ folder in order to configure a new repo.     
* repo_config: create a new file on /etc/yum.repos.d/ called *icesirepo.   
* repo_repolist: clean and update yum configuration, disable other repository but icesirepo and list conten available  

**ci_Server**  
Cookbook that provisions the CI Server. Contains the next recipes:  
* install_tools: install wget and unzip packages.   
* install_ngrok: download, unzip and install ngrok on a new folder.  
* install_python3: install all dependencies to install python36u, pip3.6, connexion and fabric.  
* endpoint_config: creates new folders on the server to put in the right place the endpoint files.   
* endpoint_files: creates the files of the endpoint.  

### Deployment of infrastructure  
In order to deploy the infastructure correctly, the Vagrantfile is configured to deploy DHCP_Server first. Then, the VMs which receives a new IP address can run. The next commands must be typed:  

| Command | Description  |
|:-:|:-:|
| vagrant up  | Describes a new set of VMs and apply the Chef recipes for each one  |
| vagrant status  | Checks if every VM is running  |  

The next figure shows an example of the *vagrant status* command:  
![][2]  
**Figure 2.** Vagrant status.    

Now let's go to the CI_Server to test the flask application...  
In order to do that, you have to type the next command:  
```
vagrant ssh ci_server
```
This allows us to connect to the specified VM. If we have to connect to another, we have to replace *ci_server* for the name of that VM.  
The first thing we have to do is set up **ngrok**, which is a tool that exposes local servers behind NATs and firewalls to the public internet over secure tunnels. To enable *ngrok* we must type the next commands:  
![][3]  
**Figure 3.** How to active ngrok.  

Now that ngrok is active, it gave us a public url for our application. An example of it is as follows:  
![][4]  
**Figure 4.** Ngrok running.  

But, why do we have to expose our endpoint to public? This is simple, Github Webhooks allow external services to be notified when certain events happen. When the specified events happen, we’ll send a POST request to each of the URLs you provide. So to set this webhook, we must provide a public url and set json as content type, as follows:  
![][5]  
**Figure 5.** How to active Github Webhook.  

And in options, we select pull request only, as follows:  
![][6]  
**Figure 6.** Pull request option.  

The first thing we have to do to test the app is add a new content to our packages.json file. In this example I added the next packages:  
![][7]  
**Figure 7.** packages.json file update.  

Now that everything is set, to test the endpoint we have to type the next commands:  

| Command | Description  |
|:-:|:-:|
| sudo su | Loggin as root  |
| cd endpoint  | Get into the endpoint directory  |  
| export PYTHONPATH=$PYTHONPATH:`pwd`  | Set the python path environment to the current path  |  
| export FLASK_ENV=development  | Set the flask environment to development in order to test the endpoint  |  
| connexion run gm_analytics/swagger/indexer.yaml --debug -p 80 -H 127.0.0.1  | Run the app in debug mode on 127.0.0.1:80  |   

The CI_Server has download the new packages on the Mirror_Server if we get something like this:  
![][8]  
**Figure 8.** Endpoint success.  

Now, doing ssh to the mirror server, we verify if the packages has downloaded well, as follows:  
![][9]  
**Figure 9.** Verify new packages on mirror.  

Now lest move to the Client to get the new packages from mirror...
We have to type the next commands to get the new packages:
```
sudo yum clean all
sudo yum update
sudo yum --disablerepo="*" --enablerepo="icesirepo" list available
```
With the last command, we get the list of all packages availables in our mirror, as follows:  
![][10]  
**Figure 10.** New packages available.  

## Issues
To achive the objects of this exam, some issues were found. First, some of the chre recipes did not worked well, so I had to search it on Chef docs to know how it's done. Second, a static IP had to be set on the mirror server in order to configure the mirror on the client and to execute remote commands via CI_Server. Third, the sshd_conf file on the mirror server was not configure to execute ssh,  and root login on that machine. So it was needed to set a new sshd_conf file to download the new packages on it. Finally, it was not easy to process the new packages.json in the new pull request. Many tries and errors happened here, but in the end everything was possible to do.

## References  
* https://developer.github.com/v3/guides/building-a-ci-server/
* https://developer.github.com/v3/repos/statuses/
* https://developer.github.com/webhooks/configuring/#using-ngrok
* https://ngrok.com/docs
* https://docs.chef.io/
* https://connexion.readthedocs.io/en/latest/
* https://github.com/ICESI/so-microservices-python-part1/tree/master/03_intro_swagger  

[1]: images/01_diagrama_despliegue.png  
[2]: images/vagrant_status.png  
[3]: images/how_to_activate_ngrok.png  
[4]: images/ngrok_running.png  
[5]: images/how_to_activate_webhook.png  
[6]: images/select_pull_request.png  
[7]: images/update_packages_json.png  
[8]: images/download_new_packages_ngrok_200.png  
[9]: images/comprobar_descarga_de_paquetes.png 
[10]: images/list_avaiable_client.png

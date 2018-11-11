# sd2018b Exam 1
**Icesi University**  
**Course:** Distributed Systems   
**Professor:** Daniel Barragán C.  
**Subject:** Infrastructure automation  
**Email:** daniel.barragan at correo.icesi.edu.co  
**Student:** Alejandro Bueno C.  
**Student ID:** A00335472  
**Git URL:** https://github.com/abc1196/sd2018b-exam1.git  

### Expected results
* Develop the automatic provisioning of an infrastructure
* Diagnose and execute the needed actions to achieve a stable infrastructure  

### Used technologies
* Vagrant
* CentOS7 Box
* Github Repository
* Python3
* Python3 Libraries: Flask, Fabric
* Ngrok  

### Infrastructure diagram  
The desired infrastructure to deploy consists in four virtual machines (VM) with the following settings:  
* CentOS DHCP Server (192.168.180.10): must deliver an IP address to the other VM's. The network address is **192.168.180.0/24** with gateway **192.168.130.1** (the University's gateway). Also, it assigns an static IP addres to the YUM Mirror Server (192.168.180.40).  
* CentOS CI Server (dhcp): this VM has a Flask application with and endpoint using RESTful architecture best practices. The endpoint has the following logic:   
  * A Webhook attached to a Pull Request triggers the endpoint.  
  * The endpoint reads the Pull Request content and searchs for the packages.json file.  
  * Via SSH, the endpoint runs the required commands to update the YUM Mirror Server dependencies.
  * The endpoint return the packages.json content.
* CentOS YUM Mirror Server (192.168.180.40): contains the required dependencies to use in the infrastructure. These dependencies are obtained via a JSON file (packages.json) located at the root of this repository.
* CentOS YUM Client (dhcp): it has its dependencies repolist attached to the YUM Mirror Server.  
* Github Webhook: this webhook triggers when a Pull Request event is created. It calls the CI Server's endpoint.  

![][1]
**Figure 1**. Deploy Diagram  

### Provisioning  
The exam1 directory contains two key elements to deploy the infrastructure. The first one is the Vagrantfile. This file contains the provisioning required for each VM. The provisioning is implemented by the Chef recipes located in the cookbooks directory. 

#### dhcpd  
Cookbook that provisions the DHCP Server. Contains three recipes:
 *  dhcpd_install: installs the dhcp packages into the VM  
 *  dhcpd_copy_files: copies the dhcpd.conf file into the VM.
 *  dhcpd_config: starts the DHCPD service.  
 
 #### httpd
 Cookbook that provisions an httpd service. It's used in the YUM Mirror Server. Contains two recipes:
 *  httpd_install: installs the httpd packages into the VM.
 *  httpd_config: starts the httpd service.  
 
#### mirrorserver
Cookbook that provisions the YUM Mirror Server. Contains four recipes:
 *  mirrorserver_ssh: copies the sshd_config file to allow an SSH connection between the YUM Mirror Server and the CI Server. 
 *  mirrorserver_install: installs the required packages to host a Mirror Server and downloads the packages.json file located in Github.
 *  mirrorserver_python: a python script that reads the content in the packages.json and converts it in a string with the packages.
 *  mirrorserver_downloaddir: takes the string created in the python script and installs the dependencies in the YUM Mirror Server.
 
#### ciserver
Cookbook that provisions the CI Server. Contains three recipes:
 *  ciserver_copy_files: copies the application file (Python) in the VM.  
 *  ciserver_update: installs the required libraries to run a Flask application. Creates the virtual enviroment with the application ready to deploy.  
 *  ciserver_ngrok: downloads the ngrok library to create a public address to connect the endpoint with the Github Webhook.  
 
#### mirrorclient  
Cookbook that provisions the YUM Client. Contains four recipes:
 *  mirror_hosts: copies the hosts file in the VM that contain the YUM Mirror Server's IP address.    
 *  mirror_delete_repos: deletes the existing repositories to create a new one from the YUM Mirror Server
 *  mirror_repo: copies the icesi.repo file associated to the YUM Mirror Server. 
 *  mirror_yum: gets the repolist from the YUM Mirror Server.   

### Deployment  
After you clone the repository, execute the following commands:  

| Command | Description   |
|---|---|
| vagrant up dhcp_server | Provision the dhcp server first. You should do this to avoid provisioning the other VM's without a valid IP address |  
| vagrant up | Provision the rest of the VM's |  
 
Now, with a tool like **tmux**, create a session with two terminals (Ctrl +A, Shift +2). In both of them, run the next command:  

| Command | Description   |
|---|---|
| vagrant ssh ci_server | Access the CI Server VM |  

In the first terminal, you will start the Flask application. Flask was used because its simple to create and the application will run only one endpoint. A framework like Swagger can be used to build more extensive RESTful APIs. Execute the following commands:  

| Command | Description   |
|---|---|
| sudo su | Login as root |  
| cd | Get in the root dir |
| cd .. | Get in the / dir in root |  
| cd exam1 | Go to the Flask app dir |
| source exam1/bin/activate | Start the Flask virtual environment |
| export FLASK_APP=exam1.py | Export the file exam1.py as a environment variable to run the application |
| flask run | Run the application | 

In the second terminal, you will run ngrok to make the Flask application public. You have to do this to attach the endpoint to the Github's Webhook. Run these commands:  

| Command | Description   |
|---|---|
| sudo su | Login as root |  
| cd | Get in the root dir |
| cd .. | Get in the / dir in root |  
| cd ngrok | Go to the Flask app dir |
| ./ngrok http | Start the ngrok tunnel to make public the application |  

Finally, let's create the Github webhook. In the repository, go to *Settings -> Webhooks*. Add a webhook and put in the Payload URL the URL that ngrok provides with the endpoint. The application endpoint is located at */abc/exam1/api/v1/packages*. So, for example, the resulting Payload URL will look like this:  

```
http://XXXXXXXX.ngrok.io/abc/exam1/api/v1/packages
```
Where XXXXXXXX is the URL ngrok provides each time we run the ngrok command. Last, check the *Let me select individual events* and check *Pull requests*.  

With all the above steps, you should have the infrastructure provisioned and running. The VM's will look like this:

![][2]  
**Figure 2** CI Server running with Flask/Ngrok  

![][3]  
**Figure 3** DCHP Server running dhcpd service  

![][4]  
**Figure 4** YUM Mirror Server running with its dependencies. Below, the YUM Client with the YUM Mirror Server as a repository  

![][5]  
**Figure 5** Github Webhook  

### Demonstration
Go to the packages.json file and add a dependency to it. For this example, the library **nmap** was added. The file will be like this:
```
{
	"packages":
	[
		"epel-release",
		"python36u",
		"python36u-pip",
		"wget",
		"unzip",
		"nano",
		"nmap"
	]			
}
```
Commit changes and check the CI Server status. The Flask/Ngrok will return a HTTP Response 200 (OK) if the packages were installed succesfully.

![][6]  
**Figure 6** CI Server Response OK

 Go to the YUM Mirror Server and run the following command:
 ```
 ls /var/repo
 ```
 The dependency **nmap** must be in the directory. Then, go to the YUM Client and execute these commandas:
 ```
 yum clean all
 yum repolist
 yum install -y nmap
 ```
 With the commands above, the YUM Client will update its Mirror Server repository and install the new package.
 
 ![][7]  
 **Figure 7** YUM Mirror Server with the repository updated  
 
 ![][8] ![][9]  
 **Figure 8** YUM Client with the updated repository
### Issues  
During the exam, three minor issues were found. First, if the provisioning was executed with just *vagrant up*, sometimes, the VM's that were configured with DHCP, would not have an IP addres because the DHCP Server wasn't provisioned yet. To fix this, the DHCP Server was provisioned first. Then, a *vagrant up* would provision the rest of the VM's. Second, without a static IP for the Mirror YUM Server, it was necessary to edit the /etc/hosts file for the YUM Clients each time the Server was created. A MAC address was assigned to the YUM Server and that host was created in the DHCP Server to assign it a static IP address. Third, it was difficult to know how to obtain the packages.json of the Pull request. Discussing with the professor and other students, it was possible to find the location of the packages.json file by a SHA value created in the Pull request body.

### References  
* https://docs.chef.io/  
* https://github.com/ICESI/ds-vagrant/tree/master/centos7/05_chef_load_balancer_example
* https://developer.github.com/v3/guides/building-a-ci-server/
* http://www.fabfile.org/
* http://flask.pocoo.org/  
* https://connexion.readthedocs.io/en/latest/  

[1]: images/01_deploy_diagrampng.png  
[2]: images/02_ci_server_setup.PNG  
[3]: images/03_dhcp_server_setup.PNG  
[4]: images/04_yum_server_setup.PNG	
[5]: images/05_webhook_setup.PNG
[6]: images/06_ci_server_demo.PNG	
[7]: images/07_yum_server_demo.PNG  
[8]: images/08_yum_client_demo.PNG	
[9]: images/09_yum_client_demo_2.PNG  

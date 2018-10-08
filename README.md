### Exam 1
**ICESI University**  
**Subject:** Distributed Systems  
**Professor:** Daniel Barragán C.  
**Topic:** Infrastructure Automation   
**Student:** Ana Valderrama  
**Student ID:** A00065868  
**Email:** ana_fernanda_25 at hotmail.com  

### Goals
	* Perform in an autonomously way the automatic provisioning of an specific infrastructure.  
	* Diagnose and execute in an autonomously way all needed actions to achieve global stable infrastructures.  

### Used Technologies  
	* Vagrant  
	* CentOS7 Box  
	* GitHub Repository - Webhook    
	* Python  
	* Python3 libs: Flask, Connexion, Fabric  
	* Ngrok  

### Description   

To achieve the goals presented before is necessary to deploy a platform based on four virtual machines, their principal functions are described below:  
- **CentOS7 DHCP Server**  
    * It's the one that must assign an IP address to clients of the subnet **192.168.137.0** in a range between **192.168.137.15** to **192.168.137.150**. The default gateway in this case was the same as the one at the university (**192.168.130.1**).  
- **CentOS7 YUM Mirror Client**  
    * Depends on the **CentOS7 YUM Mirror Server** to be provisioned and its IP address is given by the server described before.  
- **CentOS7 YUM Mirror Server**  
	* Its provisioning depends on the packets that are listed in the file called **packages.json** that is located in the repository root. Its the one that must contain the packages to provision the clients.  
- **CentOS7 CI Server**  
	* Contains an application developed using **RESTful architecture** with an endpoint  that is connected to the **Webhook** through the use of **ngrok** that allows to connect to Internet giving a public IP address.  
	* The **Webhook** is activated when someone create a PullRequest in my repository, this server is in charge to interpret the file **packages.json** to realize the packages that have been added on the file and then it has to connect to the **CentOS7 YUM Mirror Server** and execute the commands needed to download it.  
	![][1]  
	**Figure 1.** Deploy diagram.  
##Provisioning  
 To make machines provisioning chef recipes were used, actions and commands are presented below:   
	- **CentOS7 DHCP Server**  
		To provision this server it was necessary to install *dhcp service* with the command:  
		```  
			yum -y install dhcp  
		```  
		Then changes in the file dhcpd.conf had to be done, to configure **network settings** like subnet address, range of addresses that would be assigned, etc. Once it has been done, the service is started.  
		```  
			systemctl start dhcpd.service  
		```  
	- **CentOS7 YUM Mirror Client**  
		First, to make this machine client of the **CentOS7 YUM Mirror Server** it was necessary to add the server IP address to the hosts file locate in */etc/hosts*  
		```  
			127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4  
			::1         localhost localhost.localdomain localhost6 localhost6.localdomain6  
			192.168.137.3 mirror.icesi.edu.co  
		```  
		After it's necessary to configure the repo:  
		```  
			[icesirepo]  
			name=My RPM System Package Repo  
			baseurl=http://mirror.icesi.edu.co/repo/  
			enabled=1  
			gpgcheck=0
		```  
		To deploy the client some commands to clean and create the repo were done.  
	- **CentOS7 YUM Mirror Server**  
		First, it was necessary to download some packages and start some services to deploy correctly the functions it had to achieve. ]Executing the commands that follows:  
		```   
			mkdir /var/repo  
			cd /var/repo  
			yum install -y httpd  
			systemctl start httpd  
			systemctl enable httpd  
			yum install -y createrepo  
			yum install -y yum-plugin-downloadonly  
			createrepo /var/repo/  
			ln -s /var/repo /var/www/html/repo  
			yum install -y --downloadonly --downloaddir=/var/repo python36u   python36u-libs python36u-devel python36u-pip  
			yum install -y policycoreutils-python  
			semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo  
		```  
		To achieve the function of provide packages needed to deploy services on the clients, this server had to establish a channel to communicate with **CI Server** like I mentioned before, so it was necessary to change the sshd_config file to allow the **CI Server** to connect using *SSH* and then the service had to be restarted.  
		```  
			systemctl start sshd.service  
		```   
	- **CentOS7 CI Server**  
		Initially to install some packages was necessary to download them from some url, generally they are compressed, so it was required the installation of *wget* and *unzip* (that is also used to store the endpoint files). 
		```  
			yum install wget -y  
			yum install unzip -y  
		```  
		Then *Python3* and *Pip3* were installed and then the libraries based  on the last one: *Connexion* and *Fabric*.  
		```  
			yum install -y https://centos7.iuscommunity.org/ius-release.rpm  
			yum install -y python36u python36u-libs python36u-devel python36u-pip  
			pip install --upgrade pip  
			pip3.6 install connexion  
			pip3.6 install fabric  
		```  
		After, Ngrok was downloaded, it is used to generate a public domain to use the Webhook.  
		```  
			mkdir /home/vagrant/ngrok  
			cd /home/vagrant/ngrok  
			wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip  
			unzip ngrok-stable-linux-amd64.zip  
			rm -rf ngrok-stable-linux-amd64.zip  
		```  
		Last but most important, the endpoint, for this, based on ***RESTful Architecture*** I developed a method in python located in  *handlers.py*, to handle the logic of bringing the json provided by the Webhook using *Flask* (which contains the information of pullrequest), then manage it to update the list of packages needed and install them on the **CentOS7 YUM Mirror Server** using *Fabric* to connect both servers through SSH. In the file *indexer.yaml* the path to use in the Webhook is defined there the method that is in *handlers.py* is called.
		 	* ***handlers.py***  
		 		```  
			 		import requests  
					import json  
					from fabric import Connection  
					from flask import request  

					def get_pullrequest_packages():  
					    post_json_data   = request.get_data()  
					    string_json      = str(post_json_data, 'utf-8')  
					    json_pullrequest = json.loads(string_json)  
					    pullrequest_sha  = json_pullrequest["pull_request"]["head"]["sha"]  
					    packages_url     = 'https://raw.githubusercontent.com/anavalderrama25/sd2018b-exam1/'+pullrequest_sha+'/packages.json'  
					    response_packages_url = requests.get(packages_url)  
					    packages_data    =  json.loads(response_packages_url.content)  
					    packages_line = ""  
					    for i in packages_data:  
					        packages = i['package_command']  
					        packages_line = packages_line + packages  
					    connect         = Connection('vagrant@192.168.137.3').run('sudo yum install --downloadonly --downloaddir=/var/repo ' + packages_line)  
					    out = {'command_return': 'OK'}  
					    return out  
				```   
			* ***indexer.yaml***  
			   ```    
					swagger: '2.0'  

					info:  
					  title: User API  
					  version: "0.1.0"  

					paths:  
					  /ciserver/pullrequest/updatepackages:  
					    post:  
					      x-swagger-router-controller: gm_analytics  
					      operationId: handlers.get_pullrequest_packages  
					      summary: Update packages needed to install.  
					      responses:  
					        200:  
					          description: Successful response.  
					          schema:  
					            type: object  
					            properties:  
					              command_return:  
					                type: string  
					                description: User pullrequest information. 
				```  
### Deployment  
	Once all these was realized was time to prove it, if you were lucky all the machines will start to run after execute vagrant up. 
	First, I did a pullrequest to my repository with the packages.json containing only one package.
	![][2]  
	**Figure 2.** Packages.json content.  
	When 4 machines were activated, I opened **CI Server** using vagrant SSH, there it was required to generate a private key to share only with **Mirror Server**.  
	![][3]  
	**Figure 3.** SSH Generation Key to establish a SSH channel between **CI Server** and **Mirror Server**.  
	Then I started Ngrok in the **CI Server** and in another tab inside endpoint file in the CI Machine I execute the commands to deploy the endpoint correctly (some environmental variables) allowing the connection through 8080 port, only when the Webhook was deployed to using the public domain given by Ngrok.
	At the beginning I had several failed attempts (this can be observed in the picture below), that was because I had some errors in the syntax of the *packages.json* and in *handlers.py*. 
	![][4]  
	**Figure 4.** Ngrok deploy.    
	When I managed to correct all syntax errors, the goal was achieved. It can be observed before a **200 OK*** message. In the debug of **CI Server** it can be seen that the package is been installed, then I proved it on **Mirror Server** and **Mirror Client** (it was necessary to update the repo), *nmap* was installed!.  
	![][5]  
	**Figure 5.** **CI Server** Debugger.   
	![][6]  
	**Figure 6.** Mirror Server with nmap installed.  
	![][7]  
	**Figure 7.** Update of the repo in **Mirror Client**.  
	![][8]  
	**Figure 8.** Package nmap on **Mirror Client**.   


### Issues  
	* An issue occurred several times when turning on the machines because of the provisioning wasn't well done.
	* Another was during the *yum update* on the **Mirror Server** it takes a lot of time, and sometimes the connection was lost, and the machine didn't achieve the provisioning and I had to destroy and up it again. 
	* I had a lot of errors in the syntax for that reason I had to try again and again after fix each one, because I didn't realize all in one revision.  
	* The **Mirror Client** didn't update the repo automatically so I had to do it manually.


### References  
	* https://docs.chef.io/  
	* https://github.com/ICESI/ds-vagrant/tree/master/centos7/05_chef_load_balancer_example  
	* https://developer.github.com/v3/guides/building-a-ci-server/  
	* http://www.fabfile.org/  
	* http://flask.pocoo.org/  
	* https://connexion.readthedocs.io/en/latest/  
  
[1]: images/DeployDiagram.png
[2]: images/SSHKeyGeneration.png  
[3]: images/PackagesJSON.PNG  
[4]: images/NGROK.png  
[5]: images/CIDebug.png  
[6]: images/MirrorServerDownloadPackage.png  
[7]: images/MirrorClientUpdateRepo.png  
[8]: images/MirrorClientNmap.png  



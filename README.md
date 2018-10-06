### Exam 1
**ICESI University**  
**Subject:** Distributed Systems  
**Professor:** Daniel Barragán C.  
**Topic:** Infrastructure Automation   
**Student:** Ana Valderrama  
**Student ID:** A00065868  
**Email:** ana_fernanda_25@hotmail.com  

### Goals
* Perform in an autonomously way the automatic provisioning of an specific infrastructure.  
* Diagnose and execute in an autonomously way all needed actions to achieve global stable infrastructures.  

### Used Technologies  
* Vagrant  
* CentOS7 Box  
* GitHub Repository - Webhook    
* Python3  
* Python3 libs: Flask, Connexion, Fabric  
* Ngrok  

### Description   

To achieve the goals presented before is necessary to deploy a platform based on four virtual machines, their principal functions are described below:  
- **CentOS7 DHCP Server**  
    * It's the one that must assign an IP address to clients of the subnet **192.168.137.0** in a range between **192.168.137.15** to **192.168.137.150**. The default gateway in this case was the same as the one at the university (**192.168.130.1**).  
- **CentOS7 YUM Mirror Client**
    * Depends on the **CentOS7 YUM Mirror Server** 

### Examen 1
**Universidad ICESI**  
**Curso:** Sistemas Distribuidos  
**Docente:** Daniel Barragán C.  
**Tema:** Automatización de infraestructura  
**Correo:** daniel.barragan at correo.icesi.edu.co  
**Estudiante:** Jorge Eliecer Castaño Valencia  
**Codigo:** A00315284


### Objetivos
* Realizar de forma autónoma el aprovisionamiento automático de infraestructura
* Diagnosticar y ejecutar de forma autónoma las acciones necesarias para lograr infraestructuras estables

### Tecnlogías utilizadas para el desarrollo del examen
* Vagrant
* Box del sistema operativo CentOS7
* Repositorio Github
* Python
* Librerias Python3: Flask, Connexion, Fabric
* Ngrok

### Descripción
Despliegue de una plataforma con los siguientes requerimientos:

* Repositorio de Github que corresponde a un fork del repositorio **sd2018b-exam1**

* El repositorio tiene un Vagrantfile que permite el despliegue de tres máquinas virtuales con las siguientes características:
  * CentOS7 DHCP Server
  * CentOS7 CI Server
  * CentOS7 YUM Mirror Server
  * CentOS7 YUM Client

* El **CentOS7 DHCP Server** entrega una dirección IP a las demas máquinas virtuales a través de una interfaz pública.

* Hay un listado de los paquetes a instalar en el **CentOS7 YUM Mirror Server** en un archivo llamado **packages.json** en la raíz del repositorio.  Este listado es usado para inyectar la lista de paquetes en el recurso de chef correspondiente encargado de hacer la descarga de los mismos. Al momento de ejecutar el comando vagrant up, el aprovisionamiento usa el contenido del archivo **packages.json** para hacer la descarga de los paquetes a almacenar en el **CentOS7 YUM Mirror Server**.

* Se realizo una la configuración de un webhook en su repositorio de Github para que al momento de abrir un Pull Request a la rama master, se envie la información del repositorio a un endpoint en el **CentOS7 CI Server**

* El **CentOS7 CI Server** contiene una aplicación desarrollada en Flask (con arquitectura RESTful) con un endpoint para recibir la información desde Github.

* El **CentOS7 CI Server** realiza las siguientes tareas dentro de la lógica del endpoint:

 * El **CentOS7 CI Server** lee el archivo **packages.json** con el listado de los paquetes a descargar en el **CentOS7 YUM Mirror Server**. El archivo **packages.json** es interpretado por el **CentOS7 CI Server** y de forma remota ejecuta los comandos necesarios para hacer la actualización de los paquetes del **CentOS7 YUM Mirror Server.**


![][1]
**Figura 1**. Diagrama de Despliegue

### Actividades

1. Documento README.md en formato markdown:  
  * Formato markdown (5%)
  * Nombre y código del estudiante (5%)
  * Ortografía y redacción (5%)

2. Consigne en el README.md los comandos de Linux necesarios para el aprovisionamiento de los servicios solicitados. En este punto no debe incluir recetas solo se requiere que usted identifique los comandos o acciones que debe automatizar con la respectiva explicación de los mismos (15%)

3. Escriba el archivo Vagrantfile para realizar el aprovisionamiento, teniendo en cuenta definir:
maquinas a aprovisionar, interfaces solo anfitrión, interfaces tipo puente, declaración de cookbooks (10%)

4. Escriba los cookbooks necesarios para realizar la instalación de los servicios solicitados (20%)

5. El informe debe publicarse en un repositorio de github el cual debe ser un fork de https://github.com/ICESI-Training/sd2018b-exam1 y para la entrega deberá hacer un Pull Request (PR) al upstream, para el examen NO cree un directorio con su código. El código fuente y la url de github deben incluirse en el informe. (15%).
Tenga en cuenta que el repositorio debe contener todos los archivos necesarios para el aprovisionamiento.

6. Incluya evidencias que muestran el funcionamiento de lo solicitado. (15%)

7. Documente algunos de los problemas encontrados y las acciones efectuadas para su solución al aprovisionar la infraestructura y aplicaciones. (10%)

## Desarrollo  

### 1. :heavy_check_mark:


### 2.  Self-provision of infrastructure  

For the development of this test, a machine was used centos1706_v0.2.0.

#### vagrant up results in box with no ssh permissions while deploying

Version 1.8.5 of vagrant has an issue related with ssh keys. Workaround is to add a configuration parameter in the Vagrantfile. Also take into account that when you use a box without chef you have to provision it manually using shell inline provisioner.  

solution:  
```
$ vagrant init centos1706_v0.2.0
$ vagrant up
$ vim Vagrantfile
config.ssh.insert_key = false
```

#### vagrant package results in box with no guest additions

solution:
```
$ vagrant up
$ vagrant ssh -c 'sudo rm -f /etc/udev/rules.d/60-vboxadd.rules'
$ vagrant package --output CentosOS-7....
```

or let vagrant to re-install guest additions for you (not recommended)

```
$ vagrant plugin install vagrant-vbguest
```

#### vagrant ssh results in permission denied

solution:
```
config.vm.provision "shell", inline: <<-SHELL
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
SHELL
```

To access the machines after lifting them with the command:
```
vagrant up
```
You can access the machines with the command:
```
vagrant ssh machine
```  
Where "machine" is the name of the machine established in the vagrantfile.  

**Note:** to destroy the machines the command is used ```vagrant destroy```


### 3.  Vagrantfile to perform the provisioning  

In the created VagrantFile file, a Multi-Machine configuration is made with the required machines that are:  
- DHCP_Server:  
Where the dhcp is provisioned with chef and configured with files for defects in the cookbooks (dhcp).
The network configuration is:
```
dhcpServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.150", netmask: "255.255.255.0"
```  

- CI_Server:  
Where the ci is provisioned with chef and configured with files for defects in the cookbooks (wget, unzip,ngrok, flask_endpoint and python36).
The network configuration is:
```
ciServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.151", netmask: "255.255.255.0"
```  

- Mirror_Server:  
Where the mirror is provisioned with chef and configured with files for defects in the cookbooks (wget, unzip, ngrok, flask_endpoint and python36).  
The network configuration is:
```
mirrorServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.152", netmask: "255.255.255.0"
```  

- YUM_Client:  
Where the client is provisioned with chef and configured with files for defects in the cookbooks (icesi.repo and host).
The network configuration is:
```
mirrorClient.vm.network "public_network", bridge: "eno1", type: "dhcp"
```  

### 4. :heavy_check_mark:
```
➜  cookbooks git:(jcastano/sd2018b-exam1) tree
.
├── ci
│   ├── files
│   │   └── default
│   │       └── flask_endpoint
│   │           ├── gm_analytics
│   │           │   ├── handlers.py
│   │           │   └── swagger
│   │           │       └── indexer.yaml
│   │           ├── requirements.txt
│   │           └── scripts
│   │               └── deploy.sh
│   └── recipes
│       ├── ci_setup.rb
│       ├── default.rb
│       ├── endpoint_install.rb
│       └── python_install.rb
├── client
│   ├── files
│   │   └── default
│   │       ├── hosts
│   │       └── icesi.repo
│   └── recipes
│       ├── default.rb
│       ├── hosts_config.rb
│       ├── repo_config.rb
│       ├── repo_delete.rb
│       └── repo_update.rb
├── dhcpd
│   ├── files
│   │   └── default
│   │       └── dhcpd.conf
│   └── recipes
│       ├── default.rb
│       ├── dhcpd_config.rb
│       ├── dhcpd_install.rb
│       └── dhcpd_start.rb
├── httpd
│   ├── files
│   │   └── default
│   └── recipes
│       ├── default.rb
│       ├── httpd_config.rb
│       └── httpd_install.rb
└── mirror
    ├── files
    │   └── default
    │       ├── packages.json
    │       └── setup.py
    └── recipes
        ├── default.rb
        ├── mirror_config.rb
        ├── packages_install.rb
        ├── packages_setup.rb
        └── packages_update.rb
```

### 5. :heavy_check_mark:
The project's URL is:
https://github.com/MasterKr123/sd2018b-exam1

### 6. :heavy_check_mark:

#### process  
* We have to deploy the machines.  
![][2]  
**Figura 2**. Vagrant up successful.  

* We can see that there is no package.  
![][3]  
**Figura 3**. Any packages.  

* So we have to configure the ssh key between the CI Server and the Mirror Server.  
![][4]  
**Figura 4**. Key generated and shared.  

* We have to activate the Ngrok service.  
![][5]  
**Figura 5**. Ngrok up.  
* When doing a pullrequest you can see an OK request in the CI server.  

![][6]  
**Figura 6**. Request OK.  

* We can see that the packages are installed with the pullrequest.  
![][7]  
**Figura 7**. Endpoint successful.  

* Finally, we can see that the packages were installed.  
![][8]  
**Figura 8**. Packages installer.  

### 7. Problems encountered and actions taken

**Connection issues:**  
As in many of the projects carried out, connectivity has been a problem. To deal with this, an inspection was performed according to the OSI model starting from the lowest level to the highest level.  

**Start problems:**  
At the beginning of a project like this there is an insertion of where to start. What he realized was to order and prioritize the machines according to the dependence with the others.  

**Complex automate functions:**  
There were complicated functions to automate, such as the automation of package installation. This was done through investigation and error test. However, some functions have a more complex level of automation such as obtaining the Ngrok link and configuring the webhook with that new link and the endpoint. As it could not be automated, this small function is done manually.


### Referencias
* https://docs.chef.io/  
* https://github.com/ICESI/ds-vagrant/tree/master/centos7/05_chef_load_balancer_example
* https://developer.github.com/v3/guides/building-a-ci-server/
* http://www.fabfile.org/
* http://flask.pocoo.org/
* https://connexion.readthedocs.io/en/latest/  
* https://github.com/ICESI/ds-vagrant/tree/master/centos7
* https://github.com/juanswan13/sd2018b-exam1/


[1]: images/01_diagrama_despliegue.png
[2]: images/02_vagrantup_succesful.png
[3]: images/08_non_packages.png
[4]: images/03_Ci_keyGen.png
[5]: images/04_ngrok.png
[6]: images/05_httpOk.png
[7]: images/06_connectPackages.png
[8]: images/07_packagesInstaller.png

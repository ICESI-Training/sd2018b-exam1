### Examen 1

**Universidad ICESI**  
**Estudiante:** Juan Camilo Swan  
**Código:** A00054620  
**Curso:** Sistemas Distribuidos  
**Correo:** juanswan13 at hotmail.com  

**Docente:** Daniel Barragán C  
**Correo:** daniel.barragan at correo.icesi.edu.co

**Tema:** Automatización de infraestructura  

### Objetivos
* Realizar de forma autónoma el aprovisionamiento automático de infraestructura
* Diagnosticar y ejecutar de forma autónoma las acciones necesarias para lograr infraestructuras estables

### Tecnlogías sugeridas para el desarrollo del examen
* Vagrant
* Box del sistema operativo CentOS7
* Repositorio Github
* Python3
* Librerias Python3: Flask, Connexion, Fabric
* Ngrok

### Descripción
Deberá desplegar una plataforma que cumpla con los siguientes requerimientos:

* Debe tener un repositorio de Github que corresponda a un fork del repositorio **sd2018b-exam1**
* El repositorio debe tener un Vagrantfile que permita el despliegue de tres máquinas virtuales con las siguientes características:
  * CentOS7 DHCP Server
  * CentOS7 CI Server
  * CentOS7 YUM Mirror Server
  * CentOS7 YUM Client
* El **CentOS7 DHCP Server** deberá entregar una dirección IP a las demas máquinas virtuales a través de una interfaz pública
* Deberá tener un listado de los paquetes a instalar en el **CentOS7 YUM Mirror Server** en un archivo llamado **packages.json** en la raíz del repositorio
* Este listado debe ser usado para inyectar la lista de paquetes en el recurso de chef correspondiente encargado de hacer la descarga de los mismos. Al momento de ejecutar el comando vagrant up, el aprovisionamiento deberá usar el contenido del archivo **packages.json** para hacer la descarga de los paquetes a almacenar en el **CentOS7 YUM Mirror Server**.
* Deberá realizar la configuración de un webhook en su repositorio de Github para que al momento de abrir un Pull Request a la rama master, se envie la información del repositorio a un endpoint en el **CentOS7 CI Server**
* El **CentOS7 CI Server** deberá contener una aplicación desarrollada en Flask o en algún framework de su preferencia (emplear arquitectura RESTful) con un endpoint para recibir la información desde Github
* El **CentOS7 CI Server** realizará las siguientes tareas dentro de la lógica del endpoint:
 * El **CentOS7 CI Server** deberá leer el archivo **packages.json** con el listado de los paquetes a descargar en el **CentOS7 YUM Mirror Server**
 * El archivo **packages.json** deberá ser interpretado por el **CentOS7 CI Server** y de forma remota deberá ejecutar los comandos necesarios para hacer la actualización de los paquetes del **CentOS7 YUM Mirror Server**
 * Si los comandos se ejecutan exitosamente se deberá colocar un mensaje de actualización existosa en el Pull Request, de lo contrario se deberá colocar un mensaje con la información del fallo
* Deberá realizar la comprobación en el **CentOS7 YUM Client** de que el paquete ha sido añadido exitosamente en el **CentOS7 YUM Mirror Server**

![][1]  
**Figura 1**. Diagrama de Despliegue  

### Desarrollo del Examen  
Para realizar el examen se implementó un archivo **Vagrantfile** que permite desplegar los servidores y maquinas requeridas para cumplir con los objetivos del proyecto:
* CentOS7 DHCP Server
* CentOS7 CI Server
* CentOS7 YUM Mirror Server
* CentOS7 YUM Client  

Todas estas maquinas son provionadas mediante recetas de chef con las que se instala y configura en cada equipo las dependencias necesarias para su correcto funcionamiento.

**1.  DHCP Server**  
Para aprovisionar este servidor se implementaron tres recetas chef que permiten instalar el servicio dhcp:
```
bash 'yum_install_dhcp' do
	  code <<-EOH
	     yum install dhcp -y
  	  EOH
end
```
Una vez instalado el servicio se copia un archivo de configuración base de dhcp que contiene los parametros del rango de la red, la subred a la que pertenece y la puerta de enlace predeterminada. Estos parametros son los que se han establecido para los servidores presentes en el despliegue del examen. Aqui se muestra la receta de chef con la que se copia el archivo que se encuentra almacenado en files/default:
```
cookbook_file '/etc/dhcp/dhcpd.conf' do
	source 'dhcpd.conf'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
```
Para finalizar el aprovisionamiento de este servidor se inicializa el servicio:
```
bash 'systemctl_start_dhcpd' do
	  code <<-EOH
	      systemctl start dhcpd.service	      
	  EOH
end
```
**2.  YUM Client**  
Para aprovisionar esta maquina se implementaron  recetas chef que permiten configurar un cliente que contenga dentro del archivo de hosts la direccion del CI Server, por motivos del proyecto se eliminan todos los mirror configurados en la maquina y unicamente se deja el mirror creado en el desarrollo del examen:

* crea el archivo  de hosts almacenado en files/default (action :create), si ya existe lo reemplaza, en la ubicación /etc/hosts
```
cookbook_file '/etc/hosts' do
    source 'hosts'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
```
* elimina todos los mirror
```
bash 'mirror_delete_repos' do
    cwd '/etc/yum.repos.d'
    code <<-EOH
    rm -rf *
    EOH
end
```
* crea el archivo  de icesi.repo almacenado en files/default (action :create), si ya existe lo reemplaza, en la ubicación '/etc/yum.repos.d/'. Este archivo de texto contine la especificación del mirror:
```
cookbook_file '/etc/yum.repos.d/icesi.repo' do
    source 'icesi.repo'
    owner 'root'
    group 'root'
    mode '0577'
    action :create
end
```

**3.  YUM Mirror Server**   
Aprovisionar este servidor es muy importante para el proyecto, a este servidor es al que los clientes consultan y acceden para instalar los paquetes y las aplicaciones. Para poder proveer este servicio se debe instalar un servidor web. Para esto se utiliza una receta de httpd que ya ha sido probada anteriormente. además se debe configurar la maquina indicandole que se va a utilizar como un Mirror Server. para esto se utiliza la siguiente receta:

* Configuracion del servidor como un Mirror Server:
```
bash 'mirror_server_config' do
    user 'root'
    code <<-EOH
    yum update
    mkdir /var/repo
    cd /var/repo
    systemctl start httpd
    systemctl enable httpd
    yum install -y createrepo
    yum install -y yum-plugin-downloadonly
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    yum install -y policycoreutils-python
    createrepo /var/repo/
    ln -s /var/repo /var/www/html/repo
    semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo
    EOH
end
```
* Además se debe configurar el archivo de ssh permitiendo las conexiones por medio de ssh, esto se hace con el fin de que en el futuro el CI Server ejecute comandos en este servidor por medio de ssh. Para configurar el servicio de ssh se debe modificar el archivo de configuración y reiniciar el servicio. esto se hace de la siguiente forma:
```
cookbook_file '/etc/ssh/sshd_config' do
	source 'sshd_config'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
```
```
bash 'init_ssh' do
  user 'root'
  code <<-EOH
  systemctl reload sshd.service
  EOH
end
```
**4.  CI Server**


[1]: images/01_diagrama_despliegue.png

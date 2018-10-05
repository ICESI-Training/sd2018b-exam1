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

### Examen Desplegado  

En esta sección del informe se muestra el examen siendo ejecutado demostrando su correcto funcionamiento.  
A continuación se muestra un video con el funcionamiento del examen. Primero se muestra que el Mirror Server se encuentra vacio, no cuenta con ningun paquete para brindar a sus clientes. Luego se muestra el ngrok y el endpoint corriendo en el CI Server y se con el link del ngrok se actuliza el webhook. Despues se muestra el packages.json que contiene 3 paquetes a instalar, posteriormente se hace pull request y se muestra cómo el CI Server responde ante esta pull request, se alcanza a a ver que se esta realizando la descarga de los paquetes y por último se muestra como se recibe en la consola del ngrok un mensaje de confirmación 200 OK, lo mismo que en la consola del endpoint 200 OK; esto indicando que el proceso del CI Server se realizó con exito. Para comprobar se muestra en el Mirror Server que antes se encontraba vacío y ahora cuenta con los paquetes que estaban indicados en el packages.json que se mostró en el git.

Ahora se evidencia todo el proceso para lograr el despliegue.  
  
 **1.** Primero se debe desplegar todas las maquinas de forma inicial y si el aprovisionamiento se realizó de forma correcta chef deberia terminar de forma exitosa.  
esto se realiza mediante el comando:
```
vagrant up
```
![][2]  
**Figura 2**.  Evidencia vagrant up exitoso
  
**2** Una vez que se cuenta con la infraestructura desplegada se debe configurar la clave ssh entre el CI Server y el Mirror Server para que se permita la conexión ssh más adelante. Esto se realizó de la siguiente forma:  
  
![][3]  
**Figura 3**.  Configuracion de las llaves ssh  
  
**3** Se evidencia que inicialmente el Mirror Server no cuenta con ningún paquete ya que el packages.json se encontraba vacio.   
  
![][4]  
**Figura 4**.  Mirror server vacio, sin paquetes para ofrecer.  
  
**4** Se evidencia que ngrok esta en funcionamiento.   
  
![][5]  
**Figura 5**.  Consola de ngrok.  

**5** Ahora que ya se tiene una url con la que se puede acceder al CI Server desde internet se procede a configurar el webhook. La configuración del webhook es la siguiente:
  
![][6]  
![][7]  
**Figura 6**.  Configuración del webhook.  

**6** Se evidencia que el endpoint se encuentra en ejecución sin errores:
  
![][8]   
**Figura 7**.  endpoint en ejecución sin errores.  

**7** Se hizo una pull request y se evidencia que el endpoint recibe la solicitud y la procesa, en la captura el CI Server ya se encuentra realizando la descarga de los paquetes en el Mirror Server:
  
![][9]   
**Figura 8**.  endpoint en funcionamiento. 

**8** Se evidencia que tras haber realizado el metodo del endpoint, el servidor web recibe un mensaje de confirmación 200 OK:  
  
![][10]   
**Figura 9**.  consola del ngrok confirmando que el proceso fue exitoso. 

**9** Para terminar de confirmar que el proceso fue un exito se muestra que los paquetes ya se encuentran descargados en el servidor Mirror Server:  
  
![][11]   
**Figura 10**.  Mirror Server mostrando los paquetes ya instalados. 

**10** Por último, se muestra que el servidor Mirror Server funciona de forma correcta ofreciendo los paquetes que tiene descargados a sus clientes. Para esto se hizo uso del Yum Client, esta maquina tiene como unico repositorio de archivos al servidor Mirror Server. Es decir que de la unica fuente donde puede descargar aplicaciones es desde nuestro propio servidor. Para comprobar que el servidor estaba funcionando de forma correcta desde el Yum Client se realizó la instalacion de la aplicación tree.
  
![][12]   
**Figura 11**.  Evidencia buen funcionamiento Mirror Server y Yum Client. 

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
Este es el servidor que se encarga de la interacción entre las modificaciones del repositorio en git y el servidor local Mirror Server. Cuando en git se haga un pull request, este servidor es notificado y debe revisar el archivo packages.json del pull request y por medio de ssh instalar los nuevos paquetes en el Mirror Server. Esto se logra mediante la implementación de un API REST utilizando swagger y python3. Para lograr que este servidor funcione como se ha previsto, se le debe aprovisionar python3, el pip de python3, algunas herramientas y utilidades de python3, ngrok (permite exponer el servidor a internet para que pueda ser alcanzado por el webhook de git) y el API REST que ha sido implementado. Para este aprovisionamiento se ha diseñado la siguiente receta.  

* Instalacion de ngrok. Para poder instalar este servicio se debe primero instalar wget y unzip.
```
bash 'install_wget' do
  user 'root'
  code <<-EOH
  yum install wget -y
  EOH
end
```
```
bash 'install_unzip' do
  user 'root'
  code <<-EOH
  yum install unzip -y
  EOH
end
```
```
bash 'install_ngrok' do
	  code <<-EOH
	     mkdir /home/vagrant/ngrok
	     cd /home/vagrant/ngrok
	     wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	     unzip ngrok-stable-linux-amd64.zip
	     rm -rf ngrok-stable-linux-amd64.zip
  	  EOH
end
```
* Instalación de python3 y todas las demás utilidades necesarias
```
bash 'install_python3_tools' do
	  code <<-EOH
	     yum install -y https://centos7.iuscommunity.org/ius-release.rpm
	     yum install -y python36u
	     yum install -y python36u-pip
             yum install -y python36u-devel.x86_64
	     pip install --upgrade pip
             pip3.6 install connexion
	     pip3.6 install fabric
  	  EOH
end
```

* instalación del endpoint, el endpoint ya se encuentra diseñado e implementado y esta almacenado en la carpeta files/default. En este metodo lo que se hace es crear toda la ruta de archivos del endpoint dentro del CI Server y posteriormente ir copiando los archivos que se encuentran en /files/default.

```
bash 'set_endpoint' do
	  code <<-EOH
	     mkdir /home/vagrant/request_handler
	     cd /home/vagrant/request_handler
	     mkdir scripts
	     mkdir gm_analytics
	     cd gm_analytics
	     mkdir swagger
  	  EOH
end

cookbook_file '/home/vagrant/request_handler/requirements.txt' do
	source 'endpoint/requirements.txt'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/scripts/deploy.sh' do
	source 'endpoint/scripts/deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/gm_analytics/handlers.py' do
	source 'endpoint/gm_analytics/handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/gm_analytics/swagger/indexer.yaml' do
	source 'endpoint/gm_analytics/swagger/indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end
```  


[1]: images/01_diagrama_despliegue.png
[2]: images/vagrantup_exitoso.png
[3]: images/ssh_config_keys.png
[4]: images/mirror_server_empty.png
[5]: images/ngrok_working.png
[6]: images/weebhool_config1.png
[7]: images/weebhook_config2.png
[8]: images/endpoint_playing.png
[9]: images/endpoint_installing_packages.png
[10]: images/post_works.png
[11]: images/mirror_server_full.png
[12]: images/mirror_client_working.png

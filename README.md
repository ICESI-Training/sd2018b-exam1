### Examen 1
**Universidad ICESI**  
**Estudiante:** Julián David González
**Código:** A00315288
**Correo estudiante:** juliand7gj@hotmail.com
**Curso:** Sistemas Distribuidos  
**Docente:** Daniel Barragán C.  
**Tema:** Automatización de infraestructura  
**Correo docente:** daniel.barragan at correo.icesi.edu.co
**Git URL:** https://github.com/juliand7gj/sd2018b-exam1/tree/jgonzalez/sd2018b-exam1 

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

### Opcional
* Configurar un servidor DNS y registrar un subdominio para el **CentOS7 YUM Mirror Server**
* Reservar una dirección IP en el **CentOS7 DHCP Server** para el **CentOS7 YUM Mirror Server**
* Si configura la direccion IP del servidor DNS correctamente en el **CentOS7 YUM Client**, no será necesario modificar el archivo /etc/hosts para obtener un ping exitoso al subdominio del **CentOS7 YUM Mirror Server**

### Actividades
1. Documento README.md en formato markdown:  
  * Formato markdown (5%)
  * Nombre y código del estudiante (5%)
  * Ortografía y redacción (5%)
2. Consigne en el README.md los comandos de Linux necesarios para el aprovisionamiento de los servicios solicitados. En este punto no debe incluir recetas solo se requiere que usted identifique los comandos o acciones que debe automatizar con la respectiva explicación de los mismos (15%)
3. Escriba el archivo Vagrantfile para realizar el aprovisionamiento, teniendo en cuenta definir:
maquinas a aprovisionar, interfaces solo anfitrión, interfaces tipo puente, declaración de cookbooks (10%)
4. Escriba los cookbooks necesarios para realizar la instalación de los servicios solicitados (20%)
5. El informe debe publicarse en un repositorio de github el cual debe ser un fork de https://github.com/ICESI-Training/sd2018b-exam1 y para la entrega deberá hacer un Pull Request (PR) al upstream, para el examen NO cree un directorio con su código. El código fuente y la url de github deben incluirse en el informe (15%). Tenga en cuenta que el repositorio debe contener todos los archivos necesarios para el aprovisionamiento
6. Incluya evidencias que muestran el funcionamiento de lo solicitado (15%)
7. Documente algunos de los problemas encontrados y las acciones efectuadas para su solución al aprovisionar la infraestructura y aplicaciones (10%)

### Solucion

1. Hecho!

2. Los comando para el aprovisionamiento de los servicios solicitados son: 

```
vagrant up
```

Y para acceder a cada maquina: 

```
vagrant ssh machine
```

3. En el archivo vagrantfile, se aprovisionan las maquinas en el siguiente orden: 

1. DHCP_Server
2. Mirror_Server
3. YUM_Client
4. CI_Server

```
Vagrant.configure("2") do |config|
 config.vm.box = "centos1706_v0.2.0"

#DHCP--------------------------------------------------------------------------------------

  config.vm.define "DHCP_Server" do |dhcpServer|
    dhcpServer.vm.box = "centos1706_v0.2.0"
    dhcpServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.20", netmask: "255.255.255.0"
    dhcpServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "dhcpd"
	chef.add_recipe "httpd"
    end  
  end

#Mirror--------------------------------------------------------------------------------------

  config.vm.define "Mirror_Server" do |mirrorServer|
    mirrorServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.22", netmask: "255.255.255.0"
    mirrorServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
	chef.add_recipe "httpd"
       chef.add_recipe "mirror"
    end
  end

#Client--------------------------------------------------------------------------------------

  config.vm.define "YUM_Client" do |mirrorClient|
    mirrorClient.vm.network "public_network", bridge: "eno1", type: "dhcp"
    mirrorClient.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	chef.add_recipe "httpd"
        chef.add_recipe "client"
	
    end
  end
#CI--------------------------------------------------------------------------------------------

  config.vm.define "CI_Server" do |ciServer|
    ciServer.vm.box = "centos1706_v0.2.0"
    ciServer.vm.network "public_network", bridge: "eno1", ip:"192.168.131.21", netmask: "255.255.255.0"
    ciServer.vm.provision :chef_solo do |chef|
       chef.install = false
       chef.cookbooks_path = "cookbooks"
       chef.add_recipe "ci"
	chef.add_recipe "httpd"
    end
  end


end
```

#### DHCP_Server

Lo primero que se hace para el DHCP es intalarlo, despues se copia el archivo de configuración base de DHCP. Y por ultimo, se inicia el servicio. 

```
include_recipe 'dhcpd::dhcpd_install'
include_recipe 'dhcpd::dhcpd_config'
include_recipe 'dhcpd::dhcpd_start'
```

#### Mirror_Server

Lo primero que se hace es la instalación del mirror, despues se descargan los paquetes necesarios y se configuran. Despues se instalan esos paquetes, se hace la configuración del SSH y por ultimo se inicia el SSH. 

```
include_recipe 'mirror::mirror_config'
include_recipe 'mirror::packages_update'
include_recipe 'mirror::packages_setup'
include_recipe 'mirror::packages_install'
include_recipe 'mirror::config_ssh'
include_recipe 'mirror::init_ssh'
```

#### YUM_Client

Primero se crea el archivo hosts, despues se borran todos los mirror, despues se configura y por ultimo se alza. 

```
include_recipe 'client::hosts_config'
include_recipe 'client::repo_delete'
include_recipe 'client::repo_config'
include_recipe 'client::repo_update'
```

#### CI_Server

Aqui se debe tener en cuenta la instalación de wget, unzip y el ngrok, despues se instala el ednpoint y el python. 

```
include_recipe 'ci::ci_setup'
include_recipe 'ci::endpoint_install'
include_recipe 'ci::python_install'
```

4. En el punto anterior se explican los cookbooks necesarios para realizar la instalación de los servicios solicitados.

5. Este punto esta en el encabezado de este documento. 

6. 

![][2]

**Figura 2**. Vagrant up


![][3]

**Figura 3**. Configuración de las llaves SSH


![][4]

**Figura 4**. NGROK

![][5]
![][6]

**Figura 5**. Webhook


![][7]

**Figura 6**. Endpoint


![][8]

**Figura 7**. Instalación de paquetes



7. Al inicio del examen, ocurrió lo mismo que en otros examenes o proyectos, es que no se sabe exactamente por donde comenzar, porque no se entiende muy bien lo que se debe realizar. Despues empezaron a haber problemas en en las recetas por errores en la instalación y configuración de los paquetes necesarios. La configuración del webhook al inicio es un poco complicada porque se debe realizar manualmente esta tarea. Otro error muy comun, es el eror humano, que fue la confución con las IP´s o que no colocabamos bien algunos comandos. 

### Referencias
* https://docs.chef.io/  
* https://github.com/ICESI/ds-vagrant/tree/master/centos7/05_chef_load_balancer_example
* https://developer.github.com/v3/guides/building-a-ci-server/
* http://www.fabfile.org/
* http://flask.pocoo.org/
* https://connexion.readthedocs.io/en/latest/
* https://github.com/juanswan13/sd2018b-exam1/tree/jswan/exam1

[1]: images/01_diagrama_despliegue.png
[2]: images/1.png
[3]: images/11.png
[4]: images/5.png
[5]: images/9.png
[6]: images/10.png
[7]: images/4.png
[8]: images/7.png

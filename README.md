# Examen 1
**Universidad Icesi**  
**Nombre del estudiante:** Luis Alejandro Tróchez  
**ID del estudiante:** A00054648
**Repositorio:** https://github.com/zehcort/sd2018b-exam1
**Email:** zehcort@hotmail.es  
**Materia:** Sistemas Distribuidos    
**Profesor:** Daniel Barragán C.  
**Tema:** Automatización de Infraestructura 


## Descripción
En el siguiente informe, se presenta la implementación de una infraestructura de aprovisamiento automático. Esta solución tiene como objetivo principal el montaje de un servidor mirror que sirva como repositorio de los paquetes que necesitan los dispositivos del contexto local sin necesidad de acudir a internet y pasar por el cuello de botella que representa la salida de la red. Dicha labor será conseguida mediante el montaje de un servidor DHCP (DHCP SERVER) que provea de direcciones IP no estáticas a los equipos locales, un servidor mirror (MIRROR SERVER) que almacene la versión más reciente de los paquetes instalados en las máquinas, un servidor de integración continua (CI SERVER) que permita activar mediante eventos la instalación de las nuevas versiones de paquetes en el mirror y un cliente para testear la funcionalidad de los servicios anteriormente mencionados. Para la solución se emplea la herramienta para la creación y configuración de entornos virtualizados Vagrant, por lo que el proceso general de montaje y aprovisionamiento automático de máquinas se muestra implementado allí, así como se utilizan los cookbooks según. En la figura 1 se muestra la arquitectura de la solución.

![][0]
**Figura 1**. Arquitectura de la solución


## Solución

### Aprovisionamiento de las máquinas

Para comenzar con el montaje de la solución, se construyó un entorno virtualizado Vagrant para las 4 máquinas virtuales en cuestión. En este proceso se debían configurar aspectos fundamentales de cada máquina, como lo son el nombre de identificación, los ajustes de red y la ruta de los cookbooks con los que se aprovisionan. A continuación se enseña la configuración del archivo donde se almacena esto: el VagrantFile.

```ruby

##Vagrant configure
Vagrant.configure("2") do |config|
  ##All machines works with centos1706_v0.2.0
  config.vm.box = "centos1706"

  ##Deploy and provision dhcp server
  config.vm.define "dhcp_server" do |dhcp_server|
    dhcp_server.vm.network "public_network", bridge: "eno1", ip: "192.168.190.32", netmask: "255.255.255.0"
    dhcp_server.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	    chef.add_recipe "dhcp_server"
  	end
  end

  ##Deploy and provision yum mirror server
  config.vm.define "mirror_server" do |mirror_server|
    mirror_server.vm.network "public_network", bridge: "eno1", ip: "192.168.190.33", netmask: "255.255.255.0"
    mirror_server.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
      chef.add_recipe "httpd"
	    chef.add_recipe "mirror_server"
  	end
  end

  ##Deploy and provision continous integration server
  config.vm.define "ci_server" do |ci_server|
    ci_server.vm.network "public_network", bridge: "eno1", type: "dhcp"
    ci_server.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	    chef.add_recipe "ci_server"
  	end
  end

  ##Deploy and provision client
  config.vm.define "client" do |client|
    client.vm.network "public_network", bridge: "eno1", type: "dhcp"
    client.vm.provision :chef_solo do |chef|
    	chef.install = false
    	chef.cookbooks_path = "cookbooks"
	    chef.add_recipe "client"
  	end
  end

end


```
De lo anterior es importante remarcar que el MIRROR SERVER es el único diferente al DHCP SEVER que cuenta con una dirección IP estática; esto dado que el CI SERVER necesita saber constantemente a qué IP conectarse con el fin de instalar las actualizaciones de paquetes al momento de haber un PR con el archivo packages.json que contiene la lista de los mismos. A continuación, se procede a explicar a modo general el aprovisionamiento se automatizó.

**DHCP SERVER**
Para este servidor, se automatizó la instalación, configuración de el servicio dhcpd. Esto se consiguió mediante la instalación del servicio, la configuración del archivo donde se asigna el rango de IPs para otorgar y su posterior activación. Esto se consiguió mediante el uso de 3 recetas.

**MIRROR SERVER**
Para este caso se hicieron varios pasos. En primer lugar, se instaló y configuró el servicio httpd; con este se da paso a utilizar la utilidad de repolist. En segundo lugar, se instaló esta mencionada; con ella tenemos la posibilidad de manejar este servidor como un repositorio para los paquetes a instalar. En tercer lugar, se posicionó un archivo de packages.json, donde quedarían los paquetes instalados actualmente en el servidor mirror. Por último, se configuró el servicio ssh con el fin de que el CI SERVER pudiese conectarse a este e instalar los nuevos paquetes en el momento de un PULL REQUEST con paquetes nuevos.

**CI SERVER**
Este es el eje central del componente tan atractivo de integración continua. En este servidor la principal función es la de servir de endpoint, esto es, de ejecutar el método que permite que cada vez que se haga un PR al repositorio, los paquetes del Json de este se instalen en el MIRROR SERVER. Al este método estar desarrollado en Python, se requiere de la instalación de la versión 3.6 del mismo. Además de esto, se instalan las utilidades de connexion y Fabric las cuales nos permiten, respectivamente, correr y debugear el funcionamiento del endpoint y conectarnos a una máquina de manera remota. Además de esto, se instala la utilidad de Ngrok, la cual permite exponer nuestro servicio de endpoint en una IP pública para el WebHook. Para el entendimiento de este último, lo podemos definir como un aplicativo que ofrece Git que permite servir de trigger de eventos, esto es, escucha posibles eventos de un repositorio Git, tal como la realización de PRs, y envía la información de estos a un endpoint que se encuentre en una IP pública: aquí el papel del Ngrok.


**CLIENT**
Para este último usuario de prueba se configura en el archivo /etc/hosts el servidor mirror, así como ser realizan dos comandos con el fin de instalar los nuevos paquetes cada vez que inicia. Estos son los siguientes.


```
yum clean all
yum update -y
``` 

### Funcionamiento de la solución

En primer lugar, se corre el servicio Ngrok en el puerto 8080 de nuestro CI SERVER. Para ello se debe primero una clave de autenticación

![][1]

Una vez corrido este servicio, se ve la IP generada temporalmente donde se expondrá nuestro endpoint. Aquí se mostrarán los códigos HTTP para cada solicitud entregada al endpoint.

![][7]

Posterior, en el MIRROR SERVER debemos compartir nuestra clave de ssh al CI SERVER para permitir instalar los paquetes de manera remota 

![][5]

Con esta configuración hecha, configuramos nuestro WebHook en Github con el enlace público proporcionado por Ngrok para nuestro WebHook de la siguiente manera. Este debe recibir en forma de Json los PR.

![][2]

![][3]

Antes de realizar la prueba se valida que el directorio donde se encuentran los paquetes instalados del mirror está instalado antes de realizar el primer PR.

![][9]

Para comenzar a probar el endpoint lo corremos introduciendo las siguientes líneas. En ellas se setean las variables de ambiente a un entorno de desarrollo.

```bash
export PYTHONPATH=$PYTHONPATH:`pwd`
export FLASK_ENV=development
connexion run gm_analytics/swagger/indexer.yaml --debug -p 8080
```

El resultado se muestra a continuación

![][6]

Por último, se procede a realizar un PR de prueba, con tal de validar el funcionamiento de la solución de la siguiente manera.

![][4]

Como se puede observar en la siguiente imagen, la carpeta /var/repo ya tiene los paquetes que se aprovisionaron desde el packages.json de prueba que había en la raíz del directorio. Este tenía, entre otros, los paquetes nmap y tree.

![][8]

### Problemas encontrados en la implementación

Como todo buen proyecto, en este apartado se reunen los inconvenientes que se tuvieron que aforntar al momento de implementarlo. Uno de los primeros problemas al realizar la solución que se planteó fue aprovisionar correctamente con Chef. El orden en que se ejecutaban las recetas era un punto importante para el funcionamiento. Por otra parte, donde más se tuvo problemas fue en el manejo del formato Json del PULL REQUEST, ya que de este no se conocía mucho la estructura; su correcto conocimiento permitió poder manejarlo correctamente. Por último en el relato pero no en su aparición ni en importancia está el entendimiento del caso, esto es, entender la dinámica de un CI SERVER, así como el papel del Webhook y del endpoint en la solución del problema. Una vez afrontadas estas dificultades, el proyecto se pudo llevar a cabo con normalidad.



[0]: images/0.png
[1]: images/1.png
[2]: images/2.png
[3]: images/3.png
[4]: images/4.png
[5]: images/5.png
[6]: images/6.png
[7]: images/7.png
[8]: images/8.png
[9]: images/9.png








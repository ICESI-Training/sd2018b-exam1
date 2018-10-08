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
En el siguiente informe, se presenta la implementación de una infraestructura de aprovisamiento automático. Esta solución tiene como objetivo principal el montaje de un servidor mirror que sirva como repositorio de los paquetes que necesitan los dispositivos del contexto local sin necesidad de acudir a internet y pasar por el cuello de botella que representa la salida de la red. Dicha labor será conseguida mediante el montaje de un servidor DHCP (DHCP SERVER) que provea de direcciones IP no estáticas a los equipos locales, un servidor mirror (MIRROR SERVER) que almacene la versión más reciente de los paquetes instalados en las máquinas, un servidor de integración continua (CI SERVER) que permita activar mediante eventos la instalación de las nuevas versiones de paquetes en el mirror y un cliente para testear la funcionalidad de los servicios anteriormente mencionados. Para la solución se emplea la herramienta para la creación y configuración de entornos virtualizados Vagrant, por lo que el proceso general de montaje y aprovisionamiento automático de máquinas se muestra implementado allí. En la figura 1 se muestra la arquitectura de la solución.

![][1]
**Figura 1**. Arquitectura de la solución


## Solución

### Aprovisionamiento de las máquinas

Para comenzar con el montaje de la solución, se construyó un entorno virtualizado Vagrant para las 4 máquinas virtuales en cuestión. En este proceso se debían configurar aspectos fundamentales de cada máquina, como lo son el nombre de identificación, los ajustes de red y la ruta de los cookbooks con los que se aprovisionan. A continuación se enseña la configuración del archivo donde se almacena esto: el VagrantFile

```

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



[1]: images/01_arquitectura_solución.png








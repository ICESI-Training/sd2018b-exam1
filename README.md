### Examen 1
**Universidad ICESI**  
**Curso:** Sistemas Distribuidos  
**Nombre:** Tomas Julian Lemus Rubiano.  
**Tema:** Automatización de infraestructura  
**Correo:** tjlr50@gmail.com

**Código:** A00054616

**Git:** github.com/tjlr50


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

![][10]
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

## Solución 

### Desarrollo de la implementación

Para iniciar, se gestionó la estructura por carpetas que correspondiera a cada segmento de la solución y para enterdelo se usó el siguiente diagrama. Se usó un repositorio en Github para llevar un desarrollo adecuado, versionado y accesible de la solución, la cual inicia con un Vagrantfile que será el encargado de desplegar 4 maquinas virtuales usando chef como herramienta de administración de configuración.


![][10]
**Figura 1**. Diagrama de Despliegue

![][11]
**Figura 1**. Estructura Vagrantfile


### comando vagrant up y varannt status para corroborar el estado de las maquinas

 ![][2] 
 
dhcp_Server

mirror_server

ci_server

mirror_client

Para esto, se deben instalar cada servicio y asignar sus respectivas recipes dentro un archivo default.rb.

### Default.rb para el DHCP SERVER


```
include_recipe 'dhcp_server::dhcpd_install
include_recipe 'dhcp_server::dhcpd_conf
include_recipe 'dhcp_server::dhcpd_init
 ```
 
El correcto funcionamiento permite intercambiar keygens con el CI Server a través del ssh-keygen y ssh-copy-ip vagrant@192.168.132.12

 ![][3]
  
Posteriormente, para hacer accesibles los archivos (endpoint) desde la red, se configura ngrok en una carpeta del CI SERVER y se accde por el puerto asignado
  
 ![][4]
  
Ahora se deben correr las siguientes lineas de código del deploy para la integración y se muestra el repolist inicial.
export PYTHONPATH=$PYTHONPATH:`pwd`
export FLASK_ENV=development
connexion run gm_analytics/swagger/indexer.yaml --debug -p 8080

![][1]

Se configura el webhook de nuestro reopsitorio utilizando la url dinámica del ngrok y la ruta especifica dentro del sistema de archivos.

 ![][5]
 Se selecciona pull request como criterio para la ejecución del endpoint.
 ![][6]
  
 ![][7]
  
 ![][8]
  
 ![][9]
  
 ## Problemas encontrados
 
El problema principal fue establecer un orden de trabajo que permita un desarrollo conciso de las tareas, para esto se tomó el diagrama del despliegue como base y se incorporó al sistema de archivos del sistema, tomando como ejemplo las actividades realizadas en clase.
Personalmente, la busqueda de la información parece ser labor de gran importancia para este tipo de actividades como el aprovisionamiento de máquinas virtuales, ya que implica el abastecimiento de tecnologías que pueden ser nuevas y confusas como chef y el modelo de recetas; nuevamente, los ejemplos previos al exámen permiten generalizar el modelo. Finalmente, el entendimiento de las tecnologías sugeridas como la librerías de python y ngrok añaden complejidad al desarrollo, para esto se esudiaron las fuentes recomendadas. En terminos de trabajo sucedieron interrupciones como reservas de la sala inesperadas que al momento de seguir no recordaba lo que estaba fallando.  


### Referencias
* https://docs.chef.io/  
* https://github.com/ICESI/ds-vagrant/tree/master/centos7/05_chef_load_balancer_example
* https://developer.github.com/v3/guides/building-a-ci-server/
* http://www.fabfile.org/
* http://flask.pocoo.org/
* https://connexion.readthedocs.io/en/latest/

[1]: imagenes/1.png
[2]: imagenes/2.png
[3]: imagenes/3.png
[4]: imagenes/4.png
[5]: imagenes/5.png
[6]: imagenes/6.png
[7]: imagenes/7.png
[8]: imagenes/8.png
[9]: imagenes/9.png
[10]: imagenes/01.png
[11]: imagenes/vagrantfile.png


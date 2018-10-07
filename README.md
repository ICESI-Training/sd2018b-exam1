### Examen 1
**Universidad ICESI**  
**Curso:** Sistemas Distribuidos  
**Docente:** Carlos Andrés Afanador Cabal   
**Tema:** Automatización de infraestructura  
**Correo:** carlosafanador97 at gmail.com

### Objetivos
* Realizar de forma autónoma el aprovisionamiento automático de infraestructura
* Diagnosticar y ejecutar de forma autónoma las acciones necesarias para lograr infraestructuras estables

### Desarrollo

## Aprovisionamiento  
Se presentan los comandos y procesos automatizados mediande cookbooks, para cada máquina implementada.
### 1. DHCP Server:
- Instalación de servicio dhcp:
```
yum install dhcp -y
```
- Configuración del servicio dhcp:
  * Se sobreescribe el archivo de configuración por defecto de dhcp (*/etc/dhcp/dhcpd.conf*), por uno que contiene el rango de IPs a asignar por el servidor.  
 * Iniciar servicio dhcp:  
```
systemctl start dhcpd.service
```

### 2. Mirror Server:  
- Configuración de Mirror Server:
```
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
```
- Conexiones remotas:
  * Se sobreescribe el archivo de configuración por defecto de ssh (*/etc/ssh/sshd.conf*), por uno que permita hacer conexiones remotas.  
 * Reiniciar servicio ssh para actualizar la configuración:  
```
systemctl start sshd.service
```
### 3. CI Server:
- Instalación wget descargar recursos web:
```
sudo yum wget -y
```
- Instalación unzip para descomprimir:
```
sudo yum unzip -y
```
- Instalación ngrok para consumir servicios locales desde internet:
```
mkdir /home/vagrant/apps/ngrok
cd /home/vagrant/apps/ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
```
- Instalación de librerias de python3.6 para desarrollo:
```
sudo yum install -y yum-utils
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
sudo yum install -y python36u
sudo yum install -y python36u-pip
yum install -y python36u-devel.x86_64
pip install --upgrade pip
pip3.6 install connexion
pip3.6 install fabric
```
- Configuración de API para endpoint de integración:
 ```
swagger: '2.0'

info:
  title: User API
  version: "0.1.0"

paths:
  /ci_server/updates:
    post:
      x-swagger-router-controller: gm_analytics
      operationId: handlers.manage_pullrequest
      summary: Manages the uptadates made trhough a pullrequest.
      responses:
        200:
          description: Successful response.
          schema:
            type: object
            properties:
              command_return:
                type: string
description: User information
```
  * Método del endpoint que obtiene el contenido y hace la integración al Mirror Server usando python:
```
import os
import requests
import json
from fabric import Connection
from flask import request

def manage_pullrequest():
    update = request.get_data()
    updateUTF = str(update, 'utf-8')
    updateJSON = json.loads(updateUTF)
    pr = updateJSON["pull_request"]["head"]["sha"]
    url = 'https://raw.githubusercontent.com/yosoyafa/sd2018b-exam1/' + pr + '/packages.json'
    contents = requests.get(url)
    pck = json.loads(contents.content)
    for package in pck:
        cmd = package['installation_commands']
        cmdstr = ''.join(cmd)
        Connection('vagrant@192.168.131.103').run('sudo yum install --downloadonly --downloaddir=/var/repo'+ ' ' + cmdstr)
    out = {'command_return': '1'}
return out
```
### 4. Mirror Client:
- Se edita el archivo de hosts (*/etc/hosts*) para incluir el Mirror Server:
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.131.103 mirror.icesi.edu.co
```
- Se incluye el archivo de configuración de nuestro repo:
```
[examrepo]
name=My RPM System Package Repo
baseurl=http://mirror.icesi.edu.co/repo/
enabled=1
gpgcheck=0
```
## Despliegue

Con todas las máquinas debidamente aprovisionadas, mediante la herramienta Vagrant, se ejecuta un Vagrantfile (donde se indica cómo levantar nuestras máquinas):
```
vagrant up
```
Se accede al servidor de integración y se realiza un intercambio de claves entre éste servidor y el Mirror Server:
```
ssh-keygen
ssh-copy-ip vagrant@mirror-server-ip #(192.168.131.103)
```
![][1]
Aún en el CI Server, mediante la herramienta **ngrok**, se crea un tunel para desplegar nuestro endpoint en la internet, accediendo a la carpeta donde se tiene la herramienta y ejecutándola indicando el puerto deseado (8080):  
```
cd apps/ngrok
./ngrok http 8080
```
![][2]
Posteriormente, se levanta el endpoint de integración:
```
export PYTHONPATH=$PYTHONPATH:`pwd`
export FLASK_ENV=development
connexion run gm_analytics/swagger/indexer.yaml --debug -p 8080
```
![][3]

Antes de proceder a hacer la integración, se verifica que el Mirror Server no posee, aún, ningún ocntenido preestablecido:
```
ls /var/repolist
```
![][4]

Ahora se configura un webhook en github para recibir los *pull request* y hacer la integración al Mirror Server:
![][5]

Se hace un *pull request* y se evidencia que el endpoint hace las labores de integración del contenido que enviamos, en el Mirror Server y **ngrok** confirma la correcta ejecución del proceso:
![][6]
![][7]

Ahora, revisamos los paquetes que contiene el Mirror Server, y vemos que posee los que dictaminabael archivo packages.json del *pull request*:
```
ls /var/repolist
```
![][8]

Con el Mirror Server listo, desde el Mirror Client se verifica el estado del Mirror Server y se procede a obtener los paquetes que él aloja:


![][9]
  
![][10]

### Dificultades encontradas
La mayor dificultad durante el desarrollo de la actividad fue el manejo de las actualizaciones en el Mirror Client, ya que, al revisar el *repo*, éste seguía vacío, cuando ya se habían hecho las actualizaciones en el Mirror Server. Ésto se solucionó mediante el siguiente comandos en el Mirror Server:
```
createrepo --update /var/repo
```
Y en el Mirror Client:
```
yum clean all
yum upgrade
yum update
```


[1]: images/keys.png
[2]: images/ngrok.png
[3]: images/endpoint.png
[4]: images/mirror-vacio.png
[5]: images/webhook.png
[6]: images/endpoint200.png
[7]: images/ngrok200.png
[8]: images/mirror-lleno.png
[9]: images/yum-list-all.png
[10]: images/paquetesenclient.png






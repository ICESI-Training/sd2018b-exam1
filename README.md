# Examen 1
**Universidad Icesi**  
**Nombre del estudiante:** Luis Alejandro Tróchez  
**ID del estudiante:** A00054648
**Repositorio:** https://github.com/zehcort/sd2018b-exam1
**Email:** zehcort@hotmail.es  
**Materia:** Sistemas Distribuidos    
**Profesor:** Daniel Barragán C.  
**Tema:** Automatización de Infraestructura 


### Descripción
En el siguiente informe, se presenta la implementación de una infraestructura de aprovisamiento automático. Esta solución tiene como objetivo principal el montaje de un servidor mirror que sirva como repositorio de los paquetes que necesitan los dispositivos del contexto local sin necesidad de acudir a internet y pasar por el cuello de botella que representa la salida de la red. Dicha labor será conseguida mediante el montaje de un servidor DHCP (DHCP SERVER) que provea de direcciones IP no estáticas a los equipos locales, un servidor mirror (MIRROR SERVER) que almacene la versión más reciente de los paquetes instalados en las máquinas, un servidor de integración continua (CI SERVER) que permita activar mediante eventos la instalación de las nuevas versiones de paquetes en el mirror y un cliente para testear la funcionalidad de los servicios anteriormente mencionados. Para la solución se emplea la herramienta para la creación y configuración de entornos virtualizados Vagrant, por lo que el proceso general de montaje y aprovisionamiento automático de máquinas se muestra implementado allí. En la figura 1 se muestra la arquitectura de la solución

![][1]
**Figura 1**. Arquitectura de la solución


### Solución

## Aprovisionamiento



[1]: images/01_arquitectura_solución.png








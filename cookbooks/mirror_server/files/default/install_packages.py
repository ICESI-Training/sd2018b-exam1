import json
import os

cargar_pack = json.loads(open('/home/vagrant/packages.json').read())

for j in cargar_pack:
	caracteres=j["commands"].split(";")
	for 1 in caracteres:
		os.system("sudo yum install --downloadonly --downloaddir=/var/repo " + caracteres)

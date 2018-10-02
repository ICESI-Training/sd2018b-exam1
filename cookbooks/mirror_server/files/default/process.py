import json
import os

print "Leer archivos"
leer = json.loads(open('/home/vagrant/packages.json').read())

for i in leer:
        x = i["commands"].split(";")
	for l in x:
		os.system("yum install --downloadonly --downloaddir=/var/repo " + l)


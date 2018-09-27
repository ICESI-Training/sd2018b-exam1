import json
import os

print "Leer archivos"
leer = json.loads(open('/home/vagrant/packages.json').read())

for i in leer:
        x = i["commands"].split(";")
	for l in x:
		print ("yum install -y " + l)
		os.system("yum install -y " + l)


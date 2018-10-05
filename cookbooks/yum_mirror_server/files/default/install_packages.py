import json
import os

packages_clean = json.loads(open('packages.json').read())
packages_list = packages_clean['packages']
cadena = ''
for package in packages_list:
  cadena = cadena + ' ' + package
os.system("sudo yum install --downloadonly --downloaddir=/var/repo " + cadena)

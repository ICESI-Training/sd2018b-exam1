import urllib, json
import os
url = "https://raw.githubusercontent.com/nikoremi97/sd2018b-exam1/nrecalde/sd2018b-exam1/packages.json"
response = urllib.urlopen(url)
data = json.loads(response.read())
x=""
for i in data:
       x =x + " " + i["package"]
print x
os.system("yum install --downloadonly --downloaddir=/var/repo -y" +x)

import urllib, json
url = "https://raw.githubusercontent.com/nikoremi97/sd2018b-exam1/nrecalde/sd2018b-exam1/A00065888/cookbooks/mirror/files/default/packages.json "
response = urllib.urlopen(url)
data = json.loads(response.read())

print data

import json
import requests
from fabric import Connection
from flask import request

def get_packages_prs()
    logging.debug('PR received')
    StringJsonPR = str(request.get_data(), 'utf-8')
    JsonPR = json.loads(StringJsonPR)
    idPR =  JsonPR["pull_request"]["head"]["sha"]
    url = "https://raw.githubusercontent.com/zehcort/sd2018b-exam1/"+sha+"/packages.json"
    packages_data = json.loads((requests.get(url)).content)
    line = ""
    for i in packages_data[packages]
        packages = i[package_commands]
        for j in packages:
            line = line + " " + j
            connect = Connection('vagrant@192.168.190.33').run('sudo yum install --downloadonly --downloaddir=/var/repo' + line)

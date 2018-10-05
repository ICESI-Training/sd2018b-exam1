import os
from fabric import Connection
from flask import request
import logging
import json
import requests
def notify_repository_change():
    logging.debug('Event Received')
    request_data = request.get_data()
    data = str(request_data, 'utf-8')
    jsonData = json.loads(data)
    id_pull_request = jsonData["pull_request"]["head"]["sha"]
    url = 'https://raw.githubusercontent.com/nikoremi97/sd2018b-exam1/' + id_pull_request + '/packages.json'
    response = requests.get(url)
    packages_json = json.loads(response.content)
    packages=""
    for i in packages_json:
           packages =packages + " " + i["package"]
    mirror_connection = Connection(host='root@192.168.131.152',connect_kwargs={"password":"vagrant"})
    output = mirror_connection.run('sudo yum install --downloadonly --downloaddir=/var/repo' + packages)
    mirror_connection.run('createrepo --update /var/repo')
    logging.debug(output)
    result = {'command_return': 'success'}
    return result

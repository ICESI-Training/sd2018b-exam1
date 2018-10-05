import os
from fabric import connection
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
    url = 'https://raw.githubusercontent.com/nikoremi97/sd2018b-exam1/nrecalde/sd2018b-exam1/A00065888/' + id_pull_request + '/packages.json'
    response = requests.get(url)
    packages_json = json.loads(response.content)
    packages=""
    for i in data:
           packages =packages + " " + i["package"]
    new_packages_to_install = Connection('vagrant@192.168.131.152').run('sudo yum install --downloadonly --downloaddir=/var/repo' + packages)
    logging.debug(new_packages_to_install)
    result = {'command_return': 'success'}
    return result

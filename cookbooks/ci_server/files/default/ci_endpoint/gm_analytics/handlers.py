import os
import requests
import json
from fabric import Connection
from flask import request

def manage_pullrequest():
    update = request.get_data()
    updateUTF = str(update, 'utf-8')
    updateJSON = json.loads(updateUTF)
    pr = updateJSON["pull_request"]["head"]["sha"]
    url = 'https://raw.githubusercontent.com/yosoyafa/sd2018b-exam1/' + pr + '/packages.json'
    contents = requests.get(url)
    pck = json.loads(contents.content)
    for package in pck:
        cmd = package['installation_commands']
        cmdstr = ''.join(cmd)
        Connection('vagrant@192.168.131.103').run('sudo yum install --downloadonly --downloaddir=/var/repo'+ ' ' + cmdstr)
    out = {'command_return': '1'}
    return out

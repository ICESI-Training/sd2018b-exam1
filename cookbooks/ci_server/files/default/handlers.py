import logging
import os
import json
from flask import request
import requests
from fabric import Connection
from github import Github

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def set_pullrequest_info():
    logging.info('executing set_pullrequest_info method')
    data_clean = request.get_data() # get data parameter as json
    data_str = str(data_clean, 'utf-8') # parse json in string format
    data_json = json.loads(data_str) # parse data string to json
    pull_sha = data_json['pull_request']['head']['sha'] # get pull request id from json
    url_pull = 'https://raw.githubusercontent.com/JonatanOrdonez/sd2018b-exam1/' + pull_sha + '/packages.json' # generate url
    response_pull = requests.get(url_pull) # get from url for obtain packages.json
    packages_clean = json.loads(response_pull.content) # load packages.json in json var
    packages_list = packages_clean['packages'] # list of packages
    c = Connection(host='vagrant@192.168.140.3', port=22, connect_kwargs={"password": 'vagrant'}) # initial config for SSH connection with fabric
    cadena = ''
    for package in packages_list:
      cadena = cadena + ' ' + package
    result = c.run('sudo yum install --downloadonly --downloaddir=/var/repo' + cadena) # execute command for install packages in yum_mirror_server
    g = Github("9a4263d973477963e9a4c3b0cf65b2f6e86572f5") # get a reference of my own github using an api token
    repo = g.get_repo("JonatanOrdonez/sd2018b-exam1") # get the JonatanOrdonez/sd2018b-exam1 repository
    pull_number = data_json['pull_request']['number'] # get the pull request number
    pr = repo.get_pull(pull_number) # get the pull request
    if pr.merged: # validation if the pull request was merged
        return {'status': 'Pull request is already merged'}
    elif result.return_code == 0: # validation if the packages were installed correctly
        pr.merge() # merge the pull request
        return {'status': 'Pull request success'}
    elif result.return_code != 0: # validation if the packages were not installed correctly
        return {'status': 'Pull request rejected'}
    else:
        return {'status': 'Error trying to process the request'}

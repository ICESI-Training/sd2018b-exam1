import logging
import os
import json
from flask import request
import requests

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def set_pullrequest_info():
    logging.info('executing set_pullrequest_info method')
    data_clean = request.get_data() # get data parameter as json
    data_str = str(data_clean, 'utf-8') # parse json in string format
    data_json = json.loads(data_str) # parse data string to json
    pull_id = data_json['pull_request']['head']['sha'] # get pull request id from json
    url_pull = 'https://raw.githubusercontent.com/JonatanOrdonez/sd2018b-exam1/' + pull_id + '/packages.json' # generate url
    response_pull = requests.get(url) # get from url for obtain packages.json
    packages_json = json.loads(response_pull.content) # load packages.json in json var
    packages = response_pull['packages'] # get list of packages
    logging.info(packages)
    return {'info': 'success'}

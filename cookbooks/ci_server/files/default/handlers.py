import logging
import os
import json
from flask import request

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def set_pullrequest_info(request=None):
        logging.info('executing get_user_info method')
    data_pure = request.get_data()
    data_str = str(data_pure, 'utf-8')
    data_json = json.loads(data_str)
    logging.info(data_json['hook']['id'])
    return {'data': 'data'}

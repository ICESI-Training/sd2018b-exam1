import logging
import os

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def set_pullrequest_info(request=None):
    logging.info('executing get_user_info method')
    info = request['hook']['id']
    logging.info(info)
    return {'data': 'data'}

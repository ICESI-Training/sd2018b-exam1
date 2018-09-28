import logging
import os

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def set_pullrequest_info(request=None):
    logging.info('executing get_user_info method')
    logging.debug('request=%s', request)
    return {'data': 'data'}

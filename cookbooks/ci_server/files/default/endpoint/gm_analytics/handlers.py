import logging
import os

#level = int(os.getenv('LOG_LEVEL'))
#logging.basicConfig(level=level)

def get_user_info(username=None):
#    logging.info('executing get_user_info method')
#    logging.debug('username=%s', username)
    return {'data': username}

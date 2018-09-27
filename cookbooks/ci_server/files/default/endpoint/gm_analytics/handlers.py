import os
import logging
import json
import pdb
from fabric import Connection


def repository_changed():
    logging.debug('Event Received')
    text = Connection('192.168.131.15').run('sudo yum install -y tree')
    logging.debug(text)
    result = {'command_return': 'Funciona'}
    return result


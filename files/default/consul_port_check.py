#!/usr/bin/python
#
# Requirements
# Packages:
# * python-dev
# * build-essential
# pip:
# * argparse
# * psutil

import psutil
import argparse

parser = argparse.ArgumentParser(description='Check for open port.')
parser.add_argument('port', type=int, help='port to check')
args = parser.parse_args()

def check_listening_port(port):
    """Return proper error code if the given TCP port is busy and in LISTEN mode."""
    for conn in psutil.net_connections(kind='tcp'):
        if conn.laddr[1] == port and conn.status == psutil.CONN_LISTEN:
            return 0
    return 2

print(check_listening_port(args.port))

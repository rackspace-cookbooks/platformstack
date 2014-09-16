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

parser = argparse.ArgumentParser(description='Check for running process.')
parser.add_argument('name', type=str, help='name of process')
args = parser.parse_args()

def check_process_name(name):
    """Returns exit code if the given process name is running."""
    for proc in psutil.process_iter():
        try:
            pinfo = proc.as_dict(attrs=['name'])
        except psutil.NoSuchProcess:
            pass
        else:
            if pinfo['name'] == name:
                return 0
    return 2

print(check_process_name(args.name))

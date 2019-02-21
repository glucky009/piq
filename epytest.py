#!/usr/bin/python

import os
import platform
import sys
import datetime
import subprocess
import dmidecode
import fnmatch

#Function
# This function only applies to Windows and Linux
def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read().strip('\n')
        
def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result

var01 = find('rpstrata_*.sql','/')

print var01
#!/usr/bin/python

import os
import platform
import sys
import datetime
import subprocess
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
                result.append(name)
    return result

def file_size(fname):
    statinfo = os.stat(fname)
    return statinfo.st_size

var01 = find("rpstrata_[0-2][0-9][0-9][0-9]*.sql",'/')
var01.sort(reverse = True)
var02 = (var01[0])
var03=linuxCommand(["find" ,"/" , "-name", var02])
print(round(float(file_size(var03))/1000000000, 2))
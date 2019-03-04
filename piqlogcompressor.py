#!/usr/bin/python

############################################################################
## Author :PIQ Support
## Date : 11/02/2019 	
## Version : 1.00
## Description : Compresses the logs files and removes them
## 
## Add this line in "crontab -e -u root" to run every month "7 1 1 * * /bin/bash /opt/rpstrata/piqlogcompressor.sh"
##
## Note: This scipt will be ran every month to compress the log files
##
###########################################################################

import os
import platform
import sys
import datetime
import subprocess
import fnmatch
import logging
import tarfile
import exceptions

#Functions


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
    
#Variables

datecommand = datetime.datetime.now()
dateMonth = datecommand.strftime("%Y-%m")
dateMonthTime = datecommand.strftime("%x-%X")
tarLogLocation = "/var/log/rpstrata/tarLog.csv"
tarErrorLocation = "/var/log/rpstrata/tarErrorLog.csv"

#Output

try:
    Compress = tarfile.open("/var/log/rpstrata/piqlogs"+(dateMonth)+".tar.gz", "w:gz")
    piqlogFiles=find('piqlogs[0-2]*.csv', '/var/log/rpstrata/')
    for logs in piqlogFiles:
            Compress.add(logs)
            if os.path.isfile('/var/log/rpstrata/tarLog.csv'):
                logwrite=open(tarLogLocation, 'a')
                logwrite.writelines([dateMonthTime+","+logs + '\n'])
            else:
                logwrite=open(tarLogLocation, 'w')
                logwrite.writelines([dateMonthTime+","+logs + '\n'])
            print("Compressing", logs)
            os.remove(logs)
    Compress.close()
    pass
except Exception as e:
    print(e,"Error recorded in",tarErrorLocation)
    if os.path.isfile('/var/log/rpstrata/tarErrorLog.csv'):
        logging.basicConfig(filename=("/var/log/rpstrata/tarErrorLog.csv"), filemode='a', format='%(asctime)s,%(name)s,%(levelname)s,%(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
        logging.warning(e)
    else:
        logging.basicConfig(filename=("/var/log/rpstrata/tarErrorLog.csv"), filemode='w', format='%(asctime)s,%(name)s,%(levelname)s,%(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
        logging.warning(e)
finally:
    pass
#!/usr/bin/python

############################################################################
## Author :PIQ Support
## Date : 17/02/2019 	
## Version : 1.00
## Language: Python 2.6
## Log Location: /var/log/rpstrata
## Description : Create logs of the PIQ Server
## that will help the PIQ Support to audit server use through time.
## 
## Table Format: Date,Time,PIQ Version,CPU Model,CPU(s),CPU (GHz), CPU Idle Time (%), RAM Used (GB), RAM Total (GB), Boot Disk Used (GB), Boot Disk Total (GB),Disk Used (GB), Disk Total (GB),DB Disk Used (GB),DB Disk Total (GB),BUP Size (GB)
##
## Note: This scipt will be ran every hour
##       Ideally the File size should be below 5KB
###########################################################################

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
                result.append(name)
    return result

def file_size(fname):
    statinfo = os.stat(fname)
    return statinfo.st_size

# Variables
piqVersionList = linuxCommand(["ls", "-l", "/opt/rpstrata/root"])
piqVersion = piqVersionList[80:87]
piqVersionDate =  piqVersionList[103:115]

dateNow = (datetime.datetime.now()).strftime("%Y-%m-%d")
timeNow = (datetime.datetime.now()).strftime("%H:%M:%S")

piqLogfile = "/var/log/rpstrata/piqlogs"+dateNow+".csv"

cpuInfo = linuxCommand(["lscpu"])
cpuTop = linuxCommand(["top","-n1"])
cpuModel = linuxCommand(["cat","/proc/cpuinfo"])
cpuModel2 = cpuModel[78:119]
cpuNumber = cpuInfo[118:119]
cpuMHz = cpuInfo[354:363]
cpuGHz = round(float(cpuMHz)/1000, 2)
cpuIdle = cpuTop[509:513]

memInfo = linuxCommand(["free"])
memUsedMHz = memInfo[97:103]
memUsedGHz = round(float(memUsedMHz)/1000000, 2)
memTotalMHz = memInfo[85:92]
memTotalGHz = round(float(memTotalMHz)/1000000, 2)

diskInfo = linuxCommand(["df"])
bootDiskUsed = diskInfo[257:270]
bootDiskUsedGB = round(float(bootDiskUsed)/1000000, 2)
bootDiskTotal = diskInfo[248:257]
bootDiskTotalGB = round(float(bootDiskTotal)/1000000, 2)
diskUsed = diskInfo[116:125]
diskUsedGB = round(float(diskUsed)/1000000, 2)
diskTotal = diskInfo[106:115]
diskTotalGB = round(float(diskTotal)/1000000, 2)
dbDiskUsed = diskInfo[329:339]
dbDiskUsedGB = round(float(dbDiskUsed)/1000000, 2)
dbDiskTotal = diskInfo[319:328]
dbDiskTotalGB = round(float(dbDiskTotal)/1000000, 2)

backupFind = find("rpstrata_[0-2][0-9][0-9][0-9]*.sql",'/')
backupLatest = (backupFind[0])
backupSize = linuxCommand(["find" ,"/" , "-name", backupLatest])
backupTotalGB = round(float(file_size(backupSize))/1000000000, 2)

## Output

if os.path.exists(piqLogfile):
    print("Adding new log to "+piqLogfile )
    myfile = open(piqLogfile, 'a+')
    myfile.write("""%s,%s,%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s
""" % (dateNow,timeNow,piqVersion,piqVersionDate,cpuModel2,cpuNumber,cpuGHz,cpuIdle,memUsedGHz,memTotalGHz,bootDiskUsedGB,bootDiskTotalGB,diskUsedGB,diskTotalGB,dbDiskUsedGB,dbDiskTotalGB,backupTotalGB))
    myfile.close
else:
    print("Creating log file "+piqLogfile)
    myfile = open(piqLogfile, 'w+')
    myfile.write("Date,Time,PIQ Version,CPU Model,CPU(s),CPU (GHz), CPU Idle Time (%), RAM Used (GB), RAM Total (GB), Boot Disk Used (GB), Boot Disk Total (GB),Disk Used (GB), Disk Total (GB),DB Disk Used (GB),DB Disk Total (GB),BUP Size (GB)")
    myfile = open(piqLogfile, 'a+')
    myfile.write("""
%s,%s,%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s
""" % (dateNow,timeNow,piqVersion,piqVersionDate,cpuModel2,cpuNumber,cpuGHz,cpuIdle,memUsedGHz,memTotalGHz,bootDiskUsedGB,bootDiskTotalGB,diskUsedGB,diskTotalGB,dbDiskUsedGB,dbDiskTotalGB,backupTotalGB))
    myfile.close
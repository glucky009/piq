#!/usr/bin/python

import os
import platform
import sys
import datetime
import subprocess
import dmidecode

#Function
# This function only applies to Windows and Linux
def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read().strip('\n')

# Variables
piqVersionList = linuxCommand(["ls", "-l", "/opt/rpstrata/root"])
piqVersion = piqVersionList[80:87]
piqVersionDate =  piqVersionList[103:115]

dateNow = (datetime.datetime.now()).strftime("%m-%d-%Y")
timeNow = (datetime.datetime.now()).strftime("%H:%M:%S")

cpuInfo = linuxCommand(["lscpu"])
cpuTop = linuxCommand(["top","-n1"])
cpuModel = linuxCommand(["cat","/proc/cpuinfo"])
cpuModel2 = cpuModel[78:119]
cpuNumber = cpuInfo[118:119]
cpuMHz = cpuInfo[354:363]
cpuGHz = round(float(cpuMHz)/1000, 2)
cpuIdle = cpuTop[509:514]

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

# Display Output
# ps axo pid,user,%cpu,%mem,cmd --sort -rss
print ("Dates, Time, PIQ Version, CPU Model, CPU(s), CPU(GHz), CPU Idle Time (%), RAM Used (GB), RAM Total (GB), Boot Disk Used (GB), Boot Disk Total (GB), Disk Used (GB), Disk Total (GB), DB Disk Used (GB), DB Disk Total (GB), BUP Size (GB)")
print dateNow,",",timeNow,",",piqVersion,piqVersionDate,",",cpuModel2,",",cpuNumber,",",cpuGHz,",",cpuIdle,",",memUsedGHz,",",memTotalGHz,",",bootDiskUsedGB,",",bootDiskTotalGB,",",diskUsedGB,",",diskTotalGB,",",dbDiskUsedGB,",",dbDiskTotalGB,",",
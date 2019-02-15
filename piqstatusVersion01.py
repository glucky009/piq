#!/usr/bin/python
############################################################################
## Author :PIQ Support
## Date : 02/08/2019
## Version : 1.0
## Language : Python 2.6
## Description : Display all the possible information of the PIQ Server
## that will help the PIQ Support to identify the issue.
##
## Display Output
##      System Information
##      Top 5 Memory-Consuming Processes
##      CPU Performance Data
##      File System Disk Space Usage
##      Free and Used Memory in the System
##      Service Statuses
##      Network Status and Configuration
###########################################################################

# Modules
import os
import platform
import sys
import datetime
import subprocess

#Function
# This function only applies to Windows and Linux
def clearScreen():
    os.system("cls" if os.name == "nt" else "clear")
def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read().strip('\n')

# Variables
piqVersionList = linuxCommand(["ls", "-l", "/opt/rpstrata/root"])
piqVersion = piqVersionList[80:87]
piqVersionDate =  piqVersionList[103:115]

dateNow = (datetime.datetime.now()).strftime(" %B %d, %Y %A %I:%M:%S %p")
serverUptime = linuxCommand("uptime")
vmOS = (' '.join(platform.linux_distribution()))
vmHN = linuxCommand("hostname")
vmUptimeAndUser = linuxCommand("w")

vmSystemList = linuxCommand(["dmidecode", "-t", "system"])
vmManufactureProductName=vmSystemList.splitlines()
vmManufacture = vmManufactureProductName[5].strip('\t')
vmProductName = vmManufactureProductName[6].strip('\t')  

vmBiosList = linuxCommand(["dmidecode", "-t", "bios"])
vmVendorSelect=vmBiosList.splitlines()
vmVendor=vmVendorSelect[5].strip('\t')

vmMemoryConsuming = linuxCommand(["top", "a"])

# Display Output
# ps axo pid,user,%cpu,%mem,cmd --sort -rss
output = """
-------------------------------------------------
System Information
-------------------------------------------------
Date : %s
OS : %s
HostName : %s
Server Uptime and Currently Logged-in Users:
%s
%s
%s
%s
PIQ Version : %s %s

--------------------------------------------------
Top 5 Memory-Consuming Processes
--------------------------------------------------
PID USER      PR  NI  VIRT  RES  SHR S CPU MEM    TIME  COMMAND
%s
""" % (dateNow,vmOS,vmHN,vmUptimeAndUser,vmVendor,vmManufacture,vmProductName, piqVersion, piqVersionDate, vmMemoryConsuming)

clearScreen()
print(output)

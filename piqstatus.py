#!/usr/bin/python
############################################################################
## Author :PIQ Support
## Date : 10/08/2018 	
## Version : 1.0
## Language : Python 2.6
## Description : Display all the possible information of the PIQ Server
## that will help the PIQ Support to identify the issue.
##
## Display Output
##	System Information
##	Top 5 Memory-Consuming Processes
##	CPU Performance Data	
##	File System Disk Space Usage
##	Free and Used Memory in the System
##	Service Statuses
##	Network Status and Configuration
###########################################################################

# Modules
import os
import datetime
import subprocess

#Function
# This function only applies to Windows and Linux
def clearScreen():
    os.system("cls" if os.name == "nt" else "clear")
def check_output (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    proc.wait()
    return proc.stdout.read()
    
# Variables
dateNow = (datetime.datetime.now()).strftime(" %B %d, %Y %A %I:%M:%S %p")
#serverUptime = subprocess.check_output(["uptime"])

# Display Output

output = """
-------------------------------------------------
System Information
-------------------------------------------------
Date : %s
Uptime :
OS :
HostName
Currently Logged-in Users : 
Vendor : 
Manufacturer : 
ProductName : 
PIQ Version : 
""" % (dateNow)

clearScreen()
print(output)
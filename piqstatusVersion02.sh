#!/bin/sh
############################################################################
## Author : PIQ Support
## Date : 01/28/2019 	
## Version : 2.0
## Language : Bash
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

#Variable
piqVersion=$(ls -l /opt/rpstrata/ | awk -F "." '/root ->/{print $3"."$4"."$5" " $7}')
dateTimeNow=$(date "+%B %d, %Y %A %r ")
vmOS=$(cat /etc/issue.net | head -n 1)
vmHN=$(hostname)
vmUptimeAndUser=$(w)
vmVendor=$(dmidecode | egrep -i 'vendor' | head -n 1)
vmManufacturer=$(dmidecode | egrep -i 'manufacturer' | head -n 1)
vmProduct=$(dmidecode | egrep -i 'product' | head -n 1)
bgServer=$(ps aux | grep BG | wc -l)
bgServerPID=$( ps aux | awk '/BG/ {print $2}' | head -n 1 )
cpuPerformance=$(top | head -n 3 | awk 'NR==3')
netBootProtocol=$(awk -F "=" '/BOOTPROT/ {print $2}' /etc/sysconfig/network-scripts/ifcfg-eth0)
netInterfaces=$(ip a s | awk -F ":" 'NR==1 || NR==6  {print $2}' ORS=' ')


#BG Server Status Condition
if [[ $bgServer -eq 2 ]]
then
	bgserverStatus="bgServer (pid $bgServerPID) is running..."
else
	bgserverStatus="bgServer is stopped"
fi

#Display Output
clear
echo -e "
-------------------------------------------------
System Information
-------------------------------------------------
Date : $dateTimeNow
OS : $vmOS
HostName : $vmHN
Server Uptime and Currently Logged-in Users: 
$vmUptimeAndUser
${vmVendor//[[:blank:]]/}
${vmManufacturer//[[:blank:]]/}
${vmProduct//[[:blank:]]/}
PIQ Version : $piqVersion

--------------------------------------------------
Top 5 Memory-Consuming Processes
--------------------------------------------------
$(top -a | head -n 12 | awk 'BEGIN{print "  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND"} NR>=8 && NR<=12')

--------------------------------------------------
CPU Performance Data
--------------------------------------------------
$cpuPerformance

--------------------------------------------------
File System Disk Space Usage
--------------------------------------------------
$(df -h)

--------------------------------------------------
Free and Used Memory in the System'
--------------------------------------------------
$(free)
 
--------------------------------------------------
echo Service Statuses
--------------------------------------------------
$(service smb status)
$(service nmb status)
$(service ntpd status)
$(service httpd status)
$(service mysqld status)
$(service stunnel status)
$bgserverStatus
--------------------------------------------------
Network Status and Configuration
--------------------------------------------------
Network Interface and IP Address
$(ip -o -4 add show | awk '$1=$1 {print "",$2,$4}')
Gateway
$(ip route | awk '/default/ {print "",$3}')
DNS Server
$(awk '/nameserver/ {print "",$2}' /etc/resolv.conf)
"
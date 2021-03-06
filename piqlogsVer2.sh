#!/bin/sh
############################################################################
## Author :PIQ Support
## Date : 11/02/2019 	
## Version : 1.00
## Language: Bash
## Description : Create logs of the PIQ Server
## that will help the PIQ Support to audit server use through time.
## 
## Table Format: Date,Time,PIQ Version,CPU Model,CPU(s),CPU (GHz), CPU Idle Time (%), RAM Used (GB), RAM Total (GB), Boot Disk Used (GB), Boot Disk Total (GB),Disk Used (GB), Disk Total (GB),DB Disk Used (GB),DB Disk Total (GB),BUP Size (GB)
## Add this line in "crontab -e" of root to run every hour "5 * * * * /bin/bash /opt/rpstrata/script/piqlogsVer1.sh"
##
## Note: This scipt will be ran every hour
##       Ideally the File size should be below 5KB
###########################################################################

#Variable
piqVersion=$(ls -l /opt/rpstrata/ | grep "root ->"| awk -F "." '{print $3"."$4"."$5" " $7}')
dateNow=$(date "+%Y-%m-%d")
time=$(date "+%T")
cpuNumber=$(lscpu | awk  '/CPU\(s\):/{print $2}')
cpuModel=$(awk '/model name/ {print $4 " " $5 " " $6 " " $7 }' /proc/cpuinfo)
cpuGHz=$(printf "%0.2f\n" $(lscpu | awk  '/MHz/{print ($3/1000)}'))
cpuIdle=$(top -b -n1 | awk /Cpu/'{print $5}' | awk -F"%" '{print $1}')
memUsed=$(printf "%0.2f\n" $(free | awk '/Mem/{print ($3/1000000)}'))
memTotal=$(printf "%0.2f\n" $(awk '/MemTotal/{print ($2/1000000)}' /proc/meminfo))
diskSize=$(printf "%0.2f\n" $(df | awk '/root/{print ($2/1000000)}'))
diskUsed=$(printf "%0.2f\n" $(df | awk '/root/{print ($3/1000000)}'))
bootdiskSize=$(printf "%0.2f\n" $(df | awk '/sda1/{print ($3/1000000)}'))
bootdiskUsed=$(printf "%0.2f\n" $(df | awk '/sda1/{print ($2/1000000)}'))
dbdiskSize=$(printf "%0.2f\n" $(df | awk '/sdb1/{print ($3/1000000)}'))
dbdiskUsed=$(printf "%0.2f\n" $(df | awk '/sdb1/{print ($2/1000000)}'))
backupSize=$(printf "%0.2f\n" $(find / -name "rpstrata_[0-2][0-9][0-9][0-9]*.sql" -printf "%T@ %Tc %s %p\n" | sort -nr |awk 'NR==1 {print $9/1000000000}'))
clientName=$(awk '/ServerName/{print $2}' /etc/httpd/conf.d/rpstrata.conf)
logFileLocation="/var/log/rpstrata/piqlogs$dateNow.csv"


# Log Output
# Table Format
{

    if [ -f $logFileLocation ]; then
        echo "Adding new log in the existing piqlogs.csv..."
    echo "$clientName, $dateNow, $time, Date, $dateNow
$clientName, $dateNow, $time, Time, $time
$clientName, $dateNow, $time, PIQ Version, $piqVersion
$clientName, $dateNow, $time, CPU Model, $cpuModel
$clientName, $dateNow, $time, CPU(s), $cpuNumber
$clientName, $dateNow, $time, CPU (GHz), $cpuIdle
$clientName, $dateNow, $time, CPU Idle Time (%), $cpuGHz
$clientName, $dateNow, $time, RAM Total (GB), $memTotal
$clientName, $dateNow, $time, RAM Used (GB), $memUsed
$clientName, $dateNow, $time, Boot Disk Size (GB), $bootdiskSize
$clientName, $dateNow, $time, Boot Disk Used (GB), $bootdiskUsed
$clientName, $dateNow, $time, Disk Size (GB), $diskSize
$clientName, $dateNow, $time, Disk Used (GB), $diskUsed
$clientName, $dateNow, $time, DB Disk Size (GB), $dbdiskSize
$clientName, $dateNow, $time, DB Disk Used (GB), $dbdiskUsed
$clientName, $dateNow, $time, BUP Size (GB), $backupSize" >> $logFileLocation
    echo "New log added to $logFileLocation"
    else 
       echo "Starting logfile" && echo -e "CLIENT NAME, DATE, TIME, KEY, VALUE
$clientName, $dateNow, $time, Date, $dateNow
$clientName, $dateNow, $time, Time, $time
$clientName, $dateNow, $time, PIQ Version, $piqVersion
$clientName, $dateNow, $time, CPU Model, $cpuModel
$clientName, $dateNow, $time, CPU(s), $cpuNumber
$clientName, $dateNow, $time, CPU (GHz), $cpuIdle
$clientName, $dateNow, $time, CPU Idle Time (%), $cpuGHz
$clientName, $dateNow, $time, RAM Total (GB), $memTotal
$clientName, $dateNow, $time, RAM Used (GB), $memUsed
$clientName, $dateNow, $time, Boot Disk Size (GB), $bootdiskSize
$clientName, $dateNow, $time, Boot Disk Used (GB), $bootdiskUsed
$clientName, $dateNow, $time, Disk Size (GB), $diskSize
$clientName, $dateNow, $time, Disk Used (GB), $diskUsed
$clientName, $dateNow, $time, DB Disk Size (GB), $dbdiskSize
$clientName, $dateNow, $time, DB Disk Used (GB), $dbdiskUsed
$clientName, $dateNow, $time, BUP Size (GB), $backupSize" > $logFileLocation
    echo "$logFileLocation has been created"
    fi
} || {
    echo "Error creating logs"
}
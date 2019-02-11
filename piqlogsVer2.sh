#!/bin/sh
############################################################################
## Author :PIQ Support
## Date : 10/08/2018 	
## Version : 1.01
## Description : Create logs of the PIQ Server
## that will help the PIQ Support to audit server use through time.
## 
## Table Format: Date,Time,PIQ Version,CPU Model,CPU(s),CPU (GHz), CPU Idle Time, RAM Used (GB), RAM Total (GB), Boot Disk Size (GB), Boot Disk Used (GB),Disk Size (GB),Disk Used (GB),DB Disk Size (GB),DB Disk Used (GB),BUP Size (GB)
## Add this line in "crontab -e" to run every hour "5 * * * * /bin/bash /opt/rpstrata/piqlogs.sh"
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
bootdiskUsed=$(printf "%0.2f\n" $(df | awk '/root/{print ($4/1000000)}'))
bootdiskAvail=$(printf "%0.2f\n" $(df | awk '/root/{print ($3/1000000)}'))
diskUsed=$(printf "%0.2f\n" $(df | awk '/sda1/{print ($4/1000000)}'))
diskAvail=$(printf "%0.2f\n" $(df | awk '/sda1/{print ($3/1000000)}'))
dbdiskUsed=$(printf "%0.2f\n" $(df | awk '/sdb1/{print ($4/1000000)}'))
dbdiskAvail=$(printf "%0.2f\n" $(df | awk '/sdb1/{print ($3/1000000)}'))
backupSize=$(find / -name "rpstrata_[0-2][0-9][0-9][0-9]*.sql" | sort -Mr | xargs du -sh | awk -F"G" 'NR==1 {print $1}')
logLocation="/var/log/rpstrata"

# Log Output
# Table Format
{

    if [ -f "$logLocation/piqlogs$dateNow.csv" ]; then
        echo "Adding new log in the existing piqlogs.csv..."
    echo "$dateNow,$time,$piqVersion,$cpuModel,$cpuNumber,$cpuGHz,$cpuIdle,$memUsed,$memTotal,$bootdiskAvail,$bootdiskUsed,$diskUsed,$diskAvail,$dbdiskUsed,$dbdiskAvail,$backupSize" >> $logLocation/piqlogs$dateNow.csv
    echo "New log added to $logLocation/piqlogs_$dateNow.csv"
    else 
       echo "Starting logfile" && echo -e "Date,Time,PIQ Version,CPU Model,CPU(s),CPU (GHz), CPU Idle Time, RAM Used (GB), RAM Total (GB), Boot Disk Size (GB), Boot Disk Used (GB),Disk Size (GB),Disk Used (GB),DB Disk Size (GB),DB Disk Used (GB),BUP Size (GB)
$dateNow,$time,$piqVersion,$cpuModel,$cpuNumber,$cpuGHz,$cpuIdle,$memUsed,$memTotal,$bootdiskAvail,$bootdiskUsed,$diskUsed,$diskAvail,$dbdiskUsed,$dbdiskAvail,$backupSize" > $logLocation/piqlogs$dateNow.csv
    echo "$logLocation/piqlogs$dateNow.csv has been created"
    fi
} || {
    echo "Error creating logs"
}

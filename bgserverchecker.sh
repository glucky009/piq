#!/bin/bash

############################################################################
## Author :PIQ Support
## Date : 13/02/2019	
## Version : 1.0
## Description : Checks if the bgServer service is running and attempts to start it up to 5 times it if not
## 
## Add this line in "crontab -e" of root to run every hour "3 * * * * /bin/bash /opt/rpstrata/piqstatus/bgserverchecker.sh"
##
###########################################################################

#Counters
n=0

#bgServer Checker Script
until [ $n -ge 5 ]
do
    bgServer=$(ps aux | grep BG | wc -l)
    if [[ $bgServer -eq 1 ]]; then
        rm -rf /opt/rpstrata/root/bg.pid
        rm -rf /opt/rpstrata/root/bg_nohup.log
        service stunnel stop
        service stunnel start
        /bin/bash /opt/rpstrata/bgserver_start.sh
        n=$[n+1]
        sleep 5
    else
        n=$[n+5]
        echo "BGServer is now running"
    fi
done
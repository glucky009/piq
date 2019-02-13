#!/bin/bash

n=0

until [ $n -ge 5 ]
do
    bgServer=$(ps aux | grep BG | wc -l)
    if [[ $bgServer -eq 1 ]]; then
      
        rm -rf /opt/rpstrata/root/bg.pid
        rm -rf /opt/rpstrata/root/bg_nohup.log
        /bin/bash /opt/rpstrata/bgserver_start.sh
        n=$[n+1]
        sleep 5
    else
        n=$[n+5]
        echo "BGServer is now running"
    fi
done
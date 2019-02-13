#!/bin/bash

bgServer=$(ps aux | grep BG | wc -l)

while [[ $bgServer -eq 1 ]]; 
    do
        if [[ $bgServer -eq 1 ]]; then
            rm -rf /opt/rpstrata/root/bg.pid
            rm -rf /opt/rpstrata/root/bg_nohup.log
            /bin/bash /opt/rpstrata/bgserver_start.sh
        break
        elif [[ $bgServer -eq 2 ]]; then
            echo "BG Server is already running"
        else
            echo "BG Server is already running"
        fi
done
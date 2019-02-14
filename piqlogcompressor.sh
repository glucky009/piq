#!/bin/sh
############################################################################
## Author :PIQ Support
## Date : 11/02/2019 	
## Version : 1.00
## Description : Compresses the logs files and removes them
## 
## Add this line in "crontab -e -u root" to run every month "7 1 1 * * /bin/bash /opt/rpstrata/piqlogcompressor.sh"
##
## Note: This scipt will be ran every month to compress the log files
##
###########################################################################

#Variables

piqlogFiles=/var/log/rpstrata/piqlogs[0-2]*.csv
dateMonth=$(date +"%Y-%m")
dateMonthName=$(date +"%b-%Y %T")
tarLogLocation="/var/log/rpstrata/tarLog.csv"

#Function
Compress ()
{
    tar cfzvP /var/log/rpstrata/piqlogs$dateMonth.tar.gz $piqlogFiles --remove-files
}

#Output
if [ -f $tarLogLocation ]; then
    for p in $(ls $piqlogFiles)
    do
        echo "$dateMonthName,$p" >> $tarLogLocation
    done
    Compress > /dev/null
else
    echo "Date, CSV File" > $tarLogLocation
    for p in $(ls $piqlogFiles)
    do
        echo "$dateMonthName,$p" >> $tarLogLocation
    done
    Compress > /dev/null
fi
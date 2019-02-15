#!/bin/sh
############################################################################
## Author :PIQ Support
## Date : 11/02/2019 	
## Version : 1.00
## Description : Removed tar files two year ago.
## 
## Add this line in "crontab -e -u root" to run every two years "5 2 1 * * /bin/bash /opt/rpstrata/piqlogcompressor.sh"
##
## Note: This scipt will be ran every month to compress the log files
##
###########################################################################

#Variables
dateYear=$(date --date="2 years ago" +%Y)
pigLogTarFiles=$(ls -l /var/log/rpstrata/piqlogs$dateYear*.tar.gz)


#Output
echo -e "Removing \n $pigLogTarFiles"
rm -rf /var/log/rpstrata/piqlogs$dateYear*.tar.gz
echo "Deletion has been completed"
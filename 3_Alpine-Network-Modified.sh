#/bin/sh
############################################################################
## Author : PIQ Support                                                   ##
## Date : 07/10/2019                                                      ##
## Version : 1.1                                                          ##
## Language : Bash                                                        ##
## Description : Enhance the Server Security and Establish                ##
##               the Digital Reign Standards in System                    ##
##               Configuration                                            ##
##                                                                        ##
## Details:                                                               ##
##               I - Initial Setup - Filesystem Configuration             ##
##               II - Services                                            ##
##               III - Network Configuration                              ##
##                             - Network Parameters(Host only)            ##
##                             - Network Parameters(Host and Router)      ##
##                             - IPv6                                     ##
##                             - Uncommon Network Protocols               ##
##                             - No Firewall Configuration on Container   ##
##               IV - Logging and Auditing                                ##
##                             - Configure System Accounting - auditd     ##
##                             - No Logging on Container                  ##
##               V - Access, Authentication and Authorization             ##
##               VI - System File Permissions                             ##
## Warning:      This script will disable unused filesystems              ##
## Note:                                                                  ##
##               This script is needed to be ran in a container that is   ##
##               '--privileged' mode.                                     ##
##               Will create a log file under /var/log                    ##
##               named as system_hardening_"Date Today".log               ##
############################################################################

sysConf="/etc/sysctl.d/00-alpine.conf"
dateNow=$(date +"%Y%m%d-%H%M%S")
logloc="/var/log/"
netcsvlog=$logloc"3-network_$dateNow.csv"
netlog=$logloc"3-network_$dateNow.log"
modprobeconf="/etc/modprobe.d/network-cis.conf"

echo "Backing up $sysConf"
cp -rp $sysConf $sysConf".backup_"$dateNow

apk add sed

seperate_func()
{
    echo "================================" | tee -a $netlog
    echo "$1" | tee -a $netlog
    echo "================================" | tee -a $netlog      
}

sendlogfile()
{
    echo "$1,$csvstatus,$3" >> $netcsvlog
    echo "$1:$2, $3" >> $netlog
}

echo "Network , Set Correctly, Comments" | tee -a $netcsvlog

Title='Network Parameters (Host Only)'
seperate_func "$Title"



## 3.1.1 Ensure IP forwarding is disabled

Header="Ensure IP forwarding is disabled"
search="$(grep -c -e '^net.ipv4.ip_forward' $sysConf)"
searchstr="$(grep -e '^net.ipv4.ip_forward' $sysConf)"
if [ "$searchstr" == "net.ipv4.ip_forward = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="IP Forward set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.ip_forward = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding IP forward value (0)"
else
    sed -i "s/$searchstr/net.ipv4.ip_forward = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing IP forward value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.route.flush' $sysConf)"
searchstr="$(grep -e '^net.ipv4.route.flush' $sysConf)"
if [ "$searchstr" == "net.ipv4.route.flush = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="ip routeflush set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.route.flush = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding ip routeflush value (1)"
else
    sed -i "s/$searchstr/net.ipv4.route.flush = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing ip routeflush value (1)"
fi

## 3.1.2 Ensure packet redirect sending is disabled (Scored) 

Header="Ensure packet redirect sending is disabled"
search="$(grep -c -e '^net.ipv4.conf.all.send_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.send_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.send_redirects = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="IP send redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.send_redirects = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding IP send redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.send_redirects = 1/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing IP send redirects value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.send_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.send_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.send_redirects = 0" ]
then
    status="Disabled"
    msg="ip send redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.send_redirects = 0" $sysConf
    status="No Value"
    msg="Adding ip send redirects value"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.send_redirects = 0/g" $sysConf
    status="Enabled"
    msg="Changing ip send redirects value"
fi


## 3.2 Network Parameters (Host and Router) 

Title='Network Parameters (Host and Router)'
seperate_func "$Title"


## 3.2.1 Ensure source routed packets are not accepted 

Header="Ensure source routed packets are not accepted"
search="$(grep -c -e '^net.ipv4.conf.all.accept_source_route' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.accept_source_route' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.accept_source_route = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="Source routed packets set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.accept_source_route = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding routed packets value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.accept_source_route = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing routed packets value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.accept_source_route' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.accept_source_route' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.accept_source_route = 0" ]
then
    status="Disabled"
    msg="Source routed packets set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.accept_source_route = 0" $sysConf
    status="No Value"
    msg="Adding routed packets value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.accept_source_route = 0/g" $sysConf
    status="Enabled"
    msg="Changing routed packets value to 0"
fi


## 3.2.2 Ensure ICMP redirects are not accepted

Header="Ensure ICMP redirects are not accepted"
search="$(grep -c -e '^net.ipv4.conf.all.accept_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.accept_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.accept_redirects = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="ICMP redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.accept_redirects = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding ICMP redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.accept_redirects = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing ICMP redirects value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.accept_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.accept_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.accept_redirects = 0" ]
then
    status="Disabled"
    msg="ICMP secure redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.accept_redirects = 0" $sysConf
    status="No Value"
    msg="Adding ICMP secure redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.accept_redirects = 0/g" $sysConf
    status="Enabled"
    msg="Changing ICMP secure redirects value to 0"
fi

## 3.2.3 Ensure secure ICMP redirects are not accepted 

Header="Ensure secure ICMP redirects are not accepted"
search="$(grep -c -e '^net.ipv4.conf.all.secure_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.secure_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.secure_redirects = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="secure ICMP redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.secure_redirects = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="secure ICMP redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.secure_redirects = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing secure ICMP redirects value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.secure_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.secure_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.secure_redirects = 0" ]
then
    status="Disabled"
    msg="ICMP redirects set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.secure_redirects = 0" $sysConf
    status="No Value"
    msg="Adding ICMP Redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.secure_redirects = 0/g" $sysConf
    status="Enabled"
    msg="Changing ICMP Redirects value to 0"
fi

## 3.2.4 Ensure suspicious packets are logged

Header="Ensure suspicious packets are logged"
search="$(grep -c -e '^net.ipv4.conf.all.log_martians' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.log_martians' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.log_martians = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="Suspicious Packet Logging is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.log_martians = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding Suspicious Packet Logging value (1)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.log_martians = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing Suspicious Packet Logging value to 1"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.log_martians' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.log_martians' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.log_martians = 1" ]
then
    status="Enabled"
    msg="Suspicious Packet Logging is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.log_martians = 1" $sysConf
    status="No Value"
    msg="Adding Suspicious Packet Logging value (1)"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.log_martians = 1/g" $sysConf
    status="Enabled"
    msg="Changing Suspicious Packet Logging value to 1"
fi

## 3.2.5 Ensure broadcast ICMP requests are ignored 

Header="Ensure broadcast ICMP requests are ignored"
search="$(grep -c -e '^net.ipv4.icmp_echo_ignore_broadcasts' $sysConf)"
searchstr="$(grep -e '^net.ipv4.icmp_echo_ignore_broadcasts' $sysConf)"
if [ "$searchstr" == "net.ipv4.icmp_echo_ignore_broadcasts = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="Ignore broadcast is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.icmp_echo_ignore_broadcasts = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding Ignore broadcast value (1)"
else
    sed -i "s/$searchstr/net.ipv4.icmp_echo_ignore_broadcasts = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing Ignore broadcast value to 1"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.2.6 Ensure bogus ICMP responses are ignored

Header="Ensure bogus ICMP responses are ignored"
search="$(grep -c -e '^net.ipv4.icmp_ignore_bogus_error_responses' $sysConf)"
searchstr="$(grep -e '^net.ipv4.icmp_ignore_bogus_error_responses' $sysConf)"
if [ "$searchstr" == "net.ipv4.icmp_ignore_bogus_error_responses = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="Ignore bogus error is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.icmp_ignore_bogus_error_responses = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding Ignore bogus error value (1)"
else
    sed -i "s/$searchstr/net.ipv4.icmp_ignore_bogus_error_responses = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing Ignore bogus error value to 1"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.2.7 Ensure Reverse Path Filtering is enabled 

Header="Ensure Reverse Path Filtering is enabled"
search="$(grep -c -e '^net.ipv4.conf.all.rp_filter' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.all.rp_filter' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.all.rp_filter = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="Reverse Path Filtering is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.all.rp_filter = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding Reverse Path Filtering error value (1)"
else
    sed -i "s/$searchstr/net.ipv4.conf.all.rp_filter = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing Reverse Path Filtering value to 1"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv4.conf.default.rp_filter' $sysConf)"
searchstr="$(grep -e '^net.ipv4.conf.default.rp_filter' $sysConf)"
if [ "$searchstr" == "net.ipv4.conf.default.rp_filter = 1" ]
then
    status="Enabled"
    msg="Reverse Path Filtering is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.conf.default.rp_filter = 1" $sysConf
    status="No Value"
    msg="Adding Reverse Path Filtering error value (1)"
else
    sed -i "s/$searchstr/net.ipv4.conf.default.rp_filter = 1/g" $sysConf
    status="Disabled"
    msg="Changing Reverse Path Filtering value to 1"
fi

## 3.2.8 Ensure TCP SYN Cookies is enabled 

Header="Ensure TCP SYN Cookies is enabled"
search="$(grep -c -e '^net.ipv4.tcp_syncookies' $sysConf)"
searchstr="$(grep -e '^net.ipv4.tcp_syncookies' $sysConf)"
if [ "$searchstr" == "net.ipv4.tcp_syncookies = 1" ]
then
    status="Enabled"
    csvstatus="Yes"
    msg="TCP SYN Cookies is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv4.tcp_syncookies = 1" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding TCP SYN Cookies value (1)"
else
    sed -i "s/$searchstr/net.ipv4.tcp_syncookies = 1/g" $sysConf
    status="Disabled"
    csvstatus="No"
    msg="Changing TCP SYN Cookies value to 1"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.3 IPv6 

Title='IPv6'
seperate_func "$Title"

## 3.3.1  Ensure IPv6 router advertisements are not accepted 

Header="Ensure IPv6 router advertisements are not accepted"
search="$(grep -c -e '^net.ipv6.conf.all.accept_ra' $sysConf)"
searchstr="$(grep -e '^net.ipv6.conf.all.accept_ra' $sysConf)"
if [ "$searchstr" == "net.ipv6.conf.all.accept_ra = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="IPv6 router advertisements is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv6.conf.all.accept_ra = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding IPv6 router advertisements value (0)"
else
    sed -i "s/$searchstr/net.ipv6.conf.all.accept_ra = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing IPv6 router advertisements value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv6.conf.default.accept_ra' $sysConf)"
searchstr="$(grep -e '^net.ipv6.conf.default.accept_ra' $sysConf)"
if [ "$searchstr" == "net.ipv6.conf.default.accept_ra = 0" ]
then
    status="Disabled"
    msg="Reverse Path Filtering is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv6.conf.default.accept_ra = 0" $sysConf
    status="No Value"
    msg="Adding Reverse Path Filtering error value (0)"
else
    sed -i "s/$searchstr/net.ipv6.conf.default.accept_ra = 0/g" $sysConf
    status="Enabled"
    msg="Changing Reverse Path Filtering value to 0"
fi

## 3.3.2 Ensure IPv6 redirects are not accepted

Header="Ensure IPv6 redirects are not accepted"
search="$(grep -c -e '^net.ipv6.conf.all.accept_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv6.conf.all.accept_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv6.conf.all.accept_redirects = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="IPv6 redirects is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv6.conf.all.accept_redirects = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding IPv6 redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv6.conf.all.accept_redirects = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing IPv6 redirects value to 0"
fi
sendlogfile "$Header" "$status" "$msg"

search="$(grep -c -e '^net.ipv6.conf.default.accept_redirects' $sysConf)"
searchstr="$(grep -e '^net.ipv6.conf.default.accept_redirects' $sysConf)"
if [ "$searchstr" == "net.ipv6.conf.default.accept_redirects = 0" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="IPv6 redirects is set correctly"
elif [ $search -eq 0 ]
then
    sed -i "$ a\net.ipv6.conf.default.accept_redirects = 0" $sysConf
    status="No Value"
    csvstatus="No"
    msg="Adding IPv6 redirects value (0)"
else
    sed -i "s/$searchstr/net.ipv6.conf.default.accept_redirects = 0/g" $sysConf
    status="Enabled"
    csvstatus="No"
    msg="Changing IPv6 redirects value to 0"
fi

## 3.3.3 Ensure IPv6 is disabled

Header="Ensure IPv6 is disabled"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="No access to set Grub"
sendlogfile "$Header" "$status" "$msg"

## 3.4 TCP Wrappers 

Title='TCP Wrappers'
seperate_func "$Title"

## 3.4.1 Ensure TCP Wrappers is installed 

#apk add tcpd

Header="Ensure TCP Wrappers is installed"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="TCP Wrappers not available"
sendlogfile "$Header" "$status" "$msg"

## 3.4.2 Ensure /etc/hosts.allow is configured

Header="Ensure /etc/hosts.allow is configured"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="Must be Manually Set"
sendlogfile "$Header" "$status" "$msg"

## 3.4.3 Ensure /etc/hosts.deny is configured

Header="Ensure /etc/hosts.deny is configured"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="Must be Manually Set"
sendlogfile "$Header" "$status" "$msg"

## 3.4.4 Ensure permissions on /etc/hosts.allow are configured

chown root:root /etc/hosts.allow
chmod 0644 /etc/hosts.allow

## 3.4.5 Ensure permissions on /etc/hosts.deny are configured

chown root:root /etc/hosts.deny
chmod 0644 /etc/hosts.deny

## 3.5 Uncommon Network Protocols 

Title='Uncommon Network Protocols'
seperate_func "$Title"
touch $modprobeconf

## 3.5.1 Ensure DCCP is disabled 

Header="Ensure DCCP is disabled"
search="$(lsmod | grep -c -e dccp)"
searchstr="$(grep -e '^install dccp /bin/true' $modprobeconf)"
if [ "$searchstr" == "install dccp /bin/true" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="DCCP is set correctly"
elif [ $search -eq 0 ]
then
    echo "install dccp /bin/true" >> $modprobeconf
    status="No Value"
    csvstatus="No"
    msg="Adding install dccp /bin/true to $modprobeconf"
else
    sed -i "s/$searchstr/'install dccp /bin/true'/g" $modprobeconf
    status="Enabled"
    csvstatus="No"
    msg="Adding install dccp /bin/true to $modprobeconf"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.5.2 Ensure SCTP is disabled 
Header="Ensure SCTP is disabled"
search="$(lsmod | grep -c -e sctp)"
searchstr="$(grep -e '^install sctp /bin/true' $modprobeconf)"
if [ "$searchstr" == "install sctp /bin/true" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="SCTP is set correctly"
elif [ $search -eq 0 ]
then
    echo "install sctp /bin/true" >> $modprobeconf
    status="No Value"
    csvstatus="No"
    msg="Adding install sctp /bin/true to $modprobeconf"
else
    sed -i "s/$searchstr/'install sctp /bin/true'/g" $modprobeconf
    status="Enabled"
    csvstatus="No"
    msg="Adding install sctp /bin/true to $modprobeconf"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.5.3 Ensure RDS is disabled 
Header="Ensure RDS is disabled"
search="$(lsmod | grep -c -e rds)"
searchstr="$(grep -e '^install rds /bin/true' $modprobeconf)"
if [ "$searchstr" == "install rds /bin/true" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="RDS is set correctly"
elif [ $search -eq 0 ]
then
    echo "install rds /bin/true" >> $modprobeconf
    status="No Value"
    csvstatus="No"
    msg="Adding install rds /bin/true to $modprobeconf"
else
    sed -i "s/$searchstr/'install rds /bin/true'/g" $modprobeconf
    status="Enabled"
    csvstatus="No"
    msg="Adding install rds /bin/true to $modprobeconf"
fi
sendlogfile "$Header" "$status" "$msg"

# ## 3.5.4 Ensure TIPC is disabled

Header="Ensure TIPC is disabled"
search="$(lsmod | grep -c -e tipc)"
searchstr="$(grep -e '^install tipc /bin/true' $modprobeconf)"
if [ "$searchstr" == "install tipc /bin/true" ]
then
    status="Disabled"
    csvstatus="Yes"
    msg="TIPC is set correctly"
elif [ $search -eq 0 ]
then
    echo "install tipc /bin/true" >> $modprobeconf
    status="No Value"
    csvstatus="No"
    msg="Adding install tipc /bin/true to $modprobeconf"
else
    sed -i "s/$searchstr/'install tipc /bin/true'/g" $modprobeconf
    status="Enabled"
    csvstatus="No"
    msg="Adding install tipc /bin/true to $modprobeconf"
fi
sendlogfile "$Header" "$status" "$msg"

## 3.6 Firewall Configuration

Title='Firewall Configuration'
seperate_func "$Title"

Header="Firewall Configuration"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="Must be set on Host Machine"
sendlogfile "$Header" "$status" "$msg"

## 3.7 Ensure wireless interfaces are disabled

Title='Ensure wireless interfaces are disabled'
seperate_func "$Title"

Header="Ensure wireless interfaces are disabled"
Status="Cannot be set"
csvstatus="Cannot be set"
msg="Docker does not have Wireless capability"
sendlogfile "$Header" "$status" "$msg"

## remove sed

apk del sed
#!/usr/bin/env python
import os
import subprocess
import platform
import datetime
import re
import ethtool


today = datetime.date.today()
pfinfo = platform.uname()
curruser = os.getlogin()

print "----------------------------------------------------------------------"
print "System Information"
print "----------------------------------------------------------------------"
print today.strftime('Date: %b. %d, %Y')
print 'Current User: ' + curruser
print 'Platform: ' + pfinfo[0]
print 'Hostname: ' + pfinfo[1]
print pfinfo[2]
print pfinfo[3]
print pfinfo[4]

print "----------------------------------------------------------------------"
print "Memory Information"
print "----------------------------------------------------------------------"
with open('/proc/meminfo') as f:
    meminfo = [line.strip() for line in f]
f.close()

print meminfo[0]
print meminfo[1]
print meminfo[2]
print meminfo[3]
print meminfo[17]
print meminfo[18]

print "----------------------------------------------------------------------"
print "Services Status"
print "----------------------------------------------------------------------"

p = subprocess.Popen(["ps", "-A"], stdout=subprocess.PIPE)

out, err = p.communicate()
serv = ['httpd', 'smbd', 'ntpd', 'stunnel', 'nmbd', 'BGServer', 'mysqld']

for service in serv:
    if (service in str(out)):
        print(service + ' is running')
    else:
        print (service + ' is NOT running ')

print "----------------------------------------------------------------------"
print "Live Network Interface"
print "----------------------------------------------------------------------"
netif = ethtool.get_active_devices()
for ifs in netif:
    netinfo = ethtool.get_ipaddr(ifs)
    print ifs + " " + netinfo
    intinfo = '/etc/sysconfig/network-scripts/' + "ifcfg-" + ifs
    with open(intinfo) as i:
        netinfo = [line.strip() for line in i]
        reg = re.compile("GATEWAY")
        res = filter(reg.match,netinfo)
        print ''.join(res)
        msk = re.compile("NETMASK")
        resmsk = filter(msk.match, netinfo)
        print ''.join(resmsk) + "\n"
        i.close()

print "----------------------------------------------------------------------"
print "Top 5 Memory Consuming Processes"
print "----------------------------------------------------------------------"
proc = os.system("ps -eo pmem,pcpu,vsize,pid,user | sort -k 1 -nr | head -5")
print proc

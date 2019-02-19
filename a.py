#!/usr/bin/python

# Modules
import subprocess

def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read().strip('\n')

#output = linuxCommand(["ps", "aux"])
output = linuxCommand(["top", "-a", "-n", "1"])
print (output.index('0.0st'))
#print (output[1183:1876])
#print (output[353:70])
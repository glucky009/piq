#!/usr/bin/python

# Modules
import subprocess

def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read()

#output = linuxCommand(["ps", "aux"])
#output = linuxCommand(["top", "-a", "-n", "1"])
output = linuxCommand(["ls"])
print output

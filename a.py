#!/usr/bin/python

# Modules
import subprocess

def linuxCommand (commandList):
    proc = subprocess.Popen(commandList, stdout=subprocess.PIPE)
    return proc.stdout.read().strip('\n')

#output = linuxCommand(["ps", "aux"])

output = linuxCommand(["top", "-a", "-n", "1"]).splitlines()
print(output[7:9].strip("\n"))
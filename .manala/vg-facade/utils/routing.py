#!/usr/bin/env python3
# ====================
# Fix ip routing on modern distros
import subprocess
import sys

output = subprocess.getstatusoutput('ip route')
terms = output[1].splitlines()[0].split() # get 99% probably default interface array
first = terms[0]
last = terms[-1]

interfaces = subprocess.getoutput('ip -o link show').splitlines()
lastinterface = interfaces[-1].split(':')[1].strip()
i = 2;

while lastinterface.find('eth'):
      lastinterface = interfaces[-i].split(':')[1].strip()
      i+=1

if first != 'default' or last != lastinterface:
      print("Fixing routing from {0} to {1} ".format(last, lastinterface))
      scmd = 'ip route add default via {0} dev {1}'.format(sys.argv[1], lastinterface)
      subprocess.getstatusoutput('ip route del default')
      subprocess.getstatusoutput(scmd)

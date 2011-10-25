#!/usr/bin/python

import sys
import time
import subprocess
from socket import socket
import timeit

CARBON_SERVER = 'mon0.puppetlabs.lan'
CARBON_PORT = 2003

PROJECT_NAME = sys.argv[1]
REPO_PATH = sys.argv[2]
SPEC_CMD = ["/usr/bin/rake","spec"]
SPEC_OUTPUT = open("/opt/metrics/spec_output.log",'a')
SPEC_ERRORS = open("/opt/metrics/spec_errors.log",'a')

LANG = "Ruby"

def run_spec():
  subprocess.call(SPEC_CMD,cwd=REPO_PATH,stdout=SPEC_OUTPUT,stderr=SPEC_ERRORS)

def time_spec():
  t0 = time.time()
  run_spec()
  return time.time() - t0

sock = socket()
try:
  sock.connect( (CARBON_SERVER,CARBON_PORT) )
except:
  print "Couldn't connect to %(server)s on port %(port)d, is carbon-agent.py running?" % { 'server':CARBON_SERVER, 'port':CARBON_PORT }
  sys.exit(1)

lines = []
spectime = time_spec()
now = int( time.time() )
lines.append("sources.%(project)s.spectime %(result)s %(time)s" % {'project' : PROJECT_NAME, 'result' : spectime, 'time' : now})
message = '\n'.join(lines) + '\n' #all lines must end in a newline
print message
sock.sendall(message)
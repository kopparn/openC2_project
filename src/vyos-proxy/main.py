import stix2
import http.client
import sys
import os
sys.path.append("/etc/openc2-proxy")
import openc2
import json
import subprocess
import socket

def main():
    ms = sys.stdin
    msg = json.load(ms)
    openc2_cmd = openc2.parse(msg)
    openc2_cmd.check_object_constraints()
    action = openc2_cmd["action"]   
    addr1 = msg["target"]["ipsec_targets"]["addr1"]
    addr2 = msg["target"]["ipsec_targets"]["addr2"]
    try:
        socket.inet_aton(addr1)
    except socket.error:
        print("Error: addr1 is invalid")
        sys.exit(1)
    try:
        socket.inet_aton(addr2)
    except socket.error:
        print("Error: addr2 is invalid")
        sys.exit(1)
    gateway = subprocess.Popen("ip route | grep default | cut -f3 -d' '", shell=True, stdout=subprocess.PIPE).communicate()[0].strip().decode('ascii')
    if addr1 == gateway :
        addr1, addr2 = addr2,addr1
    if action == "start" :
        cmd1 = "ssh vyos@" + addr1 +  " 'bash -s' < /etc/openc2-proxy/src/start_ipsec.sh"
        cmd2 = "ssh vyos@" + addr2 +  " 'bash -s' < /etc/openc2-proxy/src/start_ipsec.sh"
        os.system(cmd1)
        os.system(cmd2)
    elif action == "stop" :
        cmd1 = "ssh vyos@" + addr1 +  " 'bash -s' < /etc/openc2-proxy/src/stop_ipsec.sh"
        cmd2 = "ssh vyos@" + addr2 +  " 'bash -s' < /etc/openc2-proxy/src/stop_ipsec.sh"
        os.system(cmd1)
        os.system(cmd2)

if __name__ == '__main__':
    main()

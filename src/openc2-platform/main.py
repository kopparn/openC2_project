import stix2
import http.client
import sys
import os
sys.path.append("/etc/openc2-platform")
import openc2
import json
import subprocess
import socket
import requests

def main():
    ms = sys.stdin
    msg = json.load(ms)
    openc2_cmd = openc2.parse(msg)
    openc2_cmd.check_object_constraints()
    try:
        msg["target"]["db:db_name"]
        target = "172.30.0.3" 
    except:
        target = "172.30.0.6"
    msg = openc2_cmd.serialize()
    headers = {'content-type': 'application/json'}
    response = requests.post('https://' + target + ':443/openc2.php', data=msg, headers=headers, verify=False)
    print(response.json)

if __name__ == '__main__':
    main()

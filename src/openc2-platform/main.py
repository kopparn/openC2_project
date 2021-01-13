import stix2
import requests
import sys
sys.path.append("/etc/openc2-platform")
import openc2
import json

def main():
    cmd = openc2.v10.DB(
            action="delete",
            target=openc2.v10.DBTarget(db_name="my_database"),
            args=openc2.v10.Args(response_requested="complete"),
    )
    msg = cmd.serialize()
    headers = {'content-type': 'application/json'}
    response = requests.post('http://172.30.0.3:80/openc2.php', data=msg, headers=headers)
    print(response.json)
    #cmd = openc2.parse(msg)
    #print(cmd)

if __name__ == '__main__':
    main()

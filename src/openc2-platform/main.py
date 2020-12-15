import stix2
import requests
import sys
sys.path.append("..")
import openc2
import json

def main():
    cmd = openc2.v10.DB(
            action="copy",
            target=openc2.v10.DBTarget(db_name="my_database"),
            args=openc2.v10.Args(response_requested="complete"),
    )
    msg = cmd.serialize()
    data = json.dumps(msg)
    request = requests.post('http://localhost:8080/openc2.php', json=data)
    print(request.json)
    #cmd = openc2.parse(msg)
    #print(cmd)

if __name__ == '__main__':
    main()

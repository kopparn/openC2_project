import stix2
import http.client
import sys
import os
sys.path.append("..")
import openc2
import json

def main():
    ms = sys.stdin.replace("\'","\"")
    msg = json.load(ms)
    openc2_cmd = openc2.parse(msg)
    openc2_cmd.check_object_constraints()
    action = openc2_cmd["action"]
    db_name = msg["target"]["db:db_name"] 
    if action == "copy" :
        mysql_cmd = "mysqldump -u root --password=toor --databases " + db_name + " > " + db_name + ".sql"
    elif action == "restore" :
        mysql_cmd = "mysql -u root --password=toor < " + db_name + ".sql"
    elif action == "delete" :
        mysql_cmd = "rm " + db_name + ".sql"
    os.system(mysql_cmd)

if __name__ == '__main__':
    main()

import stix2
import http.client
import sys
import os
sys.path.append("/etc/openc2-proxy")
import openc2
import json

def main():
    ms = sys.stdin
    msg = json.load(ms)
    openc2_cmd = openc2.parse(msg)
    openc2_cmd.check_object_constraints()
    action = openc2_cmd["action"]
    db_name = msg["target"]["db:db_name"] 
    if action == "copy" :
        mysql_cmd = "mysqldump -u root --password=toor --databases " + db_name + " > " + "/var/www/backups/" + db_name + ".sql"
    elif action == "restore" :
        mysql_cmd = "mysql -u root --password=toor < " + "/var/www/backups/" + db_name + ".sql"
    elif action == "delete" :
        mysql_cmd = "rm " + "/var/www/backups/" + db_name + ".sql"
    os.system(mysql_cmd)

if __name__ == '__main__':
    main()

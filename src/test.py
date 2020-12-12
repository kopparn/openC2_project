import openc2
import stix2

cmd = openc2.v10.DB(
        action="restore",
        target=openc2.v10.DBTarget(db_name="test_db"),
        args=openc2.v10.Args(response_requested="complete"),
)
msg = cmd.serialize()
print(cmd)
cmd = openc2.parse(msg)
print(cmd)

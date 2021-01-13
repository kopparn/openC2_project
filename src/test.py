import openc2
import stix2

cmd = openc2.v10.ROUTER(
        action="delete",
        target=openc2.v10.ROUTERTarget(addr1="aaa",addr2="bb"),
        args=openc2.v10.Args(response_requested="complete"),
)
msg = cmd.serialize()
print(cmd)
cmd = openc2.parse(msg)
print(cmd)

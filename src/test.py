import openc2
import stix2

cmd = openc2.v10.ROUTER(
        action="create",
        target=openc2.v10.ROUTERTarget(addr1="aaa",addr2="aaa"),
        args=openc2.v10.ROUTERArgs(shared_secret="",ike_hash="",esp_hash="",esp_encryption="",ike_encryption=""),
)
msg = cmd.serialize()
print(cmd)
cmd = openc2.parse(msg)
print(cmd)

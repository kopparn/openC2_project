#!/bin/vbash

sudo pkill --signal HUP sshd

echo "#!/bin/vbash" > config_ipsec.sh

echo "newgrp vyattacfg" >> config_ipsec.sh

echo "source /opt/vyatta/etc/functions/script-template" >> config_ipsec.sh


echo "configure" >> config_ipsec.sh
echo "load ipsec.config" >> config_ipsec.sh
echo "set vpn ipsec ike-group MyIKEGroup proposal 1 encryption $3" >> config_ipsec.sh
echo "set vpn ipsec ike-group MyIKEGroup proposal 1 hash $2" >> config_ipsec.sh
echo "set vpn ipsec esp-group MyESPGroup proposal 1 encryption $5" >> config_ipsec.sh
echo "set vpn ipsec esp-group MyESPGroup proposal 1 hash $4" >> config_ipsec.sh
echo "commit" >> config_ipsec.sh
echo "sleep 30" >> config_ipsec.sh
echo "save ipsec.config" >> config_ipsec.sh

chmod 755 config_ipsec.sh
/bin/vbash config_ipsec.sh
exit

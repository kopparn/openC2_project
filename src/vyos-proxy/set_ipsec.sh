#!/bin/vbash

pkill --signal HUP sshd

newgrp vyattacfg

source /opt/vyatta/etc/functions/script-template

configure
load ipsec.config
set vpn ipsec ike-group MyIKEGroup proposal 1 encryption $3
set vpn ipsec ike-group MyIKEGroup proposal 1 hash $2
set vpn ipsec esp-group MyESPGroup proposal 1 encryption $5
set vpn ipsec esp-group MyESPGroup proposal 1 hash $4
commit
save ipsec.config
load
commit
save

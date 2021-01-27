#!/bin/vbash

sudo pkill --signal HUP sshd

newgrp vyattacfg

source /opt/vyatta/etc/functions/script-template

configure
load ipsec.config
commit
save

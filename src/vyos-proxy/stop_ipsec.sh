#!/bin/vbash

pkill --signal HUP sshd

newgrp vyattacfg

source /opt/vyatta/etc/functions/script-template

configure
load default.config
commit
save

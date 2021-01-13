#!/bin/vbash

newgrp vyattacfg

source /opt/vyatta/etc/functions/script-template

configure
load ipsec.config
commit
save

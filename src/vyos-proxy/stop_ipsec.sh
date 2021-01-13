#!/bin/vbash

newgrp vyattacfg

source /opt/vyatta/etc/functions/script-template

configure
load default.config
commit
save

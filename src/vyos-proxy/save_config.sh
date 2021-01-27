#!/bin/vbash

sudo pkill --signal HUP sshd

sudo cp /opt/vyatta/etc/config/archive/config.boot /opt/vyatta/etc/config/ipsec.config

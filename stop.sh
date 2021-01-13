#!/bin/bash

echo "STOPPING DOCKER CONTAINERS"
docker stop vyos1
docker stop vyos2
docker stop mail-server
docker stop mysql-server
docker stop adminer
docker stop client
docker stop openc2-platform
docker stop vyos-proxy
echo "DONE"

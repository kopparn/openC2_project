#!/bin/bash

docker start vyos1
docker start vyos2
docker start mail-server
docker start mysql-server
docker start adminer
docker start client
docker -u 0 exec -it mysql-server sh -c "service apache2 restart"

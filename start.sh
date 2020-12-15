#!/bin/bash

echo "STARTING CONTAINERS"
docker start vyos1
docker start vyos2
docker start mail-server
docker start mysql-server
docker start adminer
docker start client
docker start openc2-platform

echo "CONFIGURING GATEWAYS"
sleep 30
docker exec -u 0 -it client ip route del default
docker exec -u 0 -it client ip route add default via 172.31.0.2 dev eth1
docker exec -u 0 -it mail-server ip route del default
docker exec -u 0 -it mail-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it mysql-server ip route del default
docker exec -u 0 -it mysql-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it openc2-platform ip route del default
docker exec -u 0 -it openc2-platform ip route add default via 172.30.0.2 dev eth1

echo "STARTING APACHE SERVER"
docker exec -u 0 -it mysql-server sh -c "service apache2 restart"

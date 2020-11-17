#!/bin/bash

#Création de l'image vyos
echo "BUILDING VYOS IMAGE"
sudo apt-get install -y squashfs-tools docker-compose wget
mkdir ./vyos/unsquashfs
mkdir ./vyos/rootfs
wget -c https://downloads.vyos.io/rolling/current/amd64/vyos-rolling-latest.iso -O ./vyos/vyos-latest.iso
sudo mount -o loop ./vyos/vyos-latest.iso ./vyos/rootfs
unsquashfs -f -d ./vyos/unsquashfs/ ./vyos/rootfs/live/filesystem.squashfs
tar -C ./vyos/unsquashfs -c . | docker import - vyos
sudo umount ./vyos/rootfs

#Build des conteneurs
echo "BUILDING CONTAINERS"
docker-compose build
docker-compose up -d

#Creation des réseaux docker
echo "NETWORKS CREATION"
docker network create \
	--driver=bridge \
	--subnet=172.30.0.0/16 \
	--gateway=172.30.0.1 \
	local_1
docker network create \
	--driver=bridge \
	--subnet=172.31.0.0/16 \
	--gateway=172.31.0.1 \
	local_2
docker network create \
	--driver=bridge \
	--subnet=172.32.0.0/16 \
	public

#Connexion des conteneurs
echo "CONTAINERS CONNECTION"
docker network connect --ip 172.30.0.2 local_1 vyos1
docker network connect --ip 172.31.0.2 local_2 vyos2
docker network connect --ip 172.32.0.2 public vyos1
docker network connect --ip 172.32.0.3 public vyos2
docker network connect --ip 172.30.0.3 local_1 mysql-server
docker network connect --ip 172.30.0.4 local_1 mail-server
docker network connect --ip 172.31.0.3 local_2 client

#Configuration des gateways
echo "GATEWAYS CONFIGURATION"
sleep 30
docker exec -u 0 -it client ip route del default
docker exec -u 0 -it client ip route add default via 172.31.0.2 dev eth1
docker exec -u 0 -it mail-server ip route del default
docker exec -u 0 -it mail-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it mysql-server ip route del default
docker exec -u 0 -it mysql-server ip route add default via 172.30.0.2 dev eth1

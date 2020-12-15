#!/bin/bash

#Création de l'image vyos
echo "BUILDING VYOS IMAGE"
sudo apt-get install -y squashfs-tools docker-compose wget
mkdir ./containers/vyos/unsquashfs
mkdir ./containers/vyos/rootfs
wget -c https://downloads.vyos.io/rolling/current/amd64/vyos-rolling-latest.iso -O ./containers/vyos/vyos-latest.iso
sudo mount -o loop ./containers/vyos/vyos-latest.iso ./containers/vyos/rootfs
sudo unsquashfs -f -d ./containers/vyos/unsquashfs/ ./containers/vyos/rootfs/live/filesystem.squashfs
tar -C ./containers/vyos/unsquashfs -c . | docker import - vyos
sudo umount ./containers/vyos/rootfs

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
#docker network disconnect openc2_project_default vyos1
#docker network disconnect openc2_project_default vyos2
#docker network disconnect openc2_project_default mysql-server
#docker network disconnect openc2_project_default mail-server
#docker network disconnect openc2_project_default openc2-platform
#docker network disconnect openc2_project_default client
docker network connect --ip 172.30.0.2 local_1 vyos1
docker network connect --ip 172.30.0.3 local_1 mysql-server
docker network connect --ip 172.30.0.4 local_1 mail-server
docker network connect --ip 172.30.0.5 local_1 openc2-platform
docker network connect --ip 172.31.0.2 local_2 vyos2
docker network connect --ip 172.31.0.3 local_2 client
docker network connect --ip 172.32.0.2 public vyos1
docker network connect --ip 172.32.0.3 public vyos2

#Configuration des gateways
echo "GATEWAYS CONFIGURATION"
sleep 30
docker exec -u 0 -it client ip route del default
docker exec -u 0 -it client ip route add default via 172.31.0.2 dev eth1
docker exec -u 0 -it mail-server ip route del default
docker exec -u 0 -it mail-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it mysql-server ip route del default
docker exec -u 0 -it mysql-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it openc2-platform ip route del default
docker exec -u 0 -it openc2-platform ip route add default via 172.30.0.2 dev eth1

#Mise en place de la base de donnée
echo "LOADING DATABASE"
docker exec -u 0 -it mysql-server sh -c "mysql -u root --password=toor < /tmp/my_database.sql"

#Démarrage du serveur Apache2
echo "LAUNCHING APACHE2 SERVER"
docker exec -u 0 -it mysql-server sh -c "service apache2 restart" 

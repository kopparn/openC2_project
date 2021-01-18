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
echo "DONE"

#Création des configurations vyos
echo "COPYING VYOS CONFIGURATIONS"
mkdir -p ./containers/vyos/vyos1/config
cp ./containers/vyos/vyos1/config.init ./containers/vyos/vyos1/config/config.boot
cp ./containers/vyos/vyos1/config.init ./containers/vyos/vyos1/config/default.config
cp ./containers/vyos/vyos1/ipsec.config ./containers/vyos/vyos1/config/ipsec.config
mkdir -p ./containers/vyos/vyos2/config
cp ./containers/vyos/vyos2/config.init ./containers/vyos/vyos2/config/config.boot
cp ./containers/vyos/vyos2/config.init ./containers/vyos/vyos2/config/default.config
cp ./containers/vyos/vyos2/ipsec.config ./containers/vyos/vyos2/config/ipsec.config
echo "DONE"

#Build des conteneurs
echo "BUILDING CONTAINERS"
docker-compose build
docker-compose up -d
echo "DONE"

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
echo "DONE"

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
docker network connect --ip 172.30.0.6 local_1 vyos-proxy
docker network connect --ip 172.31.0.2 local_2 vyos2
docker network connect --ip 172.31.0.3 local_2 client
docker network connect --ip 172.32.0.2 public vyos1
docker network connect --ip 172.32.0.3 public vyos2
echo "DONE"

#Configuration des gateways
echo "GATEWAYS CONFIGURATION"
sleep 30
docker exec -u 0 -it client ip route del default
docker exec -u 0 -it client ip route add default via 172.31.0.2 dev eth1
docker exec -u 0 -it client ip route del 172.31.0.0/16
docker exec -u 0 -it mail-server ip route del default
docker exec -u 0 -it mail-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it mail-server ip route del 172.30.0.0/16
docker exec -u 0 -it mysql-server ip route del default
docker exec -u 0 -it mysql-server ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it mysql-server ip route del 172.30.0.0/16
docker exec -u 0 -it openc2-platform ip route del default
docker exec -u 0 -it openc2-platform ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it openc2-platform ip route del 172.30.0.0/16
docker exec -u 0 -it vyos-proxy ip route del default
docker exec -u 0 -it vyos-proxy ip route add default via 172.30.0.2 dev eth1
docker exec -u 0 -it vyos-proxy ip route del 172.30.0.0/16
echo "DONE"

#Mise en place de la base de donnée
echo "LOADING DATABASE"
docker exec -u 0 -it mysql-server sh -c "mysql -u root --password=toor < /tmp/my_database.sql"
echo "DONE"

#Démarrage du serveur Apache2
echo "LAUNCHING APACHE2 SERVERS"
docker exec -u 0 -it mysql-server sh -c "service apache2 restart" 
docker exec -u 0 -it vyos-proxy sh -c "service apache2 restart" 
echo "DONE"

#Génération des clés ssh
echo "CREATING AND EXCHANGING VYOS-PROXY SSH KEYS"
docker exec -u 0 -it vyos-proxy sh -c "mkdir /root/.ssh"
docker exec -u 0 -it vyos-proxy sh -c "(cd /root/.ssh; ssh-keygen -q -t rsa -f id_rsa -C '' -N '')"
docker cp vyos-proxy:/root/.ssh/id_rsa.pub ./id_rsa.pub
docker exec -u vyos -it vyos1 sh -c "mkdir -p /home/vyos/.ssh"
docker cp ./id_rsa.pub vyos1:/home/vyos/.ssh/id_rsa.pub
docker exec -u vyos -it vyos1 sh -c "cat /home/vyos/.ssh/id_rsa.pub >> /home/vyos/.ssh/authorized_keys"
docker exec -u vyos -it vyos2 sh -c "mkdir -p /home/vyos/.ssh"
docker cp ./id_rsa.pub vyos2:/home/vyos/.ssh/id_rsa.pub
docker exec -u vyos -it vyos2 sh -c "cat /home/vyos/.ssh/id_rsa.pub >> /home/vyos/.ssh/authorized_keys"
rm -f id_rsa.pub
echo "DONE"

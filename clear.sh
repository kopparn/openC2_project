#!/bin/bash

./stop.sh

#Suppression des fichiers générés
echo "REMOVING GENERATED FILES"
rm -rf ./containers/vyos/rootfs
rm -rf ./containers/vyos/unsquashfs
#rm -f ./containers/vyos/vyos-latest.iso
rm -rf ./containers/vyos/vyos1/config
rm -rf ./containers/vyos/vyos2/config
echo "DONE"

#Suppression des conteneurs
echo "REMOVING DOCKER CONTAINERS"
docker container rm vyos1
docker container rm vyos2
docker container rm mail-server
docker container rm mysql-server
docker container rm adminer
docker container rm client
docker container rm openc2-platform
docker container rm vyos-proxy
echo "DONE"

#Suppression des images
echo "REMOVING DOCKER IMAGES"
docker rmi openc2_project_vyos1
docker rmi openc2_project_vyos2
docker rmi vyos
docker rmi openc2_project_mail-server
docker rmi marooou/postfix-roundcube
docker rmi openc2_project_mysql-server
docker rmi mysql
docker rmi adminer
docker rmi openc2_project_client
docker rmi openc2_project_openc2-platform
docker rmi openc2_project_vyos-proxy
docker rmi debian
echo "DONE"

#Suppression des réseaux
echo "REMOVING DOCKER NETWORKS"
docker network rm local_1 local_2 public openc2_project_default
echo "DONE"

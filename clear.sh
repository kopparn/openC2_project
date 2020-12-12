#!/bin/bash

./stop.sh

#Suppression des fichiers générés
rm -rf ./containers/vyos/rootfs
rm -rf ./containers/vyos/unsquashfs
rm -f ./containers/vyos/vyos-latest.iso
rm -rf ./containers/config

#Suppression des conteneurs
docker container rm vyos1
docker container rm vyos2
docker container rm mail-server
docker container rm mysql-server
docker container rm adminer
docker container rm client

#Suppression des images
docker rmi openc2_project_vyos1
docker rmi openc2_project_vyos2
docker rmi vyos
docker rmi openc2_project_mail-server
docker rmi marooou/postfix-roundcube
docker rmi openc2_project_mysql-server
docker rmi mysql
docker rmi adminer
docker rmi openc2_project_client
docker rmi debian

#Suppression des réseaux
docker network rm local_1 local_2 public openc2_project_default

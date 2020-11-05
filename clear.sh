#!/bin/bash

./stop.sh

#Suppression des fichiers générés
rm -rf ./vyos/rootfs
rm -rf ./vyos/unsquashfs
rm -f ./vyos/vyos-latest.iso
rm -rf ./config

#Suppression des conteneurs
docker container rm vyos1
docker container rm vyos2
docker container rm mail-server

#Suppression des images
docker rmi vyos
docker rmi openc2_project_vyos1
docker rmi openc2_project_vyos2
docker rmi marooou/postfix-roundcube
docker rmi openc2_project_mail-server

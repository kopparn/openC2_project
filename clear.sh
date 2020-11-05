#!/bin/bash

#Suppression des fichiers générés
rm -rf ./vyos/rootfs
rm -rf ./vyos/unsquashfs
rm -f ./vyos/vyos-latest.iso

#Suppression des conteneurs
docker container rm vyos1
docker container rm vyos2

#Suppression des images
docker rmi vyos
docker rmi openc2_project_vyos1
docker rmi openc2_project_vyos2

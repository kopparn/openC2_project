#!/bin/bash

#Création des conteneurs vyos

sudo apt-get install -y squashfs-tools docker-compose wget
mkdir ./vyos/unsquashfs
mkdir ./vyos/rootfs
wget -c https://downloads.vyos.io/rolling/current/amd64/vyos-rolling-latest.iso -O ./vyos/vyos-latest.iso
sudo mount -o loop ./vyos/vyos-latest.iso ./vyos/rootfs
unsquashfs -f -d ./vyos/unsquashfs/ ./vyos/rootfs/live/filesystem.squashfs
tar -C ./vyos/unsquashfs -c . | docker import - vyos
sudo umount ./vyos/rootfs
docker-compose build
docker-compose up -d

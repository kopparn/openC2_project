# Projet OpenC2

## Présentation du projet

## Mise en place de l'architecture

Le script install.sh, génére l'ensemble de l'architecture, start.sh démarre les conteneurs, stop.sh les stop et clear.sh supprime l'ensemble des conteneurs.

Les configurations initiales des routeurs peuvent être modifiées via les fichiers config.init.

On peut accéder aux routeurs via la commande docker-compose exec -u vyos vyos1 /bin/vbash

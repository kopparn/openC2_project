# Projet OpenC2

## Présentation du projet

## Scénarios d'attaques justifiant la mise en place de contremesures

D’un point de vue général, se pose la question de savoir comment on matérialise les scénarios. On explique l’attaque et on lance une commande ou un script réalisant le scénario de contremesure correspondant ou on tente d’automatiser avec un script qui simule plus ou moins l’attaque et un enchainement avec une réponse automatique. L’idée étant dans un premier de se concentrer sur la réponse OpenC2, nous pouvons prévoir certains éléments dans l’architecture d’origine que nous pourrons utiliser dans le cadre d’une automatisation des scénarios d’attaque en fonction de l’avancée du projet.  
  
### Scénario N°1  
  
Consiste à envoyer un mail vers le serveur de messagerie contenant une pièce jointe susceptible de contenir un virus. Pour se faire, on utilisera un fichier contenant une macro (inoffensive…), la réponse consistera à supprimer la pièce jointe du mail ou le mail lui-même.   
  
Les étapes de la réalisation du scénario sont les suivantes :
* Envois d’un mail depuis un web mail avec une pièce attachée,
* Détection ou simulation de détection en fonction de l’avancée du projet,
* Création d’une requête OpenC2 au niveau du OpenC2 Message Fabric, avec appel de l’Actuator correspondant à l’action sur le serveur mail en utilisant HTTPS pour la couche de transport.
  * On va trouver au niveau de l’Actuator Mail les commandes OpenC2 suivantes :
    * Action : 2 Locate, 3 Query, 7 Contain, 20 Delete, 
    * Target : 8 email_addr, 9 Features, 10 File, 13 ipv4_net, 15 ipv4_connection, 19 uri, Actuator : numéro et Nom, 
    * Arguments : 1 start_time, 2 stop_time, 3 duration, 4 response_request,
    * Arguments spécifiques à l’Actuator Mail : à définir
    * Traduction de la requête au niveau du proxy dans un script qui va établir une connexion SSH vers le serveur de messagerie, détruire le mail et renvoyer un code retour au OpenC2 Message Fabric de la bonne exécution de la commande (ou pas).

### Scénario N°2

Pourcentage de paquets erronés entre deux routeurs anormalement élevé qui peut laisser supposer une tentative de sniffing, la réponse consiste à forcer l’établissement d’un tunnel IPSEC entre les deux routeurs :
* Génération de paquets de requêtes ARP falsifiées vers le routeur 2 en utilisant un outil de type FRAMEIP par exemple,
* Détection ou simulation de détection en fonction de l’avancée du projet,
* Création d’une requête OpenC2 au niveau du OpenC2 Message Fabric, avec appel de l’actuator correspondant à l’action sur le routeur en utilisant HTTPS pour la couche de transport. 
  * On va trouver au niveau de l’Actuator Mail les commandes OpenC2 suivantes :
    * Action : 9 start, 10 stop, 15 set, 19 create, 20 delete
    * Target : 9 Features, 10 File, 13 ipv4_net, 15 ipv4_connection, 19 uri,
    * Arguments : 1 start_time, 2 stop_time, 3 duration, 4 response_request,
    * Arguments spécifiques à l’Actuator Routeur : à définir
* Traduction de la requête au niveau du proxy dans un script qui va établir une connexion SSH vers le routeur, forcer l’établissement d’un tunnel IPSEC entre les deux routeurs, renvoyer un code retour au OpenC2 Message Fabric de la bonne exécution de la commande.

### Scénario N°3
Suspicion d’altération d’une base de données, la réponse consiste à rétablir la base à partir de la dernière sauvegarde de celle-ci.
* Injection SQL à partir d’une page simple HTML qui simule un site web,
* Détection ou simulation de détection en fonction de l’avancée du projet,
* Création d’une requête OpenC2 au niveau du OpenC2 Message Fabric, avec appel de l’actuator correspondant à l’action sur la base de données en utilisant HTTPS pour la couche de transport. 
  * On va trouver au niveau de l’Actuator Database les commandes OpenC2 suivantes :
    * Action : 20 Delete, 23 Restore, 28 Copy,
    * Target : 9 Features, 10 File, 13 ipv4_net, 15 ipv4_connection, 19 uri
    * Arguments : 1 start_time, 2 stop_time, 3 duration, 4 response_request,
    * Arguments spécifiques à l’Actuator Database : à définir
* Traduction de la requête au niveau du proxy dans un script qui va établir une connexion SSH vers le serveur, rétablir la dernière version sauvegardée de la base de données avant l’injection sql, renvoyer un code retour au OpenC2 Message Fabric de la bonne exécution de la commande.

## Mise en place de l'architecture

Le script install.sh, génére l'ensemble de l'architecture, start.sh démarre les conteneurs, stop.sh les stop et clear.sh supprime l'ensemble des conteneurs.

Les configurations initiales des routeurs peuvent être modifiées via les fichiers config.init.

On peut accéder aux routeurs via la commande docker-compose exec -u vyos vyos1 /bin/vbash

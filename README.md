# openldap_ubuntu
implémentation d'un serveur LDAP sur une image docker alpine pour héberger un annuaire de machines

L'image Ubuntu sera créée à partir d'un Dockerfile auquel on aura ajouté les dépendances nécessaires à l'installation du serveur OpenLDAP.
Les fichiers de configuration du serveur LDAP devront mettre en evidence la base de donnees de stockage des machines. Un fichier ldif sera mis à disposition pour l'importation du parc de machines dans cette nouvelle base de donnees.

# Introduction à Docker (1)

# **Création de dockerfile pour la gestion de volume persistant**
On va créer un Dockerfile pour créer une image Linux Ubuntu permettant de stocker de **manière permanente** des données (ex: un fichier au format OpenLDAP .LDIF)
## **Exemple en ligne de commande**
1. On va tout d'abord créer le volume de données à l'aide de la commande dédiée *docker volume* comme ceci:

$ docker volume create test

1. Une fois le volume créé, on va le lier aux répertoires sources et destinations *test*

$ docker run -ti -v test:/test ubuntu:16.04 sh

La commande précédente créée un volume permanent “test” sur l'hôte (c.à.d le serveur) mais également dans le conteneur, au niveau de la racine, sous le répertoire test. Ce montage par défaut n'est pas satisfaisant lorsqu'on souhaite faire correspondre les données persistantes à une arborescence normalisée d'accueil de fichiers de configuration et de données d'un annuaire LDAP.
## **Point de montage du Volume de données**
Par défaut, le volume est monté par docker sous le répertoire */var/lib/docker/volumes/test*. Afin de permettre le montage du volume à l'emplacement prévu pour accueillir la base de donnée openLDAP, on va pouvoir spécifier à docker des options de montage. C'est ce que permet l'option -o comme sur la ligne de commande suivante:

$ docker run -ti -v test:/test -o bind=o -o device=/mnt/openldapDB -o type=none ubuntu:16.04 sh
## **Création du fichier Dockerfile normalisé**
L'édition d'un fichier dockerfile (nommé **Dockerfile**) suit une syntaxe normalisée avec différents champs comme ceci:

FROM pypi/python-ldap

RUN apt-get update

RUN apt-get install python-pip -y 

RUN python -m pip install –upgrade pip

CMD [“/bin/bash”]
## **Fabrication (build) du conteneur**
Ici, on va utiliser la commande *docker build* avec l'option -t pour générer une image à partir du fichier Dockerfile défini dans le paragraphe précédent. La commande à entrer est la suivante:

$ docker build -t ldapbd:0.1 .

Le point “.” précédent signifie que le fichier Dockerfile doit être présent dans le répertoire courant.

Si l'exécution se déroule correctement, on obtient en sortie :

Sending build context to Docker daemon 2.048kB

Step 1/5 : FROM pypi/python-ldap
—> 82f3656d7117
Step 2/5 : RUN apt-get update
—> Using cache
—> a9306ba3e646
Step 3/5 : RUN apt-get install python-pip -y
—> Using cache
—> 2cf7f355e0bc
Step 4/5 : RUN python -m pip install –upgrade pip
—> Using cache
—> 91af48b8aa95
Step 5/5 : CMD [“/bin/bash”]
—> Using cache
—> c9b645e1e200
Successfully built c9b645e1e200

Successfully tagged ldapdb:0.1
## **Vérification de l'image créée**
Afin de vérifier que l'image correspondant au conteneur décrit ait bien été labellisée avec le tag choisi (0.1), on exécute la commande suivante :

$ docker images ls –all

REPOSITORY TAG IMAGE ID CREATED SIZE

ldapdb 0.1 c9b645e1e200 7 minutes ago 753MB
## **Lancement du conteneur avec le volume créé**
On va pouvoir à présent lancer notre instance de PythonLDAP avec le volume de données créé au début. On lance pour ce faire la commande suivante:

$ sudo docker run -ti -v test:/test ldapdb:0.1

Voici le résultat final:

root@fb62fb6405bc:/# cd test

root@fb62fb6405bc:/test# 


# OpenLDAP Osixia (volumes LDAP) (2)

## **projet Docker “"OpenLDAP Osixia”**
On va ici utiliser créer conteneur docker avec une image Ubuntu destinée à recevoir les fichiers de configurations d'openLDAP. Il est nécessaire pour cela de créer les deux répertoires suivants : 

- /var/lib/ldap : répertoire système pour accueillir des librairies (exécutables) spécifiques (ex: \_*db.004, \_*db.001) et la base de donnée LDAP au format binaire (objectClass.bdb)
- /etc/ldap/slapd.d : répertoire destiné à accueillir les fichiers texte de configuration slapd.conf et schema.conf
### **Création du fichier Dockerfile**
Il faut tout d'abord indiquer dans le fichier DockerFile l'origine de l'image récupérée dans la base de conteneurs externes, grâce à l'instruction FROM comme ceci :

FROM ubuntu:latest

Ensuite, on va créer les deux répertoires indiqués précédemment pour accueillir les fichiers de configuration d'OpenLDAP à l'aide des instructions RUN comme ceci:

RUN mkdir -p /var/lib/ldap

RUN mkdir -p /etc/ldap/slapd.d

Le fichier Dockerfile complet est le suivant:

FROM ubuntu:latest

RUN apt-get update

RUN apt-get install python3-pip -y 

RUN python3 -m pip install –upgrade pip

**RUN mkdir -p /var/lib/ldap**

**RUN mkdir -p /etc/ldap/slapd.d**

CMD [“/bin/bash”]

Grâce à ce fichier Dockerfile, on peut créer notre conteneur docker nommé ici ldapDB (auquel on associe un “tag” de version 0.1) à l'aide de la commande suivante :

$ docker build -t ldapdb:0.1 .

### **Montage des deux volumes de données**
Il faut ensuite lier les répertoires créés sur le conteneur avec les répertoires de la machine hôte. On peut utiliser la commande suivante à présent que le conteneur docker a été créé.

$ docker run -ti -v /data/slapd/database:/var/lib/ldap -v /data/slapd/config:/etc/ldap/slapd.d ldapdb:0.1

Il reste à identifier le répertoire où sera stocké la base de donnée LDAP à proprement dite, en dehors des fichiers de configuration…

### **Utilisation d'un conteneur OpenLDAP (avec montage de la base de donnée persistante)**
On va ici utiliser un conteneur déjà développé afin d'*hériter de l'ensemble des fichiers de configurations nécessaire* pour exécuter un annuaire LDAP ayant exposé les ports externes 389 et 686. On récupère ce conteneur à l'aide de la commande suivante, après avoir vérifier la création préalable des répertoires locaux **/data/slapd/database** et **/data/slapd/config**
### **Utilisation du Makefile Osixia**
Le code permettant de créer le conteneur OpenLDAp est disponible sur Github (osixia/docker-openldap), il nous faut le cloner puis lancer le makefile comme ceci :

$ git clone –recursive git://github.com/osixia/docker-openldap

$ sudo make

La commande précédente va lancer la construction (build) du conteneur à l'aide de la commande docker suivante :

docker build -t osixia/openldap:1.5.0 –rm image

Ce qui va permettre d'obtenir localement le conteneur OpenLdap ayant le tag “1.5.0”, comme le montre le résultat suivant :

Successfully built 8317d0b76fdc

Successfully tagged osixia/openldap:1.5.0

# Création d'image Ubuntu avec Volumes montés contenant la B.D.D et les fichiers de config OpenLDAP

On va repartir ici de notre image Ubuntu créée à partir du fichier Dockerfile défini précédemment (cf paragraphe (2)).
L'idée est de "peupler" les répertoires indispensables à OpenLDAP, c.à.d le répertoire contenant la base de donnée et celui contenant le ou les fichiers de configuration. 

## Création des répertoires de stockage locaux

Si ce n'est pas déjà fait, on créé ces deux répertoires ainsi :

> $ sudo mkdir -p /data/slapd/database
> 
> $ sudo mkdir -p /data/slapd/config

On vérifie que ces répertoires sont vides, sinon on peut se référer au lien suivant:
https://github.com/osixia/docker-openldap/blob/master/image/service/slapd/install.sh 

## Copie des fichiers de config et de données

Il y a deux options pour initialiser le contexte d'exécution du conteneur de test. Soit on récupère les fichiers "officiels" provenant du site Github (Osixia/open-ldap) et on les copie manuellement dans les répertoires locaux dédiés "OpenLDAP", soit on utilise la commande COPY à l'intérieur du Dockerfile pour "peupler" les répertoires "OpenLDAP" dans le conteneur de test. Attention, la dernière option n'assure pas une recopie vers les répertoires locaux dédiés à la sauvegarde si le montage des volumes n'est pas fait correctement !

### Décompression des fichiers de configuration et de données pour alimenter les Volumes locaux

On va d'abord récupérer les fichiers nécessaires sur le présent dépôt, dans le fichier nommé data.zip:

> $ gunzip data.zip

On vérifie enfin que tous les fichiers sont présents :

> $ ls -l ./data/slapd/config && ls -l ./data/slapd/database

### Transfert des fichiers de config et de données à partir du Dockerfile

On peut utiliser la commande COPY dans le Dockerfile pour créer un conteneur qui contiendra déjà les fichiers de configuration et de données initiales OpenLDAP. Il faudra donc utiliser les VOLUMES en ligne de commande d'exécution du conteneur pour qu'ils soient montés localement sur la machine hôte et de manière persistante. 
 


# Conclusion (provisoire)

Afin d'enregistrer de manière persistante, c'est à dire même après arrêt ou suppression du conteneur Osixia, il faut impérativement et à minima appeler la fonction d'exécution du conteneur Osixia avec le volume où est stockée la base de donnée au format .bdb, c'est à dire dans le répertoire /etc/ldap/slapd.d du conteneur.  
 




mots-clés: #openldap, #sambaSID, #ubuntu-virt, #qemu-system-x86_64


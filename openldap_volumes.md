# **projet Docker “"OpenLDAP Osixia”**
On va ici utiliser créer conteneur docker avec une image Ubuntu destinée à recevoir les fichiers de configurations d'openLDAP. Il est nécessaire pour cela de créer les deux répertoires suivants : 

- /var/lib/ldap : répertoire système pour accueillir des librairies (exécutables) spécifiques (ex: \_*db.004, \_*db.001) et la base de donnée LDAP au format binaire (objectClass.bdb)
- /etc/ldap/slapd.d : répertoire destiné à accueillir le fichier texte de configuration slapd.conf
## **Création du fichier Dockerfile**
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
## **Montage des deux volumes de données**
Il faut ensuite lier les répertoires créés sur le conteneur avec les répertoires de la machine hôte. On peut utiliser la commande suivante à présent que le conteneur docker a été créé.

$ docker run -ti -v /data/slapd/database:/var/lib/ldap -v /data/slapd/config:/etc/ldap/slapd.d ldapdb:0.1

Il reste à identifier le répertoire où sera stocké la base de donnée LDAP à proprement dite, en dehors des fichiers de configuration…
## **Utilisation d'un conteneur OpenLDAP (avec montage de la base de donnée persistante)**
On va ici utiliser un conteneur déjà développé afin d'*hériter de l'ensemble des fichiers de configurations nécessaire* pour exécuter un annuaire LDAP ayant exposé les ports externes 389 et 686. On récupère ce conteneur à l'aide de la commande suivante, après avoir vérifier la création préalable des répertoires locaux **/data/slapd/database** et **/data/slapd/config**
## **Utilisation du Makefile Osixia**
Le code permettant de créer le conteneur OpenLDAp est disponible sur Github (osixia/docker-openldap), il nous faut le cloner puis lancer le makefile comme ceci :

$ git clone –recursive git://github.com/osixia/docker-openldap

$ sudo make

La commande précédente va lancer la construction (build) du conteneur à l'aide de la commande docker suivante :

docker build -t osixia/openldap:1.5.0 –rm image

Ce qui va permettre d'obtenir localement le conteneur OpenLdap ayant le tag “1.5.0”, comme le montre le résultat suivant :

Successfully built 8317d0b76fdc

Successfully tagged osixia/openldap:1.5.0

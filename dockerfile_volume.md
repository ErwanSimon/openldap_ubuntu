# **Création de dockerfile pour la gestion de volume persistant**
On va créer un Dockerfile pour créer une image Linux Alpine permettant de stocker de **manière permanente** des données (ex: un fichier au format OpenLDAP .LDIF)
## **Exemple en ligne de commande**
1. On va tout d'abord créer le volume de données à l'aide de la commande dédiée *docker volume* comme ceci:

$ docker volume create test

1. Une fois le volume créé, on va le lier aux répertoires sources et destinations *test*

$ docker run -ti -v test:/test alpine:3.4 sh

La commande précédente créée un volume permanent “test” sur l'hôte (c.à.d le serveur) mais également dans le conteneur, au niveau de la racine, sous le répertoire test. Ce montage par défaut n'est pas satisfaisant lorsqu'on souhaite faire correspondre les données persistantes à une arborescence normalisée d'accueil de fichiers de configuration et de données d'un annuaire LDAP.
## **Point de montage du Volume de données**
Par défaut, le volume est monté par docker sous le répertoire */var/lib/docker/volumes/test*. Afin de permettre le montage du volume à l'emplacement prévu pour accueillir la base de donnée openLDAP, on va pouvoir spécifier à docker des options de montage. C'est ce que permet l'option -o comme sur la ligne de commande suivante:

$ docker run -ti -v test:/test -o bind=o -o device=/mnt/openldapDB -o type=none alpine:3.4 sh
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

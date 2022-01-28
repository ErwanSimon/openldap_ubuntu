# Création d'image Ubuntu avec Volumes montés contenant la B.D.D et les fichiers de config OpenLDAP

On va repartir ici de notre image Ubuntu créée à partir du fichier Dockerfile défini dans le document http://arn16s.ovh/dockerfile_volume.html
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

### Transfert des fichiers de config et de données via les Volumes locaux

On va d'abord récupérer les fichiers nécessaires sur Github en clonant le dépôt lointain à l'aide d ela commande suivante:

> $ git clone --recursive git@github.com:osixia/docker-openldap.git

On se place ensuite dans le répertoire docker-openldap/test :

> $ cd docker-openldap/test

puis on copie le contenu des répertoires "config" et "database" vers la destination de sauvegarde locale :

> $ cp -r config/* /data/slapd/config 
> $ cp -r database/* /data/slapd/database

On vérifie enfin que les fichiers ont bien été transférés vers leurs destinations :

> $ ls -l /data/slapd/config && ls -l /data/slapd/database
> 
### Transfert des fichiers de config et de données à partir du Dockerfile

On peut utiliser la commande COPY dans le Dockerfile pour créer un conteneur qui contiendra déjà les fichiers de configuration et de données initiales OpenLDAP. Il faudra donc utiliser les VOLUMES en ligne de commande d'exécution du conteneur pour qu'ils soient montés localement sur la machine hôte et de manière persistante. 

# Conclusion

Afin d'enregistrer de manière persistante, c'est à dire même après arrêt ou suppression du conteneur Osixia, il faut impérativement et à minima appeler la fonction d'exécution du conteneur Osixia avec le volume où est stockée la base de donnée au format .bdb, c'est à dire dans le répertoire /etc/ldap/slapd.d du conteneur.  
 


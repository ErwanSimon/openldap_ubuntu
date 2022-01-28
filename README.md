# openldap_ubuntu
implémentation d'un serveur LDAP sur une image docker alpine pour héberger un annuaire de machines

L'image Ubuntu sera créée à partir d'un Dockerfile auquel on aura ajouté les dépendances nécessaires à l'installation du serveur OpenLDAP.
Les fichiers de configuration du serveur LDAP devront mettre en evidence la base de donnees de stockage des machines. Un fichier ldif sera mis à disposition pour l'importation du parc de machines dans cette nouvelle base de donnees.

# support infrastructure

## Docker (1)

http://arn16s.ovh/dockerfile_volume.html

## OpenLDAP Osixia (volumes LDAP) (2)

http://arn16s.ovh/openldap_volumes.html

## Création image Ubuntu avec volumes montés contenant la B.D.D LDAP et les fichiers de config LDAP
http://arn16s.ovh/ubuntu_openLDAP.html


mots-clés: #openldap, #sambaSID, #ubuntu-virt, #qemu-system-x86_64


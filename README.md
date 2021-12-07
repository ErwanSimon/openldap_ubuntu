# openldap_alpine
implémentation d'un serveur LDAP sur une image docker alpine pour héberger un annuaire de machines

L'image Alpine sera créée à partir d'un Dockerfile auquel on aura ajouté les dépendances nécessaires à l'installation du serveur OpenLDAP.
Les fichiers de configuration du serveur LDAP devront mettre en evidence la base de donnees de stockage des machines. Un fichier ldif sera mis à disposition pour l'importation du parc de machines dans cette nouvelle base de donnees.

mots-clés: #openldap, #sambaSID, #alpine-virt, #qemu-system-x86_64


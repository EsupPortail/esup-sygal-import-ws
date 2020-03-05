Installation du web service `sygal-import-ws`
=============================================


Applicatif
----------

### Première obtention des sources et installation du serveur 

*NB: la procédure proposée ici part d'un serveur *Debian Stretch* tout nu et couvre l'installation de tous les packages 
requis.* Si ce n'était pas le cas, merci de le signaler.

En `root` sur votre serveur, pour obtenir les sources du WS, lancez l'une des commandes suivantes en fonction 
du site sur lequel vous lisez la présente page :
```bash
# Si vous êtes sur git.unicaen.fr :
git clone https://git.unicaen.fr/open-source/sygal-import-ws.git /app

# Si vous êtes sur github.com :
git clone https://github.com/EsupPortail/sygal-import-ws.git /app
```

*NB: merci de respecter dans un premier temps le choix de `/app` comme répertoire d'installation. 
Libre à vous une fois que tout fonctionne de changer d'emplacement et de modifier en conséquence les configs
nécessaires.*

### Configuration du serveur

Ensuite, placez-vous dans le répertoire des sources et jetez un oeil au script `Dockerfile.sh`.
Ce script est en quelque sorte l'équivalent du `Dockerfile` du WS traduit en bash. 
(Vous y verrez que le dépôt git d'une image Docker Unicaen est cloné pour lancer 
son script `Dockerfile.sh` qui est lui aussi l'équivalent du `Dockerfile` de l'image 
traduit en bash.)

Lancez le script `Dockerfile.sh` :
```bash
cd /app
bash Dockerfile.sh 7.0
```

Ensuite, vérifiez et ajustez si besoin sur votre serveur les fichiers de configs suivants,
créés par le script `Dockerfile.sh` :
- ${APACHE_CONF_DIR}/ports.conf
- ${APACHE_CONF_DIR}/sites-available/app.conf
- ${APACHE_CONF_DIR}/sites-available/app-ssl.conf  
- ${PHP_CONF_DIR}/fpm/pool.d/app.conf
- ${PHP_CONF_DIR}/fpm/conf.d/90-app.ini

NB: Vérifiez dans le script `Dockerfile.sh` que vous venez de lancer mais normalement 
`APACHE_CONF_DIR=/etc/apache2` et `PHP_CONF_DIR=/etc/php/7.0`.


### Installation d'une version précise du WS

Normalement, vous ne devez installer que les versions officielles du WS, c'est à dire les versions taguées, du genre `1.2.1`
par exemple.

Placez-vous dans le répertoire des sources du web service puis lancez les commandes git suivantes pour obtenir la liste des
versions officielles du WS :
```bash
git fetch && git fetch --tags && git tag
```

Si la version la plus récente est par exemple la `1.2.1`, utilisez les commandes suivantes pour "installer" cette version 
sur votre serveur :
```bash
git checkout --force 1.2.1 && bash install.sh
```


### Fichier "users.htpasswd"

Ce fichier contient les utilisateurs/mot de passe autorisés à interroger le WS au regard de l'authentification HTTP Basic.

S'il s'agit d'une simple mise à jour du WS, vous avez déjà fait la manip, inutile de lire ce paragraphe.

S'il s'agit de la première installation du WS, placez-vous dans le répertoire [`config`](config) des sources et lancez la 
commande suivante pour créer le fichier "users.htpasswd" contenant un utilisateur `sygal-app` dont le mot de passe 
vous sera demandé :
```bash
htpasswd -c users.htpasswd sygal-app
```

Si vous manquez d'idée pour le mot de passe, utilsez la commande suivante :
```bash
pwgen 16 1 --symbols --secure
```

### Configuration du WS

S'il s'agit d'une mise à jour du WS, vous avez déjà fait la manip, inutile de lire ce paragraphe.
Reportez-vous aux "release notes" de la version choisie situées dans `doc/release-notes`.

S'il s'agit de la première installation du WS, 2 fichiers situés dans le répertoire [`config/autoload`](config/autoload) 
doivent être complétés puis renommés :

  - **local.php.dist** : qui est notamment utilisé pour l'authentification.
    - clé `htpasswd` qui désigne le chemin du fichier "users.htpasswd" évoqué plus haut
  - **database.local.php.dist** : qui est utilisé pour la connection à la BDD.
    - clés `host`, `dbname`, `port`, `user`, `password` : les infos d'accès à la BDD.
 
Une fois ces fichiers complétés, supprimez l'extension `.dist`, ex :
```bash
cp -n local.php.dist          local.php 
cp -n database.local.php.dist database.local.php
```

### Configuration PHP pour le WS

Si vous êtes sur un serveur de PROD, corrigez les lignes suivantes du fichier de config PHP 
`/etc/php/7.0/fpm/conf.d/90-app.ini` :

    display_errors = Off
    ...
    error_reporting = 0
    ...
    opcache.enable = 1
    ...
    xdebug.enable = 0

### Interface d'admin Apigility

Cette interface de modification du WS est réservée aux développeurs et est **INTERDITE EN PRODUCTION**.
Assurez-vous de bien désactiver le mode développement :
```bash
composer development-disable
```



Base de données
---------------

Le WS interroge des tables que vous allez devoir créer dans la base de données de votre logiciel de scolarité (Apogée ou Physalis), 
ou autre part si c'est possible, à vous de voir.

Le répertoire [`dist/SQL`](dist/SQL) contient ceci :
- Un script `01-tables.sql` pour créer les tables qui contiendront les données retournées par le web service.
- Un dossier `apogee` concernant les établissements ayant Apogée.
- Un dossier `physalis` concernant les établissements ayant Physalis (Cocktail).

Quelque soit votre logiciel de scolarité, utilisez le script `01-tables.sql` pour créer les tables qui contiendront 
bientôt les données retournées par le web service.

Prenons maintenant l'exemple d'Apogée. Le répertoire `apogee` contient 2 scripts SQL : 
- `01-vues-apogee-communes.sql` : script de création des vues communes à tous les établissements ayant ce logiciel 
  de scolarité, ne nécessitant aucune personnalisation.
- `02-vues-apogee-etab.sql` : script de création des vues contenant des données propres à votre établissement 
  en particulier, nécessitant donc une personnalisation de votre part.



Réseau
------

Vous devez autoriser le serveur sur lequel est installé le WS à être interrogé par le serveur sur lequel est installé 
SyGAL. 

Il est conseillé de restreindre cette autorisation à cette seule adresse IP d'origine.



Test
----

Reportez-vous au [README.md](README.md) pour tester l'appel du WS en ligne de commande depuis le serveur
sur lequel est installé SyGAL.

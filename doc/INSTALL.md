Installation du web service `sygal-import-ws`
=============================================


## Installation du serveur Debian Bullseye

Concernant l'installation du serveur d'application, n'ayant pas à Caen les compétences
en déploiement Docker (autres que pour le développement), nous documenterons une installation manuelle sur
un serveur *entièrement dédié à l'application*.
Si vous voulez déployer l'application avec Docker, faites-le à partir du `Dockerfile` présent et n'hésitez pas à
contribuer en améliorant cette doc d'install !

**NB :** La procédure proposée ici part d'un serveur *Debian Bullseye* tout nu. Elle couvre normalement l'installation
de tous les packages requis, mais si ce n'était pas le cas merci de contribuer en le signalant.


### Case départ : obtention des sources de l'application

En `root` sur votre serveur, obtenez les sources en lançant l'une des commandes suivantes en fonction
du site sur lequel vous lisez la présente doc :
```bash
# Si vous êtes sur git.unicaen.fr :
git clone https://git.unicaen.fr/open-source/sygal-import-ws.git /app

# Si vous êtes sur github.com :
git clone https://github.com/EsupPortail/sygal-import-ws.git /app
```

*NB : merci de respecter dans un premier temps le choix de `/app` comme répertoire d'installation.
Si vous êtes à l'aise, libre à vous une fois que tout fonctionne de changer d'emplacement et de modifier en conséquence
les configs nécessaires sur le serveur.*

### Configuration du serveur

- Vous trouverez dans le répertoire des sources récupérées à l'instant un script `Dockerfile.sh`,
  sorte de version sh du Dockerfile, contenant de quoi mettre à niveau et/ou installer les packages nécessaires.

- Plutôt que de le lancer d'un seul bloc, ouvrez-le dans un autre terminal pour le visualiser, ce qui vous permettra
  de copier-coller-lancer les commandes qu'il contient par petits groupes.

- Ensuite, vérifiez et ajustez si besoin sur votre serveur les fichiers de configs suivants,
créés par le script `Dockerfile.sh` :
- ${APACHE_CONF_DIR}/ports.conf
- ${APACHE_CONF_DIR}/sites-available/app.conf
- ${APACHE_CONF_DIR}/sites-available/app-ssl.conf  
- ${PHP_CONF_DIR}/fpm/pool.d/99-sygal.conf
- ${PHP_CONF_DIR}/fpm/conf.d/99-sygal.ini

NB: Vérifiez dans le script `Dockerfile.sh` que vous venez de lancer mais normalement 
`APACHE_CONF_DIR=/etc/apache2` et `PHP_CONF_DIR=/etc/php/${PHP_VERSION}`.

### Installation d'une version précise du WS

Normalement, vous ne devez installer que les versions officielles du WS, c'est à dire les versions taguées, du genre `3.0.0`
par exemple. Si vous partez de zéro, choisissez bien-sûr la version la plus récente !

Placez-vous dans le répertoire des sources du web service puis lancez les commandes git suivantes pour obtenir la liste des
versions officielles du WS :
```bash
git fetch && git fetch --tags && git tag
```

Si la version la plus récente est par exemple la `3.0.0`, utilisez les commandes suivantes pour "installer" cette version 
sur votre serveur :
```bash
git checkout --force 3.0.0 && bash install.sh
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

S'il s'agit de la première installation du WS, supprimez l'extension `.dist` des fichiers suivants situés dans le 
répertoire [`config/autoload`](config/autoload) :
  - [`local.php.dist`](config/autoload/local.php.dist)

Dans la suite, vous allez adapter le contenu de ces fichiers à votre situation.

#### Fichier `local.php`

- Vérifiez la valeur de la clé `htpasswd` qui désigne le chemin du fichier "users.htpasswd" évoqué plus haut.

- Renseignez les infos de connexion à la base de données (Apogée ou Physalis) :
```php
    'doctrine' => [
        'connection' => [
            'orm_default' => [
                'driverClass' => 'Doctrine\DBAL\Driver\OCI8\Driver',
                'params' => [
                    'host'     => 'XXXXX',
                    'dbname'   => 'XXXXX',
                    'port'     => 'XXXXX',
                    'user'     => 'XXXXX',
                    'password' => 'XXXXX',
                    'charset'  => 'AL32UTF8',
                ],
            ],
        ],
    ],
```


### Configuration PHP

Si vous êtes sur un serveur de PROD, corrigez les lignes suivantes du fichier de config PHP 
`/etc/php/${PHP_VERSION}/fpm/conf.d/99-sygal.ini` :
```
    display_errors = Off
    display_startup_errors = Off
    display_errors = Off
    ...
    error_reporting = 0
    ...
    opcache.enable = 1
    ...
    xdebug.mode = off
```


## Script d'install des dépendances et d'init de l'application

Lancez le script suivant :

```bash
bash ./install.sh
```


Base de données
---------------

Reportez-vous au [README consacré à la base de données](database/README.md).


Programmation des tâches périodiques
------------------------------------

Vous devez CRONer l'exécution de la commande permettant de mettre à jour le contenu des tables de la bdd dans lesquelles 
puisent le WS. Normalement, vous avez lancé cette commande une première fois en suivant la doc d'install de la bdd.

- Créez sur le serveur du web service le fichier de config CRON `/etc/cron.d/sygal-import-ws-cron`
  identique au fichier [cron/sygal-import-ws-cron](cron/sygal-import-ws-cron) fourni.

- Adaptez si nécessaire son contenu :
  - `APP_DIR` : chemin vers le répertoire d'installation du web service.
  - `LOG_FILE` : chemin vers le fichier de log.
  - périodicité d'exécution du script, ex : "lun-ven à 6:25, 6:55, 7:25, ..., 18:25, 18:55".


Réseau
------

Vous devez autoriser le serveur sur lequel est installé le WS à être interrogé par le serveur sur lequel est installé 
ESUP-SyGAL.
Il est conseillé de restreindre cette autorisation à cette seule adresse IP d'origine.


Test
----

Reportez-vous au [README.md](../README.md) pour tester l'appel du WS en ligne de commande depuis le serveur
sur lequel est installé ESUP-SyGAL.

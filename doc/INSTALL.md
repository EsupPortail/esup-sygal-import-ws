Installation du web service `sygal-import-ws`
=============================================


Base de données
---------------

Reportez-vous au [README consacré à la base de données](database/README.md).



Installation du serveur d'application
-------------------------------------

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


### Script `Dockerfile.sh`

- À la racine des sources d'ESUP-SyGAL se trouve un répertoire `docker/` qui contient des fichiers de config
  PHP et Apache par défaut et de quoi installer le driver PHP OCI8 (requis pour requêter une BDD Oracle).
  Copiez ce répertoire `docker/` dans le répertoire `/tmp` du serveur d'application, exemple :
```bash
cp -r ./docker /tmp/
```

- À la racine des sources d'ESUP-SyGAL vous trouverez aussi un script `Dockerfile.sh`, sorte de version bash partielle 
  du Dockerfile, contenant de quoi installer les packages nécessaires.

- **Conseil** : évitez de lancer ce script d'un seul bloc, ouvrez-le dans un autre terminal pour l'avoir sous la main.

- Lisez et vérifiez les pré-requis mentionnés dans les commentaires en entête du script.

- Copiez-collez-lancez les commandes qu'il contient par petits groupes.



Configuration du serveur
------------------------

### Apache

- Vérifiez et ajustez si besoin sur votre serveur les fichiers de configs suivants,
  créés par le script `Dockerfile.sh` (vérifiez dans le script mais normalement
  `APACHE_CONF_DIR=/etc/apache2`) :
  - ${APACHE_CONF_DIR}/ports.conf
  - ${APACHE_CONF_DIR}/sites-available/app.conf
  - ${APACHE_CONF_DIR}/sites-available/app-ssl.conf

### PHP

- Vérifiez et ajustez si besoin sur votre serveur les fichiers de configs suivants,
  créés par le script `Dockerfile.sh` (vérifiez dans le script mais normalement
  `PHP_CONF_DIR=/etc/php/${PHP_VERSION}`) :
  - ${PHP_CONF_DIR}/fpm/pool.d/99-sygal-import-ws.conf
  - ${PHP_CONF_DIR}/fpm/conf.d/99-sygal-import-ws.ini

- Si vous êtes sur un serveur de PROD, corrigez les lignes suivantes du fichier de config 
`/etc/php/${PHP_VERSION}/fpm/conf.d/99-sygal-import-ws.ini` :
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

- Ajoutez ceci à la fin du fichier de config `/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf` et 
  adaptez les valeurs selon que vous souhaitez activer les logs PHP-FPM ou non :
```conf
catch_workers_output = yes
php_flag[display_errors] = on
php_admin_value[error_log] = /var/log/php-fpm.log
php_admin_flag[log_errors] = on
```



Configuration du web service
----------------------------

### Fichier `config/users.htpasswd`

Ce fichier doit contenir les comptes utilisateurs / mots de passe autorisés à interroger le WS au regard de 
l'authentification HTTP Basic.

Placez-vous dans le répertoire [`config`](config) des sources et lancez la
commande suivante pour créer le fichier `users.htpasswd` contenant un utilisateur `sygal-app` dont le mot de passe
vous sera demandé :
```bash
htpasswd -c users.htpasswd sygal-app
```

Si vous manquez d'idée pour le mot de passe, utilsez la commande suivante :
```bash
pwgen 16 1 --symbols --secure
```

### Fichier `config/autoload/{dev|test|prod}.local.php`

- Supprimez l'extension `.dist` du fichier [`config/autoload/local.php.dist`](../config/autoload/local.php.dist),
  et préfixez-le par `prod.`, `test.` ou `dev.` pour bien signifier l'environnement de fonctionnement
  (*n'utilisez pas le préfixe `development.` qui est réservé*), exemple :
```bash
cp local.php.dist prod.local.php
```

- Activez si besoin les logs des requêtes HTTP reçues et des temps de traitements (SQL, génération HAL) :
```php
    'logging' => [
        'enabled' => false, // mettre à `true` pour activer les logs
        'params' => [
            'file_path' => '/tmp/api-logging.log',
        ],
    ],
```

### Fichier `config/autoload/{dev|test|prod}.secret.local.php`

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

- Vérifiez la valeur de la clé `htpasswd` qui désigne le chemin du fichier `config/users.htpasswd` évoqué plus haut :
```php
    'zf-mvc-auth' => [
        'authentication' => [
            'adapters' => [
                'basic' => [
                    'options' => [
                        'htpasswd' => __DIR__ . '/../users.htpasswd',
                    ],
                ],
            ],
        ],
    ],
```



Script `install.sh`
-------------------

Le script `install.sh` situé à la racine des sources du web service doit être lancé à chaque fois
qu'une nouvelle version du ws est téléchargée/installée :

```bash
bash ./install.sh
```



Programmation des tâches périodiques
------------------------------------

Vous devez CRONer l'exécution de la commande permettant de mettre à jour le contenu des tables de la bdd dans lesquelles 
puisent le WS. Normalement, vous avez lancé cette commande une première fois en suivant la doc d'install de la bdd.

- Créez sur le serveur d'application le fichier de config CRON `/etc/cron.d/sygal-import-ws`
  identique au fichier [doc/cron/sygal-import-ws](cron/sygal-import-ws) fourni.

- Adaptez obligatoirement les éléments suivants :
  - variable `APP_DIR` : chemin vers le répertoire d'installation du web service.

- Adaptez éventuellement :
  - variable `LOG_FILE` : chemin vers le fichier de log.
  - périodicité d'exécution du script.



Réseau
------

Vous devez autoriser le serveur sur lequel est installé le WS à être interrogé par le serveur sur lequel est installé 
ESUP-SyGAL.
Il est conseillé de restreindre cette autorisation à cette seule adresse IP d'origine.



Test
----

Reportez-vous au [README.md](../README.md) pour tester l'appel du WS en ligne de commande depuis le serveur
sur lequel est installé ESUP-SyGAL.

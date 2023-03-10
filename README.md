sygal-import-ws
===============

Que fait *sygal-import-ws* ?
----------------------------

*sygal-import-ws* est une API REST qui retourne les données présentes dans des tables `SyGAL_*` 
d'Apogée ou de Physalis via des requêtes GET.

Docker
------

- Obtention de l'image de base Unicaen (construite) à jour

```bash
PHP_VERSION=7.4 ;
docker pull registre.unicaen.fr:5000/unicaen-dev-php${PHP_VERSION}-apache
```

- Construction de l'image du web service

```bash
docker build \
--build-arg HTTP_PROXY \
--build-arg HTTPS_PROXY \
--build-arg NO_PROXY \
--build-arg PHP_VERSION \
-t sygal-import-ws-image-php${PHP_VERSION} .
```

- Lancement du web service

```bash
docker-compose up
```


Installation
------------

Cf. [`INSTALL.md`](INSTALL.md).


Lancement du web service *pour le dévelopement*
-----------------------------------------------

Se placer à la racine des sources du ws pour lancer la commande suivante :

```bash
docker-compose up --build
```

Vérifier que le container `sygal-import-ws-container` figure bien dans la liste des containers
lancés listés par la commande suivante (cf. colonne `NAMES`) :

```bash
docker ps
```

Le port sur lequel écoute le ws est indiqué dans la colonne `PORTS`. 
Par exemple, `0.0.0.0:443->8443/tcp` indique que le ws est accessible sur la machine hôte 
à l'adresse `https://localhost:8443`.


Les services fournis
--------------------
 
Chaque vue en base de données peut être interrogée via un service dédié :
  - `/structure` 
  - `/etablissement` 
  - `/ecole-doctorale` 
  - `/unite-recherche` 
  - `/individu` 
  - `/doctorant` 
  - `/these` 
  - `/these-annee-univ` 
  - `/role` 
  - `/acteur` 
  - `/origine-financement` 
  - `/financement` 
  - `/titre-acces`
  - `/variable`

Il y a aussi un service `/version` () permettant de connaître le numéro de version du web service (ex : '2.3.0'). 


Versionning de l'API
--------------------

L'API existe en plusieurs versions coexistantes, veillez à spécifier la version correcte dans l'URL.
Prenez toujours la version la plus récente. 

Exemple de requête pour la version 2 : `https://localhost:8443/v2/version/latest`.


Interrogation avec `curl`
-------------------------

Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v2/variable
```

Remplacer `xxxx` par le token généré grâce à la commande suivante 
(le mot de passe est celui choisi lors de la commande `htpasswd -c users.htpasswd sygal-app`) :
```bash
echo -n 'sygal-app:motdepasse' | base64
```

Il se peut que vous soyez obligé de contourner le proxy en faisant ceci :
```bash
export no_proxy=localhost
```

L'interrogation d'un service sans paramètre va retourner l'intégralité des données concernées.

Afin d'obtenir les informations spécifiques à une donnée, il est possible d'ajouter son identifiant, exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v2/variable/ETB_LIB_NOM_RESP
```

Pour mettre en forme le JSON retourné et faciliter la lecture, une solution est d'utiliser `python -m json.tool`:
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v2/variable | python -m json.tool
```


Services acceptant un paramètre
-------------------------------

Aucun service n'accepte de paramètre GET, sauf ceux qui suivent.

### `/acteur`

Ce service accepte un paramètre supplémentaire : un identifiant de thèse (source code) peut être spécifié pour obtenir 
les acteurs de cette seule thèse. 
Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxxx" https://localhost:8443/v2/acteur?these_id=13111
```

### `/doctorant`

Ce service accepte un paramètre supplémentaire : un identifiant de thèse (source code) peut être spécifié pour obtenir
le doctorant de cette thèse.
Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxxx" https://localhost:8443/v2/doctorant?these_id=13111
```


Ligne de commande
-----------------

La ligne de commande suivante permet de mettre à jour en base de données les tables `SYGAL_*` à partir des
vues `V_SYGAL_*` (ces tables sont les sources des données retournées par l'API) :

```bash
php public/index.php update-service-tables --verbose
```

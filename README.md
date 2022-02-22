sygal-import-ws
===============

Que fait *sygal-import-ws* ?
----------------------------

*sygal-import-ws* est un web service (une API REST) qui interroge les données présentes dans un SI (via des vues 
et des tables en base de données) et les met à disposition pour leur lecture via des requêtes GET.


Installation
------------

Cf. [`INSTALL.md`](INSTALL.md).


Lancement du web service *pour le dévelopement*
-----------------------------------------------

### Solution 1 : le serveur interne PHP
 
En phase de développement, la façon la plus simple consiste en l'utilisation 
du serveur interne de php :

 ```bash
php -S 0.0.0.0:8080 -ddisplay_errors=0 -t public public/index.php
 ```

### Solution 2 : Docker

Se placer à la racine des sources du ws pour lancer la commande suivante :

```bash
docker-compose up -d --build
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

Il y a aussi un service `/version` permettant de connaître le numéro de version du web service (ex : '1.3.7'). 


Versions
--------

L'API existe en plusieurs versions, veillez à spécifier la version correcte dans l'URL.
Exemple pour la version 1 : `https://localhost:8443/v1/variable`. 
Exemple pour la version 2 : `https://localhost:8443/v2/variable`. 


Interrogation avec `curl`
-------------------------

Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v1/variable
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
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v1/variable/ETB_LIB_NOM_RESP
```

Pour mettre en forme le JSON retourné et faciliter la lecture, une solution est d'utiliser `python -m json.tool`:
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxx" https://localhost:8443/v1/variable | python -m json.tool
```


Services acceptant un paramètre
-------------------------------

Aucun service n'accepte de paramètre GET, sauf ceux qui suivent.

### `/acteur`

Ce service accepte un paramètre supplémentaire : un identifiant de thèse (source code) peut être spécifié pour obtenir 
les acteurs de cette seule thèse. 
Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxxx" https://localhost:8443/v1/acteur?these_id=13111
```

### `/doctorant`

Ce service accepte un paramètre supplémentaire : un identifiant de thèse (source code) peut être spécifié pour obtenir
le doctorant de cette thèse.
Exemple :
```bash
curl --insecure --header "Accept: application/json" --header "Authorization: Basic xxxxx" https://localhost:8443/v1/doctorant?these_id=13111
```


Ligne de commande
-----------------

La ligne de commande suivante permet de mettre à jour en base de données les tables `SYGAL_*` à partir des
vues `V_SYGAL_*` (ces tables sont les sources des données retournées par l'API) :

```bash
php public/index.php update-service-tables --verbose
```

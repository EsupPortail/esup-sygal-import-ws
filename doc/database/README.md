Base de données pour `sygal-import-ws`
======================================

Création des tables et vues sources
-----------------------------------

Le WS puise dans des tables `SYGAL_*` mises à jour périodiquement à partir de vues `V_SYGAL_*`. Vous devez créer
ces tables et vues dans la base de données de votre logiciel de scolarité (Apogée ou Physalis) ou autre part si c'est
possible, à vous de voir.

Le répertoire [`SQL`](SQL) contient ceci :
  - Un script `01-tables.sql` pour créer les tables qui contiendront les données retournées par le web service.
  - Un dossier `apogee` concernant les établissements ayant Apogée.
  - Un dossier `physalis` concernant les établissements ayant Physalis (Cocktail).

Quelque soit votre logiciel de scolarité, utilisez le script `01-tables.sql` pour créer les tables `SYGAL_*`.

Prenons maintenant l'exemple d'Apogée. Le répertoire `apogee` contient 2 scripts SQL :
- `01-vues-apogee-communes.sql` : script de création des vues `V_SYGAL_*` communes à tous les établissements
  ayant ce logiciel de scolarité, ne nécessitant aucune personnalisation.
- `02-vues-apogee-etab.sql` : script de création des vues `V_SYGAL_*` contenant des données propres à votre
  établissement en particulier, nécessitant donc une personnalisation de votre part.

Prenez connaissance de ces scripts, personnalisez ceux qui le requièrent puis lancez-les pour créer les
tables/vues nécesssaires.


Mise à jour du contenu des tables sources à partir des vues
-----------------------------------------------------------

Une ligne de commande permet de réaliser la mise à jour du contenu des tables sources `SYGAL_*` à partir des vues
`V_SYGAL_*`.

- Adaptez `APP_DIR` puis testez la commande ci-dessous (cela peut prendre 1-2 minutes) :
```bash
APP_DIR=/app
/usr/bin/php ${APP_DIR}/public/index.php update-service-tables
```

- Vérifiez ensuite que le contenu de la table `SYGAL_INDIVIDU` (par exemple) a bien été mis à jour à l'instant
  grâce à la colonne `inserted_on`.

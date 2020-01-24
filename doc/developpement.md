Développement du web service sygal-import-ws
============================================

Ajouter un champ dans un service
--------------------------------

**NB: il existe le pendant de cette documentation côté application interrogeant le présent web service.**

Exemple : ajouter l'INE des doctorants.

### Marche à suivre

- Dans la base de données source (ex: Apogée) :

    - Modifier la vue `V_SYGAL_DOCTORANT` pour ajouter la nouvelle colonne.

    - Modifier la vue `SYGAL_DOCTORANT` pour ajouter la nouvelle colonne, exemple : 
    `alter table SYGAL_DOCTORANT add INE VARCHAR(20);`

- Dans les sources PHP :

    - Mettre à jour le mapping Doctorant dans le fichier  
      `module/ImportData/src/V1/Entity/Db/Mapping/ImportData.V1.Entity.Db.Doctorant.dcm.xml` 
      
    - Ajouter la nouvelle propriété `$ine` ainsi que son getter associé `getIne()` dans la classe d'entité   
      `module/ImportData/src/V1/Entity/Db/Doctorant.php`
       
      NB: pas besoin de setter puisqu'il s'agit d'une vue en base de données.

### Tests

- En ligne de commande :

    - Lancer si besoin le web service dans Docker :
      `docker-compose up sygal-import-ws`  
   
    - Lancer le script PHP de remplissage des tables `SYGAL_*` à partir des vues `V_SYGAL_*` :
      `docker-compose exec sygal-import-ws php public/index.php update-service-tables --services=these --verbose`
  
    - Vérifier que le nouveau champ figure dans la réponse du web service, ex :
    `curl --insecure --header "Accept: application/json" --header "Authorization: Basic c3lnYWwtYXBwOmF6ZXJ0eQ==" https://localhost:8443/doctorant`


Le reste du travail se fait côté application interrogeant le web service...

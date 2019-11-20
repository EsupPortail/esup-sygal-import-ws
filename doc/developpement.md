Développement du web service sygal-import-ws
============================================

Ajouter un champ dans un service
--------------------------------

**NB: il existe le pendant de cette documentation côté application interrogeant le présent web service.**

Exemple : ajouter l'INE des doctorants.

Marche à suivre :

- Dans la base de données :

    - Modifier dans la base de données source (ex: Apogée) la vue `SYGAL_DOCTORANT` pour ajouter la 
      colonne.

- Dans les sources PHP :

    - Mettre à jour le mapping Doctorant dans le fichier  
      `module/ImportData/src/V1/Entity/Db/Mapping/ImportData.V1.Entity.Db.Doctorant.dcm.xml` 
      
    - Mettre à jour l'entité Doctorant dans le fichier 
      `module/ImportData/src/V1/Entity/Db/Doctorant.php`
       
      NB: pas besoin d'accesseurs, les colonnes étant découvertes automatiquement
      via le mapping.

- Via l'interface graphique d'admin Apigility
    
    - Lancer le web service dans Docker :
      `docker-compose up sygal-import-ws`  
   
    - Passer en mode développement :
      `docker-compose exec sygal-import-ws vendor/bin/zf-development-mode enable`   
      
    - Ouvrir l'interface d'admin dans un navigateur :
      `https://localhost:8443`
      
      NB: le numéro de port dépend de la config `docker-compose.yml`.
      
    - Autoriser l'interface d'admin à écrire dans les fichiers de config
      du web service :
      `sudo chown -R www-data:ww-data module/ImportData/config`
   
    - Sélectionner le service "Doctorant" et aller dans l'onglet "Fields"
      pour ajouter le champ `ine`.
    
    - Rétablir les autorisations d'accès au fichiers :
      `sudo chown -R gauthierb:gauthierb module/ImportData/config`
      
    - Ne pas oublier de désactiver le mode développement :
      `docker-compose exec sygal-import-ws vendor/bin/zf-development-mode disable`

- En ligne de commande :
    
    - Vérifier que le nouveau champ figure dans la réponse du web service, ex :
    `curl --insecure --header "Accept: application/json" --header "Authorization: Basic c3lnYWwtYXBwOmF6ZXJ0eQ==" https://localhost:8443/doctorant`


Le reste du travail se fait côté application interrogeant le web service...

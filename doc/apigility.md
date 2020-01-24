Utiliser l'interface d'admin Apigility
======================================
    
Ouvrir l'interface d'admin
--------------------------
    
- Lancer si besoin le web service dans Docker :
  `docker-compose up sygal-import-ws`  

- Passer en mode développement :
  `docker-compose exec sygal-import-ws vendor/bin/zf-development-mode enable`   
  
- Ouvrir l'interface d'admin dans un navigateur, exemple :
  `https://localhost:8443`
  
  NB: le numéro de port dépend de la config `docker-compose.yml`, faites un `docker ps` pour le connaître.
  
- Autoriser l'interface d'admin à écrire dans les fichiers de config
  du web service :
  `docker-compose exec sygal-import-ws chown -R www-data:www-data module/ImportData/config` 

Modification de l'API
---------------------

- Le cas échéant, faire les modifications nécessaires sur l'API.

Fermer l'interface d'admin
--------------------------

- Rétablir les autorisations d'accès au fichiers :
  `sudo chown -R ${USER}:${USER} module/ImportData/config` 
  
- Ne pas oublier de désactiver le mode développement :
  `docker-compose exec sygal-import-ws vendor/bin/zf-development-mode disable`

Test
----

- Interroger l'API pour vérifier les modifs, exemple :
`curl --insecure --header "Accept: application/json" --header "Authorization: Basic c3lnYWwtYXBwOmF6ZXJ0eQ==" https://localhost:8443/doctorant`

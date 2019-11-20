Journal des modifications
=========================

1.3.0 (20/11/2019)
------------------

### Améliorations

- Transformation des vues SYGAL_* en tables pour réduire les temps de réponses du web service.
  L'utilisation de vues V_SYGAL_* perdure néanmoins comme source de données de ces tables.
  Le contenu de ces tables est mis à jour par un script PHP à CRONer.


v1.2.6 (12/11/2019)
-------------------

### Améliorations

- Prise en compte de l'INE (identifiant national étudiant) ajouté dans la vue SYGAL_DOCTORANT. 
  Utile pour l'enquête ministérielle.
- Chaque établissement peut fournir à SyGAL le libellé du "tribunal compétent" 
  mentionné dans la convention de mise en ligne générée par l'application.  
  
### Corrections

- Abandon de la colonne `COD_ANU_PRM_IAE` dans `SYGAL_THESE` qui est redondante du fait qu'une vue
  `SYGAL_THESE_ANNEE_UNIV` existe. De plus, cette colonne remontait une année de 1ere inscription erronée en cas 
  de changement de discipline. 
- Correction de la vue `SYGAL_ACTEUR` pour éviter des doublons (rarissimes) dans la colonne `ID` pouvant 
  faire échouer l'import dans SyGAL.  


v1.2.5 (09/04/2019)
-------------------

### Corrections

- Abandon de la colonne `COD_ANU_PRM_IAE` dans `SYGAL_THESE` qui est redondante du fait qu'une vue
  `SYGAL_THESE_ANNEE_UNIV` existe. De plus, cette colonne remontait une année de 1ere inscription erronée en cas 
  de changement de discipline.

### Améliorations

- Mise à jour des scripts SQL, et documentation.
- Déplacement des scripts SQL propre à chaque établissement dans le dépôt consacré au déploiement du ws. 


v1.2.4 (01/02/2019)
-------------------

### Corrections
 
- Correction du numéro de version '1.2.2' retournée par le WS alors qu'il était en version 1.2.3. 


v1.2.3 (29/01/2019)
-------------------

### Nouveautés
 
- La vue `SYGAL_FINANCEMENT` tente une "synthèse" des financements. 

    L'idée est de ne retenir qu'une année (la plus ancienne) par thèse et par origine de financement :
    - en concaténant les observations (COMPLEMENT_FINANCEMENT)
    - en cumulant les quotités
    - en retenant la plus petite date de début de financement
    - en retenant la plus grande date de fin de financement.
    
    On n'exclue plus les financements pour lesquels l'année n'est pas renseignée. 
    Quand le cas se présente on force par la 1ère année d'inscription administrative en thèse.


v1.2.2 (21/12/2018)
-------------------

### Nouveautés
 
- Nouvelle colonne dans la vue SYGAL_THESE : année universitaire de première inscription en thèse.
- Nouvelle vue SYGAL_THESE_ANNEE_UNIV : liste pour chaque thèse de toutes les années universitaires 
où le doctorant était inscrit en thèse.


v1.2.1 (29/11/2018)
-------------------

### Nouveautés
 
- Une nouvelle colonne apparaît dans la vue SYGAL_INDIVIDU permettant notamment de détecter les acteurs que 
Sygal ne sera pas en mesure de reconnaître à la connexion.
- Une nouvelle vue SYGAL_TITRE_ACCES apparaît pour fournir les titres d'accès à l'inscription en thèse.  
- Pour les corrections attendues d'une thèse, on parle désormais de corrections facultatives ou obligatoires, 
plutôt que mineures ou majeures. La vue `SYGAL_THESE` est retouchée en ce sens.


v1.2.0 (08/11/2018)
-------------------

### Nouveautés
 
- Sygal peut désormais avoir connaissance de tous les acteurs des thèses (ex: co-directeurs sur les thèses de Rouen) 
tout en permettant à l'établissement source de conserver sa propre codification des rôles des acteurs.
- Deux nouveaux services apparaissent pour que Sygal puisse importer les informations concernant le financement 
des thèses en cours : 'financement' et 'origine-financement'. 
- Le service 'version' retourne désormais la version déployée effective (à l'aide de git).


v1.1.3 (22/10/2018)
-------------------

### Corrections
 
- Correction du script de la vue Apogée SYGAL_INDIVIDU qui inversait le nom usuel et le nom de naissance 
des acteurs.


v1.1.2 (04/10/2018)
-------------------

### Corrections
 
- Les données n'étaient pas triées correctement, entraînant la présence possible du même enregistrement
sur 2 pages distinctes retournées par le web service.


v1.1.1 (21/09/2018)
-------------------

### Corrections

- Pagination des données retournées par les services, c'est plus sérieux.
- Pour ceux qui ont Apogée, amélioration du temps de réponse du service "individu" 
grâce à l'utilisation d'une vue matérialisée des emails des individus, rafraîchie toutes les 10 minutes.


v1.1.0 (13/09/2018)
-------------------

### Nouveautés
 
- Import des établissements des (co-)directeurs de thèses, rapporteurs et membres du jury, 
nécessaires à la génération des pages de couverture.

### Corrections

- Le script de la vue SYGAL_ACTEUR ne produisait pas des id totalement uniques !


v1.0.0 (24/05/2018)
-------------------

### Nouveautés
 
- Nouveaux services `structure`, `etablissement`, `unite-recherche`, `ecole-doctorale`.

### Corrections
  
- Le schéma Oracle dans lequel se trouve les vues sources est désormais spécifié dans la config.
- Abandon du prefixe de nommage des vues sources `OBJECTH_*` au profit de `SYGAL_*`. 

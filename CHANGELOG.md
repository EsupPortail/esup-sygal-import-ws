# Changelog

## v1.0.0 (24/05/2018)

- [FEATURE] Nouveaux services `structure`, `etablissement`, `unite-recherche`, `ecole-doctorale`.
- [BUGFIX]  Le schéma Oracle dans lequel se trouve les vues sources est désormais spécifié dans la config.
- [CLEANUP] Abandon du prefixe de nommage des vues sources `OBJECTH_*` au profit de `SYGAL_*`. 

## v1.1.0 (13/09/2018)

- [FEATURE] Import des établissements des (co-)directeurs de thèses, rapporteurs et membres du jury, 
nécessaires à la génération des pages de couverture.
- [BUGFIX] Le script de la vue SYGAL_ACTEUR ne produisait pas des id totalement uniques !

## v1.1.1 (21/09/2018)

- Pagination des données retournées par les services, c'est plus sérieux.
- Pour ceux qui ont Apogée, amélioration du temps de réponse du service "individu" 
grâce à l'utilisation d'une vue matérialisée des emails des individus, rafraîchie toutes les 10 minutes.

## v1.1.2 (04/10/2018)

- [BUGFIX] Les données n'étaient pas triées correctement, entraînant la présence possible du même enregistrement
sur 2 pages distinctes retournées par le web service.

## v1.1.3 (22/10/2018)

- [BUGFIX] Correction du script de la vue Apogée SYGAL_INDIVIDU qui inversait le nom usuel et le nom de naissance 
des acteurs.

## v1.2.0 (08/11/2018)

- [FEATURE] Sygal peut désormais avoir connaissance de tous les acteurs des thèses (ex: co-directeurs sur les thèses de Rouen) 
            tout en permettant à l'établissement source de conserver sa propre codification des rôles des acteurs.
- [FEATURE] Deux nouveaux services apparaissent pour que Sygal puisse importer les informations concernant le financement 
            des thèses en cours : 'financement' et 'origine-financement'. 
- [FEATURE] Le service 'version' retourne désormais la version déployée effective (à l'aide de git).

## v1.2.1 (29/11/2018)

- [FEATURE] Une nouvelle colonne apparaît dans la vue SYGAL_INDIVIDU permettant notamment de détecter les acteurs que 
            Sygal ne sera pas en mesure de reconnaître à la connexion.
- [FEATURE] Une nouvelle vue SYGAL_TITRE_ACCES apparaît pour fournir les titres d'accès à l'inscription en thèse.  
- [FEATURE] Pour les corrections attendues d'une thèse, on parle désormais de corrections facultatives ou obligatoires, 
            plutôt que mineures ou majeures. La vue `SYGAL_THESE` est retouchée en ce sens.

## v1.2.2 (21/12/2018)

- [FEATURE] Nouvelle colonne dans la vue SYGAL_THESE : année universitaire de première inscription en thèse.
- [FEATURE] Nouvelle vue SYGAL_THESE_ANNEE_UNIV : liste pour chaque thèse de toutes les années universitaires 
            où le doctorant était inscrit en thèse.

## v1.2.3 (29/01/2019)

- [FEATURE] La vue `SYGAL_FINANCEMENT` tente une "synthèse" des financements. 

    L'idée est de ne retenir qu'une année (la plus ancienne) par thèse et par origine de financement :
    - en concaténant les observations (COMPLEMENT_FINANCEMENT)
    - en cumulant les quotités
    - en retenant la plus petite date de début de financement
    - en retenant la plus grande date de fin de financement.
    
    On n'exclue plus les financements pour lesquels l'année n'est pas renseignée. 
    Quand le cas se présente on force par la 1ère année d'inscription administrative en thèse.

## v1.2.4 (01/02/2019)

- [BUGFIX] Correction du numéro de version '1.2.2' retournée par le WS alors qu'il était en version 1.2.3. 

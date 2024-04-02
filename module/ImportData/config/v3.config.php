<?php

use Laminas\ServiceManager\Factory\InvokableFactory;

return [
    'doctrine' => [
        'driver' => [
            'orm_default_xml_driver' => [
                'cache' => 'array',
                'paths' => [
                    1 => __DIR__ . '/../src/V3/Entity/Db/Mapping',
                ],
            ],
            'orm_default' => [
                'drivers' => [
                    'ImportData\\V3\\Entity\\Db' => 'orm_default_xml_driver',
                ],
            ],
        ],
    ],
    'api-tools-doctrine-query-provider' => [
        'aliases' => [
            'default_orm_V3' => \ImportData\V3\Query\Provider\FetchAll::class,
            'acteur_fetch_all_V3' => \ImportData\V3\Rest\Acteur\ActeurFetchAll::class,
        ],
        'factories' => [
            \ImportData\V3\Query\Provider\FetchAll::class => InvokableFactory::class,
            \ImportData\V3\Rest\Acteur\ActeurFetchAll::class => InvokableFactory::class,
        ],
    ],
    'router' => [
        'routes' => [
            //...
        ],
    ],
    'api-tools-versioning' => [
        'uri' => [
            //...
        ],
    ],
    'api-tools-rest' => [
        'ImportData\\V3\\Rest\\These\\Controller' => [
            'listener' => \ImportData\V3\Rest\These\TheseResource::class,
            'route_name' => 'import-data.rest.doctrine.these',
            'route_identifier_name' => 'these_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'these',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\These::class,
            'collection_class' => \ImportData\V3\Rest\These\TheseCollection::class,
            'service_name' => 'These',
        ],
        'ImportData\\V3\\Rest\\Doctorant\\Controller' => [
            'listener' => \ImportData\V3\Rest\Doctorant\DoctorantResource::class,
            'route_name' => 'import-data.rest.doctrine.doctorant',
            'route_identifier_name' => 'doctorant_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'doctorant',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Doctorant::class,
            'collection_class' => \ImportData\V3\Rest\Doctorant\DoctorantCollection::class,
            'service_name' => 'Doctorant',
        ],
        'ImportData\\V3\\Rest\\Individu\\Controller' => [
            'listener' => \ImportData\V3\Rest\Individu\IndividuResource::class,
            'route_name' => 'import-data.rest.doctrine.individu',
            'route_identifier_name' => 'individu_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'individu',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Individu::class,
            'collection_class' => \ImportData\V3\Rest\Individu\IndividuCollection::class,
            'service_name' => 'Individu',
        ],
        'ImportData\\V3\\Rest\\Acteur\\Controller' => [
            'listener' => \ImportData\V3\Rest\Acteur\ActeurResource::class,
            'route_name' => 'import-data.rest.doctrine.acteur',
            'route_identifier_name' => 'acteur_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'acteur',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [
                0 => 'these_id',
            ],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Acteur::class,
            'collection_class' => \ImportData\V3\Rest\Acteur\ActeurCollection::class,
            'service_name' => 'Acteur',
        ],
        'ImportData\\V3\\Rest\\Role\\Controller' => [
            'listener' => \ImportData\V3\Rest\Role\RoleResource::class,
            'route_name' => 'import-data.rest.doctrine.role',
            'route_identifier_name' => 'role_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'role',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Role::class,
            'collection_class' => \ImportData\V3\Rest\Role\RoleCollection::class,
            'service_name' => 'Role',
        ],
        'ImportData\\V3\\Rest\\Source\\Controller' => [
            'listener' => \ImportData\V3\Rest\Source\SourceResource::class,
            'route_name' => 'import-data.rest.doctrine.source',
            'route_identifier_name' => 'source_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'source',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Source::class,
            'collection_class' => \ImportData\V3\Rest\Source\SourceCollection::class,
            'service_name' => 'Source',
        ],
        'ImportData\\V3\\Rest\\Variable\\Controller' => [
            'listener' => \ImportData\V3\Rest\Variable\VariableResource::class,
            'route_name' => 'import-data.rest.doctrine.variable',
            'route_identifier_name' => 'variable_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'variable',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Variable::class,
            'collection_class' => \ImportData\V3\Rest\Variable\VariableCollection::class,
            'service_name' => 'Variable',
        ],
        'ImportData\\V3\\Rest\\Structure\\Controller' => [
            'listener' => \ImportData\V3\Rest\Structure\StructureResource::class,
            'route_name' => 'import-data.rest.doctrine.structure',
            'route_identifier_name' => 'structure_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'structure',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Structure::class,
            'collection_class' => \ImportData\V3\Rest\Structure\StructureCollection::class,
            'service_name' => 'Structure',
        ],
        'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => [
            'listener' => \ImportData\V3\Rest\EcoleDoctorale\EcoleDoctoraleResource::class,
            'route_name' => 'import-data.rest.doctrine.ecole-doctorale',
            'route_identifier_name' => 'ecole_doctorale_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'ecole_doctorale',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\EcoleDoctorale::class,
            'collection_class' => \ImportData\V3\Rest\EcoleDoctorale\EcoleDoctoraleCollection::class,
            'service_name' => 'EcoleDoctorale',
        ],
        'ImportData\\V3\\Rest\\Etablissement\\Controller' => [
            'listener' => \ImportData\V3\Rest\Etablissement\EtablissementResource::class,
            'route_name' => 'import-data.rest.doctrine.etablissement',
            'route_identifier_name' => 'etablissement_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'etablissement',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Etablissement::class,
            'collection_class' => \ImportData\V3\Rest\Etablissement\EtablissementCollection::class,
            'service_name' => 'Etablissement',
        ],
        'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => [
            'listener' => \ImportData\V3\Rest\UniteRecherche\UniteRechercheResource::class,
            'route_name' => 'import-data.rest.doctrine.unite-recherche',
            'route_identifier_name' => 'unite_recherche_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'unite_recherche',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\UniteRecherche::class,
            'collection_class' => \ImportData\V3\Rest\UniteRecherche\UniteRechercheCollection::class,
            'service_name' => 'UniteRecherche',
        ],
        'ImportData\\V3\\Rest\\Version\\Controller' => [
            'listener' => \ImportData\V3\Rest\Version\VersionResource::class,
            'route_name' => 'import-data.rest.version',
            'route_identifier_name' => 'version_id',
            'collection_name' => 'version',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Rest\Version\VersionEntity::class,
            'collection_class' => \ImportData\V3\Rest\Version\VersionCollection::class,
            'service_name' => 'Version',
        ],
        'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => [
            'listener' => \ImportData\V3\Rest\OrigineFinancement\OrigineFinancementResource::class,
            'route_name' => 'import-data.rest.doctrine.origine-financement',
            'route_identifier_name' => 'origine_financement_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'origine_financement',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\OrigineFinancement::class,
            'collection_class' => \ImportData\V3\Rest\OrigineFinancement\OrigineFinancementCollection::class,
            'service_name' => 'OrigineFinancement',
        ],
        'ImportData\\V3\\Rest\\Financement\\Controller' => [
            'listener' => \ImportData\V3\Rest\Financement\FinancementResource::class,
            'route_name' => 'import-data.rest.doctrine.financement',
            'route_identifier_name' => 'financement_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'financement',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\Financement::class,
            'collection_class' => \ImportData\V3\Rest\Financement\FinancementCollection::class,
            'service_name' => 'Financement',
        ],
        'ImportData\\V3\\Rest\\TitreAcces\\Controller' => [
            'listener' => \ImportData\V3\Rest\TitreAcces\TitreAccesResource::class,
            'route_name' => 'import-data.rest.doctrine.titre-acces',
            'route_identifier_name' => 'titre_acces_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'titre_acces',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\TitreAcces::class,
            'collection_class' => \ImportData\V3\Rest\TitreAcces\TitreAccesCollection::class,
            'service_name' => 'TitreAcces',
        ],
        'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => [
            'listener' => \ImportData\V3\Rest\TheseAnneeUniv\TheseAnneeUnivResource::class,
            'route_name' => 'import-data.rest.doctrine.these-annee-univ',
            'route_identifier_name' => 'these_annee_univ_id',
            'entity_identifier_name' => 'id',
            'collection_name' => 'these_annee_univ',
            'entity_http_methods' => [
                0 => 'GET',
            ],
            'collection_http_methods' => [
                0 => 'GET',
            ],
            'collection_query_whitelist' => [],
            'page_size' => '500',
            'page_size_param' => '',
            'entity_class' => \ImportData\V3\Entity\Db\TheseAnneeUniv::class,
            'collection_class' => \ImportData\V3\Rest\TheseAnneeUniv\TheseAnneeUnivCollection::class,
            'service_name' => 'TheseAnneeUniv',
        ],
    ],
    'api-tools-content-negotiation' => [
        'controllers' => [
            'ImportData\\V3\\Rest\\These\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Doctorant\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Individu\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Acteur\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Role\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Source\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Variable\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Structure\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Etablissement\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Version\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\Financement\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\TitreAcces\\Controller' => 'HalJson',
            'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => 'HalJson',
        ],
        'accept-whitelist' => [

        ],
        'content-type-whitelist' => [

        ],
        'accept_whitelist' => [
            'ImportData\\V3\\Rest\\Structure\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Etablissement\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Acteur\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Variable\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Individu\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\These\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Doctorant\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Role\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Source\\Controller' => [
                0 => 'application/json',
                1 => 'application/*+json',
            ],
            'ImportData\\V3\\Rest\\Version\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/hal+json',
                2 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/hal+json',
                2 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Financement\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/hal+json',
                2 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\TitreAcces\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/hal+json',
                2 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/hal+json',
                2 => 'application/json',
            ],
        ],
        'content_type_whitelist' => [
            'ImportData\\V3\\Rest\\Structure\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Etablissement\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Acteur\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Variable\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Individu\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\These\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Doctorant\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Role\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Source\\Controller' => [
                0 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Version\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\Financement\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\TitreAcces\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/json',
            ],
            'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => [
                0 => 'application/vnd.import-data.v3+json',
                1 => 'application/json',
            ],
        ],
    ],
    'api-tools-hal' => [
        'metadata_map' => [
            \ImportData\V3\Entity\Db\These::class => [
                'route_identifier_name' => 'these_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.these',
                'hydrator' => 'ImportData\\V3\\Rest\\These\\TheseHydrator',
            ],
            \ImportData\V3\Rest\These\TheseCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.these',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Doctorant::class => [
                'route_identifier_name' => 'doctorant_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.doctorant',
                'hydrator' => 'ImportData\\V3\\Rest\\Doctorant\\DoctorantHydrator',
            ],
            \ImportData\V3\Rest\Doctorant\DoctorantCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.doctorant',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Individu::class => [
                'route_identifier_name' => 'individu_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.individu',
                'hydrator' => 'ImportData\\V3\\Rest\\Individu\\IndividuHydrator',
            ],
            \ImportData\V3\Rest\Individu\IndividuCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.individu',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Acteur::class => [
                'route_identifier_name' => 'acteur_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.acteur',
                'hydrator' => 'ImportData\\V3\\Rest\\Acteur\\ActeurHydrator',
            ],
            \ImportData\V3\Rest\Acteur\ActeurCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.acteur',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Role::class => [
                'route_identifier_name' => 'role_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.role',
                'hydrator' => 'ImportData\\V3\\Rest\\Role\\RoleHydrator',
            ],
            \ImportData\V3\Rest\Role\RoleCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.role',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Source::class => [
                'route_identifier_name' => 'source_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.source',
                'hydrator' => 'ImportData\\V3\\Rest\\Source\\SourceHydrator',
            ],
            \ImportData\V3\Rest\Source\SourceCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.source',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Variable::class => [
                'route_identifier_name' => 'variable_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.variable',
                'hydrator' => 'ImportData\\V3\\Rest\\Variable\\VariableHydrator',
            ],
            \ImportData\V3\Rest\Variable\VariableCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.variable',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Structure::class => [
                'route_identifier_name' => 'structure_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.structure',
                'hydrator' => 'ImportData\\V3\\Rest\\Structure\\StructureHydrator',
            ],
            \ImportData\V3\Rest\Structure\StructureCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.structure',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\EcoleDoctorale::class => [
                'route_identifier_name' => 'ecole_doctorale_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.ecole-doctorale',
                'hydrator' => 'ImportData\\V3\\Rest\\EcoleDoctorale\\EcoleDoctoraleHydrator',
            ],
            \ImportData\V3\Rest\EcoleDoctorale\EcoleDoctoraleCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.ecole-doctorale',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Etablissement::class => [
                'route_identifier_name' => 'etablissement_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.etablissement',
                'hydrator' => 'ImportData\\V3\\Rest\\Etablissement\\EtablissementHydrator',
            ],
            \ImportData\V3\Rest\Etablissement\EtablissementCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.etablissement',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\UniteRecherche::class => [
                'route_identifier_name' => 'unite_recherche_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.unite-recherche',
                'hydrator' => 'ImportData\\V3\\Rest\\UniteRecherche\\UniteRechercheHydrator',
            ],
            \ImportData\V3\Rest\UniteRecherche\UniteRechercheCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.unite-recherche',
                'is_collection' => '1',
            ],
            \ImportData\V3\Rest\Version\VersionEntity::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.version',
                'route_identifier_name' => 'version_id',
                'hydrator' => \Laminas\Hydrator\ClassMethods::class,
            ],
            \ImportData\V3\Rest\Version\VersionCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.version',
                'route_identifier_name' => 'version_id',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\OrigineFinancement::class => [
                'route_identifier_name' => 'origine_financement_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.origine-financement',
                'hydrator' => 'ImportData\\V3\\Rest\\OrigineFinancement\\OrigineFinancementHydrator',
            ],
            \ImportData\V3\Rest\OrigineFinancement\OrigineFinancementCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.origine-financement',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\Financement::class => [
                'route_identifier_name' => 'financement_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.financement',
                'hydrator' => 'ImportData\\V3\\Rest\\Financement\\FinancementHydrator',
            ],
            \ImportData\V3\Rest\Financement\FinancementCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.financement',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\TitreAcces::class => [
                'route_identifier_name' => 'titre_acces_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.titre-acces',
                'hydrator' => 'ImportData\\V3\\Rest\\TitreAcces\\TitreAccesHydrator',
            ],
            \ImportData\V3\Rest\TitreAcces\TitreAccesCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.titre-acces',
                'is_collection' => '1',
            ],
            \ImportData\V3\Entity\Db\TheseAnneeUniv::class => [
                'route_identifier_name' => 'these_annee_univ_id',
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.these-annee-univ',
                'hydrator' => 'ImportData\\V3\\Rest\\TheseAnneeUniv\\TheseAnneeUnivHydrator',
            ],
            \ImportData\V3\Rest\TheseAnneeUniv\TheseAnneeUnivCollection::class => [
                'entity_identifier_name' => 'id',
                'route_name' => 'import-data.rest.doctrine.these-annee-univ',
                'is_collection' => '1',
            ],
        ],
    ],
    'api-tools' => [
        'doctrine-connected' => [
            \ImportData\V3\Rest\These\TheseResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\These\\TheseHydrator',
            ],
            \ImportData\V3\Rest\Doctorant\DoctorantResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Doctorant\\DoctorantHydrator',
            ],
            \ImportData\V3\Rest\Individu\IndividuResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Individu\\IndividuHydrator',
            ],
            \ImportData\V3\Rest\Acteur\ActeurResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Acteur\\ActeurHydrator',
                'query_providers' => [
                    'default' => 'default_orm_V3',
                    'fetch_all' => 'acteur_fetch_all_V3',
                ],
            ],
            \ImportData\V3\Rest\Role\RoleResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Role\\RoleHydrator',
            ],
            \ImportData\V3\Rest\Source\SourceResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Source\\SourceHydrator',
            ],
            \ImportData\V3\Rest\Variable\VariableResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Variable\\VariableHydrator',
            ],
            \ImportData\V3\Rest\Structure\StructureResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Structure\\StructureHydrator',
            ],
            \ImportData\V3\Rest\EcoleDoctorale\EcoleDoctoraleResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\EcoleDoctorale\\EcoleDoctoraleHydrator',
            ],
            \ImportData\V3\Rest\Etablissement\EtablissementResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Etablissement\\EtablissementHydrator',
            ],
            \ImportData\V3\Rest\UniteRecherche\UniteRechercheResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\UniteRecherche\\UniteRechercheHydrator',
            ],
            \ImportData\V3\Rest\OrigineFinancement\OrigineFinancementResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\OrigineFinancement\\OrigineFinancementHydrator',
            ],
            \ImportData\V3\Rest\Financement\FinancementResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\Financement\\FinancementHydrator',
            ],
            \ImportData\V3\Rest\TitreAcces\TitreAccesResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\TitreAcces\\TitreAccesHydrator',
            ],
            \ImportData\V3\Rest\TheseAnneeUniv\TheseAnneeUnivResource::class => [
                'object_manager' => 'doctrine.entitymanager.orm_default',
                'hydrator' => 'ImportData\\V3\\Rest\\TheseAnneeUniv\\TheseAnneeUnivHydrator',
            ],
        ],
    ],
    'doctrine-hydrator' => [
        'ImportData\\V3\\Rest\\These\\TheseHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\These::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Doctorant\\DoctorantHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Doctorant::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Individu\\IndividuHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Individu::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Acteur\\ActeurHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Acteur::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Role\\RoleHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Role::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Source\\SourceHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Source::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Variable\\VariableHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Variable::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Structure\\StructureHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Structure::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\EcoleDoctorale\\EcoleDoctoraleHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\EcoleDoctorale::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Etablissement\\EtablissementHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Etablissement::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\UniteRecherche\\UniteRechercheHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\UniteRecherche::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\OrigineFinancement\\OrigineFinancementHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\OrigineFinancement::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\Financement\\FinancementHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\Financement::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\TitreAcces\\TitreAccesHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\TitreAcces::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
        'ImportData\\V3\\Rest\\TheseAnneeUniv\\TheseAnneeUnivHydrator' => [
            'entity_class' => \ImportData\V3\Entity\Db\TheseAnneeUniv::class,
            'object_manager' => 'doctrine.entitymanager.orm_default',
            'by_value' => true,
            'strategies' => [],
            'use_generated_hydrator' => true,
        ],
    ],
    'api-tools-content-validation' => [
        'ImportData\\V3\\Rest\\These\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\These\\Validator',
        ],
        'ImportData\\V3\\Rest\\Doctorant\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Doctorant\\Validator',
        ],
        'ImportData\\V3\\Rest\\Individu\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Individu\\Validator',
        ],
        'ImportData\\V3\\Rest\\Acteur\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Acteur\\Validator',
        ],
        'ImportData\\V3\\Rest\\Role\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Role\\Validator',
        ],
        'ImportData\\V3\\Rest\\Source\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Source\\Validator',
        ],
        'ImportData\\V3\\Rest\\Variable\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Variable\\Validator',
        ],
        'ImportData\\V3\\Rest\\Structure\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Structure\\Validator',
        ],
        'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\EcoleDoctorale\\Validator',
        ],
        'ImportData\\V3\\Rest\\Etablissement\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Etablissement\\Validator',
        ],
        'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\UniteRecherche\\Validator',
        ],
        'ImportData\\V3\\Rest\\Version\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Version\\Validator',
        ],
        'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\OrigineFinancement\\Validator',
        ],
        'ImportData\\V3\\Rest\\Financement\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\Financement\\Validator',
        ],
        'ImportData\\V3\\Rest\\TitreAcces\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\TitreAcces\\Validator',
        ],
        'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => [
            'input_filter' => 'ImportData\\V3\\Rest\\TheseAnneeUniv\\Validator',
        ],
    ],
    'input_filter_specs' => [
        'ImportData\\V3\\Rest\\These\\Validator' => [
            0 => [
                'name' => 'title',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '800',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Doctorant\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\Digits::class,
                    ],
                ],
                'validators' => [],
            ],
            1 => [
                'name' => 'individuId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\Digits::class,
                    ],
                ],
                'validators' => [],
            ],
            2 => [
                'required' => '',
                'validators' => [],
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                        'options' => [],
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                        'options' => [],
                    ],
                ],
                'name' => 'ine',
            ],
            3 => [
                'required' => '',
                'validators' => [],
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                        'options' => [],
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                        'options' => [],
                    ],
                ],
                'name' => 'codeApprenantInSource',
            ],
        ],
        'ImportData\\V3\\Rest\\Individu\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'type',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '9',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'civilite',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '5',
                        ],
                    ],
                ],
            ],
            3 => [
                'name' => 'nomUsuel',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
            4 => [
                'name' => 'nomPatronymique',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
            5 => [
                'name' => 'prenom1',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
            6 => [
                'name' => 'prenom2',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
            7 => [
                'name' => 'prenom3',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
            8 => [
                'name' => 'email',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '256',
                        ],
                    ],
                ],
            ],
            9 => [
                'name' => 'dateNaissance',
                'required' => '',
                'filters' => [],
                'validators' => [],
            ],
            10 => [
                'name' => 'nationalite',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '60',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Acteur\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'theseId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'roleId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '1',
                        ],
                    ],
                ],
            ],
            3 => [
                'name' => 'individuId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            4 => [
                'name' => 'codeRoleJury',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '1',
                        ],
                    ],
                ],
            ],
            5 => [
                'name' => 'libRoleJury',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            6 => [
                'name' => 'codeEtablissement',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            7 => [
                'name' => 'libEtablissement',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            8 => [
                'name' => 'codeQualite',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '10',
                        ],
                    ],
                ],
            ],
            9 => [
                'name' => 'libQualite',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            10 => [
                'name' => 'temoinHDR',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '1',
                        ],
                    ],
                ],
            ],
            11 => [
                'name' => 'temoinRapport',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '1',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Role\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'libLongRole',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'libCourtRole',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '10',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Source\\Validator' => [
            0 => [
                'name' => 'libelle',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'importable',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\Digits::class,
                    ],
                ],
                'validators' => [],
            ],
        ],
        'ImportData\\V3\\Rest\\Variable\\Validator' => [
            0 => [
                'name' => 'libEtablissement',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '20',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'libResponsable',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'libTitre',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '100',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Structure\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'typeStructureId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'code',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            3 => [
                'name' => 'sigle',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            4 => [
                'name' => 'libelle',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '200',
                        ],
                    ],
                ],
            ],
            5 => [
                'name' => 'codePays',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            6 => [
                'name' => 'libellePays',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '200',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\EcoleDoctorale\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'structureId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Etablissement\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'structureId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\UniteRecherche\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'structureId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '64',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Version\\Validator' => [
            0 => [
                'required' => '1',
                'validators' => [],
                'filters' => [],
                'name' => 'number',
                'description' => 'Numéro de version, ex: 1.1.1',
                'field_type' => 'string',
            ],
        ],
        'ImportData\\V3\\Rest\\OrigineFinancement\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'codOfi',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            2 => [
                'name' => 'licOfi',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '10',
                        ],
                    ],
                ],
            ],
            3 => [
                'name' => 'libOfi',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '50',
                        ],
                    ],
                ],
            ],
        ],
        'ImportData\\V3\\Rest\\Financement\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '6',
                        ],
                    ],
                ],
            ],
            1 => [
                'name' => 'theseId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\Digits::class,
                    ],
                ],
                'validators' => [],
            ],
            2 => [
                'name' => 'annee',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            3 => [
                'name' => 'origineFinancementId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '8',
                        ],
                    ],
                ],
            ],
            4 => [
                'name' => 'complementFinancement',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [
                    0 => [
                        'name' => \Laminas\Validator\StringLength::class,
                        'options' => [
                            'min' => '1',
                            'max' => '40',
                        ],
                    ],
                ],
            ],
            5 => [
                'name' => 'quotiteFinancement',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\Digits::class,
                    ],
                ],
                'validators' => [],
            ],
            6 => [
                'name' => 'dateDebutFinancement',
                'required' => '',
                'filters' => [],
                'validators' => [],
            ],
            7 => [
                'name' => 'dateFinFinancement',
                'required' => '',
                'filters' => [],
                'validators' => [],
            ],
        ],
        'ImportData\\V3\\Rest\\TitreAcces\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            1 => [
                'name' => 'theseId',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            2 => [
                'name' => 'titreAccesInterneExterne',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            3 => [
                'name' => 'libelleTitreAcces',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            4 => [
                'name' => 'typeEtabTitreAcces',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            5 => [
                'name' => 'libelleEtabTitreAcces',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            6 => [
                'name' => 'codeDeptTitreAcces',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            7 => [
                'name' => 'codePaysTitreAcces',
                'required' => '',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
        ],
        'ImportData\\V3\\Rest\\TheseAnneeUniv\\Validator' => [
            0 => [
                'name' => 'sourceId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            1 => [
                'name' => 'theseId',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
            2 => [
                'name' => 'anneeUniv',
                'required' => '1',
                'filters' => [
                    0 => [
                        'name' => \Laminas\Filter\StringTrim::class,
                    ],
                    1 => [
                        'name' => \Laminas\Filter\StripTags::class,
                    ],
                ],
                'validators' => [],
            ],
        ],
    ],
    'api-tools-mvc-auth' => [
        'authorization' => [
            'ImportData\\V3\\Rest\\These\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Doctorant\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Individu\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Acteur\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Role\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Source\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Variable\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Structure\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\EcoleDoctorale\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Etablissement\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\UniteRecherche\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Version\\Controller' => [
                'collection' => [
                    'GET' => '',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\OrigineFinancement\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\Financement\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
            'ImportData\\V3\\Rest\\TheseAnneeUniv\\Controller' => [
                'collection' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
                'entity' => [
                    'GET' => '1',
                    'POST' => '',
                    'PUT' => '',
                    'PATCH' => '',
                    'DELETE' => '',
                ],
            ],
        ],
    ],
    'service_manager' => [
        'factories' => [
            \ImportData\V3\Rest\Version\VersionResource::class => \ImportData\V3\Rest\Version\VersionResourceFactory::class,
        ],
    ],
];

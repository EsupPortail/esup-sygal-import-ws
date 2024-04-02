<?php

return [
    'logging' => [
        'enabled' => false,
        'params' => [
            'name' => 'fetch_log',
            'file_path' => '/tmp/api-logging.log',
            'max_files' => 5,
        ],
    ],
    'doctrine' => [
        'driver' => [
            'orm_default_xml_driver' => [
                'class' => \Doctrine\ORM\Mapping\Driver\XmlDriver::class,
                'cache' => 'array',
                'paths' => [
                    //...
                ],
            ],
            'orm_default' => [
                'class' => \Doctrine\Persistence\Mapping\Driver\MappingDriverChain::class,
                'drivers' => [
                    //...
                ],
            ],
        ],
    ],
    'api-tools-doctrine-query-provider' => [
        'aliases' => [
            //...
        ],
        'factories' => [
            //...
        ],
    ],
    'router' => [
        'routes' => [
            //...
        ],
    ],
    'api-tools-versioning' => [
        'uri' => [
            0 => 'import-data.rest.doctrine.these',
            1 => 'import-data.rest.doctrine.doctorant',
            2 => 'import-data.rest.doctrine.individu',
            3 => 'import-data.rest.doctrine.acteur',
            4 => 'import-data.rest.doctrine.role',
            5 => 'import-data.rest.doctrine.source',
            6 => 'import-data.rest.doctrine.variable',
            7 => 'import-data.rest.doctrine.structure',
            8 => 'import-data.rest.doctrine.ecole-doctorale',
            9 => 'import-data.rest.doctrine.etablissement',
            10 => 'import-data.rest.doctrine.unite-recherche',
            11 => 'import-data.rest.version',
            12 => 'import-data.rest.doctrine.origine-financement',
            13 => 'import-data.rest.doctrine.financement',
            14 => 'import-data.rest.doctrine.titre-acces',
            15 => 'import-data.rest.doctrine.these-annee-univ',
        ],
    ],
    'api-tools-rest' => [
        //...
    ],
    'api-tools-content-negotiation' => [
        'controllers' => [
            //...
        ],
        'accept-whitelist' => [
            //...
        ],
        'content-type-whitelist' => [
            //...
        ],
        'accept_whitelist' => [
            //...
        ],
        'content_type_whitelist' => [
            //...
        ],
    ],
    'api-tools-hal' => [
        'metadata_map' => [
            //...
        ],
    ],
    'api-tools' => [
        'doctrine-connected' => [
            //...
        ],
    ],
    'doctrine-hydrator' => [
        //...
    ],
    'api-tools-content-validation' => [
        //...
    ],
    'input_filter_specs' => [
        //...
    ],
    'api-tools-mvc-auth' => [
        'authorization' => [
            //...
        ],
    ],
    'service_manager' => [
        'factories' => [
            \ImportData\ApiLogging::class => \ImportData\ApiLoggingFactory::class,
        ],
    ],
];

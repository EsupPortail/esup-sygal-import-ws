<?php

namespace Application;

use Application\Controller\ConsoleController;
use Application\Service\TableService;
use Application\Service\TableServiceFactory;
use Doctrine\DBAL\Logging\EchoSQLLogger;
use Laminas\ServiceManager\Factory\InvokableFactory;

return [
    'log' => [
        'console_logger' => [
            'writers' => [
                'stream' => [
                    'name' => 'stream',
                    'priority' => 1,
                    'options' => [
                        'stream' => 'php://output',
                    ],
                ],
            ],
        ],
    ],
    'services_to_entity_classes' => [
        'structure' => [
            //\ImportData\V1\Entity\Db\Structure::class,
            \ImportData\V2\Entity\Db\Structure::class,
            \ImportData\V3\Entity\Db\Structure::class,
        ],
        'etablissement' => [
            //\ImportData\V1\Entity\Db\Etablissement::class,
            \ImportData\V2\Entity\Db\Etablissement::class,
            \ImportData\V3\Entity\Db\Etablissement::class,
        ],
        'ecole-doctorale' => [
            //\ImportData\V1\Entity\Db\EcoleDoctorale::class,
            \ImportData\V2\Entity\Db\EcoleDoctorale::class,
            \ImportData\V3\Entity\Db\EcoleDoctorale::class,
        ],
        'unite-recherche' => [
            //\ImportData\V1\Entity\Db\UniteRecherche::class,
            \ImportData\V2\Entity\Db\UniteRecherche::class,
            \ImportData\V3\Entity\Db\UniteRecherche::class,
        ],
        'individu' => [
            //\ImportData\V1\Entity\Db\Individu::class,
            \ImportData\V2\Entity\Db\Individu::class,
            \ImportData\V3\Entity\Db\Individu::class,
        ],
        'doctorant' => [
            //\ImportData\V1\Entity\Db\Doctorant::class,
            \ImportData\V2\Entity\Db\Doctorant::class,
            \ImportData\V3\Entity\Db\Doctorant::class,
        ],
        'these' => [
            //\ImportData\V1\Entity\Db\These::class,
            \ImportData\V2\Entity\Db\These::class,
            \ImportData\V3\Entity\Db\These::class,
        ],
        'these-annee-univ' => [
            //\ImportData\V1\Entity\Db\TheseAnneeUniv::class,
            \ImportData\V2\Entity\Db\TheseAnneeUniv::class,
            \ImportData\V3\Entity\Db\TheseAnneeUniv::class,
        ],
        'role' => [
            //\ImportData\V1\Entity\Db\Role::class,
            \ImportData\V2\Entity\Db\Role::class,
            \ImportData\V3\Entity\Db\Role::class,
        ],
        'acteur' => [
            //\ImportData\V1\Entity\Db\Acteur::class,
            \ImportData\V2\Entity\Db\Acteur::class,
            \ImportData\V3\Entity\Db\Acteur::class,
        ],
        'variable' => [
            //\ImportData\V1\Entity\Db\Variable::class,
            \ImportData\V2\Entity\Db\Variable::class,
            \ImportData\V3\Entity\Db\Variable::class,
        ],
        'origine-financement' => [
            //\ImportData\V1\Entity\Db\OrigineFinancement::class,
            \ImportData\V2\Entity\Db\OrigineFinancement::class,
            \ImportData\V3\Entity\Db\OrigineFinancement::class,
        ],
        'financement' => [
            //\ImportData\V1\Entity\Db\Financement::class,
            \ImportData\V2\Entity\Db\Financement::class,
            \ImportData\V3\Entity\Db\Financement::class,
        ],
        'titre-acces' => [
            //\ImportData\V1\Entity\Db\TitreAcces::class,
            \ImportData\V2\Entity\Db\TitreAcces::class,
            \ImportData\V3\Entity\Db\TitreAcces::class,
        ],
    ],
    'doctrine' => [
        'sql_logger_collector' => [
            'orm_default' => [
                'name' => 'orm_default',
                'sql_logger' => 'echooooo',
            ],
        ],
    ],
    'service_manager' => [
        'invokables' => [
            'echooooo' => EchoSQLLogger::class,
        ],
        'factories' => [
            TableService::class => TableServiceFactory::class,
        ],
    ],
    'console' => [
        'router' => [
            'routes' => [
                'update-service-tables' => [
                    'options' => [
                        'route'    => 'update-service-tables [--services=] [--version=] [--verbose]',
                        'defaults' => [
                            /**
                             * @see ConsoleController::updateServiceTablesAction()
                             */
                            'controller' => Controller\ConsoleController::class,
                            'action'     => 'update-service-tables',
                        ],
                    ],
                ],
            ],
        ],
    ],
    'router' => [
        'routes' => [
            'home' => [
                'type' => 'Literal',
                'options' => [
                    'route'    => '/',
                    'defaults' => [
                        'controller' => Controller\IndexController::class,
                        'action'     => 'index',
                    ],
                ],
            ],
        ],
    ],
    'controllers' => [
        'factories' => [
            Controller\IndexController::class => InvokableFactory::class,
            Controller\ConsoleController::class => Controller\ConsoleControllerFactory::class,
        ],
    ],
    'view_manager' => [
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => [
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'application/index/index' => __DIR__ . '/../view/application/index/index.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ],
        'template_path_stack' => [
            __DIR__ . '/../view',
        ],
    ],
];

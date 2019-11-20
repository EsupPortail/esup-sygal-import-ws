<?php

namespace Application;

use Application\Controller\ConsoleController;
use Application\Service\TableService;
use Application\Service\TableServiceFactory;
use Doctrine\DBAL\Logging\EchoSQLLogger;
use ImportData\V1\Entity\Db\Acteur;
use ImportData\V1\Entity\Db\Doctorant;
use ImportData\V1\Entity\Db\EcoleDoctorale;
use ImportData\V1\Entity\Db\Etablissement;
use ImportData\V1\Entity\Db\Financement;
use ImportData\V1\Entity\Db\Individu;
use ImportData\V1\Entity\Db\Role;
use ImportData\V1\Entity\Db\Structure;
use ImportData\V1\Entity\Db\These;
use ImportData\V1\Entity\Db\TheseAnneeUniv;
use ImportData\V1\Entity\Db\TitreAcces;
use ImportData\V1\Entity\Db\UniteRecherche;
use ImportData\V1\Entity\Db\Variable;
use Zend\ServiceManager\Factory\InvokableFactory;

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
        'structure'        => Structure::class,
        'etablissement'    => Etablissement::class,
        'ecole-doctorale'  => EcoleDoctorale::class,
        'unite-recherche'  => UniteRecherche::class,
        'individu'         => Individu::class,
        'doctorant'        => Doctorant::class,
        'these'            => These::class,
        'these-annee-univ' => TheseAnneeUniv::class,
        'role'             => Role::class,
        'acteur'           => Acteur::class,
        'variable'         => Variable::class,
        //'origine-financement' => n'est plus importé.
        'financement'      => Financement::class,
        'titre-acces'      => TitreAcces::class,
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
                        'route'    => 'update-service-tables [--services=] [--verbose]',
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

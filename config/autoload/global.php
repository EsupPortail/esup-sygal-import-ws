<?php

return [
    'api-tools-mvc-auth' => [
        'authentication' => [
            'adapters' => [
                'basic' => [
                    'adapter' => \Laminas\ApiTools\MvcAuth\Authentication\HttpAdapter::class,
                    'options' => [
                        'accept_schemes' => [
                            0 => 'basic',
                        ],
                        'realm' => 'api',
                        //'htpasswd' => __DIR__ . '/../users.htpasswd',
                    ],
                ],
            ],
        ],
    ],
    'api-tools-content-negotiation' => [
        'selectors' => [],
    ],
    'db' => [
        'adapters' => [
            'dummy' => [],
        ],
    ],
];

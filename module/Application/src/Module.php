<?php

namespace Application;

use Laminas\Console\Adapter\AdapterInterface as Console;
use Laminas\ModuleManager\Feature\ConsoleUsageProviderInterface;

class Module implements ConsoleUsageProviderInterface
{
    public function getConfig()
    {
        return include __DIR__ . '/../config/module.config.php';
    }

    public function getConsoleUsage(Console $console)
    {
        return [
            'update-service-tables [--services=] [--verbose]' =>
                "Mettre à jour les données des tables sources des services.",
            [
                '--services',
                "Facultatif. " . PHP_EOL .
                "Liste des services concernés séparés par des virgules. " . PHP_EOL .
                "Ex: 'structure,etablissement,unite-rech,ecole-doct'",
            ],
            [
                '--verbose',
                "Facultatif. " . PHP_EOL .
                "Augmente la quantité de logs générés.",
            ],
        ];
    }
}

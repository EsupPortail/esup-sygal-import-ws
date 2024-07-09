<?php

namespace Application;

use Unicaen\Console\Adapter\AdapterInterface as Console;

class Module
{
    public function getConfig()
    {
        return include __DIR__ . '/../config/module.config.php';
    }

    public function getConsoleUsage(Console $console)
    {
        return [
            'update-service-tables [--services=] [--version] [--verbose]' =>
                "Mettre à jour les données des tables sources des services.",
            [
                '--services',
                "Facultatif. " . PHP_EOL .
                "Liste des services concernés séparés par des virgules. " . PHP_EOL .
                "Ex: 'structure,etablissement,unite-rech,ecole-doct'",
            ],
            [
                '--version',
                "Facultatif. " . PHP_EOL .
                "Version d'API concernée. " . PHP_EOL .
                "Ex: 'V2'",
            ],
            [
                '--verbose',
                "Facultatif. " . PHP_EOL .
                "Augmente la quantité de logs générés.",
            ],
        ];
    }
}

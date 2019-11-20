<?php

namespace Application\Controller;

use Application\Service\TableService;
use Interop\Container\ContainerInterface;
use Zend\Log\Logger;

class ConsoleControllerFactory
{
    public function __invoke(ContainerInterface $container)
    {
        /** @var TableService $tableService */
        $tableService = $container->get(TableService::class);

        /** @var Logger $logger */
        $logger = $container->get('console_logger');

        $controller = new ConsoleController();
        $controller->setTableService($tableService);
        $controller->setLogger($logger);

        return $controller;
    }
}
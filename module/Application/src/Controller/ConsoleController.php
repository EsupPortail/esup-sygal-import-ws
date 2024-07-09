<?php

namespace Application\Controller;

use Application\Service\TableService;
use Laminas\Log\Filter\Priority;
use Laminas\Log\Logger;
use Laminas\Log\LoggerAwareTrait;
use Laminas\Log\Writer\AbstractWriter;
use Unicaen\Console\Controller\AbstractConsoleController;

/**
 * @property Logger $logger
 *
 * @author Unicaen
 */
class ConsoleController extends AbstractConsoleController
{
    use LoggerAwareTrait;

    private TableService $tableService;

    public function setTableService(TableService $tableService): void
    {
        $this->tableService = $tableService;
    }

    public function updateServiceTablesAction(): void
    {
        /** @var \Unicaen\Console\Request $request */
        $request = $this->getRequest();
        $services = $request->getParam('services');
        $version = $request->getParam('version');
        $verbose = $request->getParam('verbose');

        $priority = $verbose ? Logger::DEBUG : Logger::INFO;
        foreach ($this->logger->getWriters()->toArray() as $writer) {
            /** @var AbstractWriter $writer */
            $writer->addFilter(new Priority($priority));
        }
        $this->tableService->setLogger($this->logger);

        if ($services !== null) {
            $services = explode(',', $services);
            $this->tableService->updateTablesForServices($services, $version);
        } else {
            $this->tableService->updateTablesForAllServices($version);
        }

        $this->logger->info("Terminé.");
    }
}

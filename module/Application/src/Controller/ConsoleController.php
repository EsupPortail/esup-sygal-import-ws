<?php

namespace Application\Controller;

use Application\Service\TableService;
use Zend\Log\Filter\Priority;
use Zend\Log\Logger;
use Zend\Log\LoggerAwareTrait;
use Zend\Log\Writer\AbstractWriter;
use Zend\Mvc\Console\Controller\AbstractConsoleController;

/**
 * @property Logger $logger
 *
 * @author Unicaen
 */
class ConsoleController extends AbstractConsoleController
{
    use LoggerAwareTrait;

    /**
     * @var TableService
     */
    private $tableService;

    /**
     * @param TableService $tableService
     */
    public function setTableService(TableService $tableService)
    {
        $this->tableService = $tableService;
    }

    public function updateServiceTablesAction()
    {
        $request = $this->getRequest();
        $services = $request->getParam('services');
        $verbose = $request->getParam('verbose');

        $priority = $verbose ? Logger::DEBUG : Logger::INFO;
        foreach ($this->logger->getWriters()->toArray() as $writer) {
            /** @var AbstractWriter $writer */
            $writer->addFilter(new Priority($priority));
        }
        $this->tableService->setLogger($this->logger);

        if ($services !== null) {
            $services = explode(',', $services);
            $this->tableService->updateTablesForServices($services);
        } else {
            $this->tableService->updateTablesForAllServices();
        }

        $this->logger->info("Terminé.");
    }
}

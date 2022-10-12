<?php
namespace ImportData;

use Interop\Container\ContainerInterface;
use Laminas\EventManager\EventInterface;
use Laminas\ModuleManager\Feature\BootstrapListenerInterface;
use Laminas\ApiTools\Application;
use Laminas\ApiTools\Provider\ApiToolsProviderInterface;

class Module implements ApiToolsProviderInterface, BootstrapListenerInterface
{
    /**
     * @return array
     *
     * @codeCoverageIgnore
     */
    public function getConfig()
    {
        return include __DIR__ . '/../config/module.config.php';
    }

    public function onBootstrap(EventInterface $e)
    {
        /** @var Application $application */
        $application = $e->getTarget();
        /** @var ContainerInterface $container */
        $container = $application->getServiceManager();

        /** @var ApiLogging $apiLogging */
        $apiLogging = $container->get(ApiLogging::class);
        $apiLogging->attach($application->getEventManager());
    }
}

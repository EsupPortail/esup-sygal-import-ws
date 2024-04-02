<?php
namespace ImportData;

use Interop\Container\ContainerInterface;
use Laminas\ApiTools\Application;
use Laminas\ApiTools\Provider\ApiToolsProviderInterface;
use Laminas\Config\Factory as ConfigFactory;
use Laminas\EventManager\EventInterface;
use Laminas\ModuleManager\Feature\BootstrapListenerInterface;

class Module implements ApiToolsProviderInterface, BootstrapListenerInterface
{
    /**
     * @codeCoverageIgnore
     */
    public function getConfig(): array
    {
        return ConfigFactory::fromFiles([
            __DIR__ . '/../config/module.config.php',
            __DIR__ . '/../config/v1.config.php',
            __DIR__ . '/../config/v2.config.php',
            __DIR__ . '/../config/v3.config.php',
        ]);
    }

    public function onBootstrap(EventInterface $e): void
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

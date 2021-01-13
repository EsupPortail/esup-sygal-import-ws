<?php
namespace ImportData;

use Interop\Container\ContainerInterface;
use Zend\EventManager\EventInterface;
use Zend\ModuleManager\Feature\BootstrapListenerInterface;
use ZF\Apigility\Application;
use ZF\Apigility\Provider\ApigilityProviderInterface;

class Module implements ApigilityProviderInterface, BootstrapListenerInterface
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

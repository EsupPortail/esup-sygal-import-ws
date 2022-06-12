<?php

namespace ImportData;

use Doctrine\ORM\Configuration;
use Interop\Container\ContainerInterface;
use Monolog\Formatter\LineFormatter;
use Monolog\Handler\RotatingFileHandler;
use Monolog\Logger;
use Webmozart\Assert\Assert;
use Laminas\ServiceManager\Factory\FactoryInterface;

class ApiLoggingFactory implements FactoryInterface
{
    public function __invoke(ContainerInterface $container, $requestedName, array $options = null)
    {
        $config = $container->get('config');
        Assert::keyExists($config, 'logging', "Clé 'logging' introuvable dans la config");

        $loggingConfig = $config['logging'];
        Assert::keyExists($loggingConfig, 'enabled', "Clé 'enabled' introuvable dans la config 'logging'");
        Assert::keyExists($loggingConfig, 'params', "Clé 'params' introuvable dans la config 'logging'");

        $enabled = $loggingConfig['enabled'];
        $params = $loggingConfig['params'];
        Assert::boolean($enabled, "La clé 'enabled' dans la config 'logging' doit être un booléen");
        Assert::isArray($params, "Clé 'params' dans la config 'logging' doit être un tableau");

        $logger = $this->createLogger($params);

        $apiLogging = new ApiLogging();
        $apiLogging->setLogger($logger);
        $apiLogging->setEnabled($enabled);

        if ($enabled) {
            /** @var Configuration $doctrineConfiguration */
            $doctrineConfiguration = $container->get('doctrine.configuration.orm_default');
            $doctrineConfiguration->setSQLLogger($apiLogging);
        }

        return $apiLogging;
    }

    /**
     * @param array $params
     * @return Logger
     */
    private function createLogger(array $params)
    {
        Assert::keyExists($params, 'name', "Clé 'name' introuvable dans la config 'logging'");
        Assert::keyExists($params, 'file_path', "Clé 'file_path' introuvable dans la config 'logging'");
        Assert::keyExists($params, 'max_files', "Clé 'max_files' introuvable dans la config 'logging'");

        $name = $params['name'];
        $filePath = $params['file_path'];
        $maxFiles = $params['max_files'];
        Assert::integerish($maxFiles, "La clé 'max_files' doit correspondre à un entier");

        $formatter = new LineFormatter();
        $formatter->ignoreEmptyContextAndExtra(true);
        $handler = new RotatingFileHandler($filePath, $maxFiles);
        $handler->setFormatter($formatter);
        $logger = new Logger($name);
        $logger->pushHandler($handler);

        return $logger;
    }
}
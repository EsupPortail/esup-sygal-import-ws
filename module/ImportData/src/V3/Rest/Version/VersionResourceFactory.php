<?php

namespace ImportData\V3\Rest\Version;

use Laminas\ServiceManager\ServiceLocatorInterface as ContainerInterface;

class VersionResourceFactory
{
    /**
     * @param ContainerInterface $container
     * @return VersionResource
     * @throws \Psr\Container\ContainerExceptionInterface
     * @throws \Psr\Container\NotFoundExceptionInterface
     */
    public function __invoke(ContainerInterface $container): VersionResource
    {
        $config = $container->get('config');

        $appInfos = $config['unicaen-app']['app_infos'] ?? [];

        return new VersionResource($appInfos);
    }
}

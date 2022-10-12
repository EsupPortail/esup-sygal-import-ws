<?php

namespace ImportData\V1\Rest\Version;

use Laminas\ServiceManager\ServiceLocatorInterface as ContainerInterface;

class VersionResourceFactory
{
    /**
     * @param ContainerInterface $container
     * @return VersionResource
     */
    public function __invoke(ContainerInterface $container)
    {
        $config = $container->get('config');
        $version = isset($config['unicaen-app']['app_infos']['version']) ?
            $config['unicaen-app']['app_infos']['version'] :
            null;

        return new VersionResource($version);
    }
}

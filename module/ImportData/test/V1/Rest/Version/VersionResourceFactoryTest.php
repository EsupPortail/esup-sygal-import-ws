<?php

namespace ImportDataTest\V1\Rest\Version;

use ImportData\V1\Rest\Version\VersionResource;
use PHPUnit\Framework\MockObject\MockObject;
use Laminas\ServiceManager\ServiceLocatorInterface as ContainerInterface;
use ImportData\V1\Rest\Version\VersionResourceFactory;
use PHPUnit\Framework\TestCase;

class VersionResourceFactoryTest extends TestCase
{
    /**
     * @var ContainerInterface|MockObject
     */
    private $container;

    protected function setUp()
    {
        $this->container = $this->createMock(ContainerInterface::class);
    }

    public function testCanConstructResource()
    {
        // le contenu de la config n'importe pas
        $this->container->expects($this->once())->method('get')->with('config');

        $factory = new VersionResourceFactory();
        $instance = $factory->__invoke($this->container);

        $this->assertInstanceOf(VersionResource::class, $instance);
    }
}

<?php

namespace ImportDataTest\V1\Rest\Acteur;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\QueryBuilder;
use ImportData\V1\Rest\Acteur\ActeurFetchAll;
use PHPUnit\Framework\MockObject\MockObject;
use PHPUnit\Framework\TestCase;
use Laminas\ApiTools\Rest\ResourceEvent;

class ActeurFetchAllTest extends TestCase
{
    /** @var ResourceEvent|MockObject */
    private $resourceEvent;
    /** @var QueryBuilder|MockObject */
    private $expectedQb;
    /** @var ActeurFetchAll */
    private $provider;

    protected function setUp()
    {
        $this->resourceEvent = $this->createMock(ResourceEvent::class);

        $this->expectedQb = $this->createMock(QueryBuilder::class);
        $this->expectedQb->expects($this->once())->method('select')->willReturnSelf();

        /** @var EntityManager|MockObject $objectManager */
        $objectManager = $this->createMock(EntityManager::class);
        $objectManager->expects($this->once())->method('createQueryBuilder')->willReturn($this->expectedQb);

        $this->provider = new ActeurFetchAll();
        $this->provider->setObjectManager($objectManager);

    }

    public function testCreateQueryAddsTheseFilterIfParameterIsPresent()
    {
        $this->expectedQb->expects($this->once())->method('andWhere')->with('row.theseId = :theseId')->willReturnSelf();
        $this->expectedQb->expects($this->once())->method('setParameter')->with('theseId', 1234);

        $qb = $this->provider->createQuery($this->resourceEvent, 'EntityClass', ['these_id' => 1234]);

        $this->assertSame($this->expectedQb, $qb);
    }

    public function testCreateQueryDoesNotAddTheseFilterIfParameterIsNotPresent()
    {
        $this->expectedQb->expects($this->never())->method('andWhere');
        $this->expectedQb->expects($this->never())->method('setParameter');

        $qb = $this->provider->createQuery($this->resourceEvent, 'EntityClass', []);

        $this->assertSame($this->expectedQb, $qb);
    }
}

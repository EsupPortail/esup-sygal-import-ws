<?php

namespace ImportDataTest\V1\Query\Provider;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\QueryBuilder;
use ImportData\V1\Query\Provider\FetchAll;
use PHPUnit\Framework\MockObject\MockObject;
use PHPUnit\Framework\TestCase;
use Laminas\ApiTools\Rest\ResourceEvent;

class FetchAllTest extends TestCase
{
    public function testCreateQueryAddsOrderBy()
    {
        /** @var ResourceEvent|MockObject $resourceEvent */
        $resourceEvent = $this->createMock(ResourceEvent::class);

        /** @var MockObject $expectedQb */
        $expectedQb = $this->createMock(QueryBuilder::class);
        $expectedQb->expects($this->once())->method('select')->willReturnSelf();

        /** @var EntityManager|MockObject $objectManager */
        $objectManager = $this->createMock(EntityManager::class);
        $objectManager->expects($this->once())->method('createQueryBuilder')->willReturn($expectedQb);

        $provider = new FetchAll();
        $provider->setObjectManager($objectManager);

        $expectedQb->expects($this->once())->method('orderBy')->with('row.id', 'asc');

        $qb = $provider->createQuery($resourceEvent, 'EntityClass', []);

        $this->assertSame($expectedQb, $qb);
    }
}

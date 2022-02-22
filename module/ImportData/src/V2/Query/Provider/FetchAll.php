<?php

namespace ImportData\V2\Query\Provider;

use Doctrine\ORM\QueryBuilder;
use ZF\Apigility\Doctrine\Server\Query\Provider\DefaultOrm;
use ZF\Rest\ResourceEvent;

class FetchAll extends DefaultOrm
{
    /**
     * @param ResourceEvent $event
     * @param string        $entityClass
     * @param array         $parameters
     * @return QueryBuilder
     */
    public function createQuery(ResourceEvent $event, $entityClass, $parameters)
    {
        /** @var QueryBuilder $qb */
        $qb = parent::createQuery($event, $entityClass, $parameters);

        $qb->orderBy('row.id', 'asc'); // indispensable car les données sont demandées paginées

        return $qb;
    }
}

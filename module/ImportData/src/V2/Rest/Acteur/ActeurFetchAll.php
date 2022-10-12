<?php

namespace ImportData\V2\Rest\Acteur;

use Doctrine\ORM\QueryBuilder;
use ImportData\V2\Query\Provider\FetchAll;
use Laminas\ApiTools\Rest\ResourceEvent;

class ActeurFetchAll extends FetchAll
{
    /**
     * @param ResourceEvent $event
     * @param string        $entityClass
     * @param array         $parameters
     * @return QueryBuilder
     */
    public function createQuery(ResourceEvent $event, $entityClass, $parameters)
    {
        $qb = parent::createQuery($event, $entityClass, $parameters);

        if (isset($parameters['these_id'])) {
            $qb
                ->andWhere('row.theseId = :theseId')
                ->setParameter('theseId', $parameters['these_id']);
        }

        return $qb;
    }
}

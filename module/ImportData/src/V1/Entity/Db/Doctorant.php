<?php

namespace ImportData\V1\Entity\Db;

/**
 * Doctorant
 *
 * @codeCoverageIgnore
 */
class Doctorant
{

    /**
     * @var integer
     */
    protected $id;
    protected $sourceId;
    protected $individuId;

    private $sourceInsertDate;

    /**
     * @var string
     */
    protected $ine;

    /**
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @return mixed
     */
    public function getSourceId()
    {
        return $this->sourceId;
    }

    /**
     * @return mixed
     */
    public function getIndividuId()
    {
        return $this->individuId;
    }

    /**
     * @return string
     */
    public function getIne()
    {
        return $this->ine;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

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
     * @param int $id
     */
    public function setId($id)
    {
        $this->id = $id;
    }

    /**
     * @return mixed
     */
    public function getSourceId()
    {
        return $this->sourceId;
    }

    /**
     * @param mixed $sourceId
     */
    public function setSourceId($sourceId)
    {
        $this->sourceId = $sourceId;
    }

    /**
     * @return mixed
     */
    public function getIndividuId()
    {
        return $this->individuId;
    }

    /**
     * @param mixed $individuId
     */
    public function setIndividuId($individuId)
    {
        $this->individuId = $individuId;
    }

    /**
     * @return string
     */
    public function getIne()
    {
        return $this->ine;
    }
}

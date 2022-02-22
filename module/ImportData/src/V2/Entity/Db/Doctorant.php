<?php

namespace ImportData\V2\Entity\Db;

/**
 * Doctorant
 *
 * @codeCoverageIgnore
 */
class Doctorant
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $individuId;
    private $sourceInsertDate;
    private $ine;

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
    public function getSourceCode()
    {
        return $this->sourceCode;
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

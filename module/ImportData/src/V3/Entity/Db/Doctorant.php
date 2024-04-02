<?php

namespace ImportData\V3\Entity\Db;

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
    private $codeApprenantInSource;

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
     * @return string
     */
    public function getCodeApprenantInSource()
    {
        return $this->codeApprenantInSource;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

<?php

namespace ImportData\V1\Entity\Db;

/**
 * Source
 *
 * @codeCoverageIgnore
 */
class Source
{

    /**
     * @var integer
     */
    protected $id;
    protected $code;
    protected $libelle;
    protected $importable;

    private $sourceInsertDate;

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
    public function getLibelle()
    {
        return $this->libelle;
    }

    /**
     * @return mixed
     */
    public function getImportable()
    {
        return $this->importable;
    }

    /**
     * @return mixed
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

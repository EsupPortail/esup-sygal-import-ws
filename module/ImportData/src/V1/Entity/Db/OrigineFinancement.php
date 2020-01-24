<?php

namespace ImportData\V1\Entity\Db;

/**
 * OrigineFinancement
 *
 * @codeCoverageIgnore
 */
class OrigineFinancement
{
    protected $id;
    protected $sourceId;
    protected $codOfi;
    protected $licOfi;
    protected $libOfi;

    private $sourceInsertDate;

    /**
     * @return mixed
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
    public function getCodOfi()
    {
        return $this->codOfi;
    }

    /**
     * @return mixed
     */
    public function getLicOfi()
    {
        return $this->licOfi;
    }

    /**
     * @return mixed
     */
    public function getLibOfi()
    {
        return $this->libOfi;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

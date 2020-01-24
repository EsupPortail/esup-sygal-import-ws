<?php

namespace ImportData\V1\Entity\Db;

/**
 * Variable
 *
 * @codeCoverageIgnore
 */
class Variable
{
    /**
     * @var integer
     */
    protected $id;
    protected $sourceId;
    protected $libEtablissement;
    protected $libResponsable;
    protected $libTitre;
    protected $dateDebValidite;
    protected $dateFinValidite;

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
    public function getLibEtablissement()
    {
        return $this->libEtablissement;
    }

    /**
     * @return mixed
     */
    public function getLibResponsable()
    {
        return $this->libResponsable;
    }

    /**
     * @return mixed
     */
    public function getLibTitre()
    {
        return $this->libTitre;
    }

    /**
     * @return mixed
     */
    public function getDateDebValidite()
    {
        return $this->dateDebValidite;
    }

    /**
     * @return mixed
     */
    public function getDateFinValidite()
    {
        return $this->dateFinValidite;
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
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

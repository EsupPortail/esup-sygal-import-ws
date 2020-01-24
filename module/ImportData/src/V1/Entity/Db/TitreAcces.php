<?php

namespace ImportData\V1\Entity\Db;

/**
 * TitreAcces
 *
 * @codeCoverageIgnore
 */
class TitreAcces
{
    protected $id;
    protected $sourceId;
    protected $theseId;
    protected $titreAccesInterneExterne;
    protected $libelleTitreAcces;
    protected $typeEtabTitreAcces;
    protected $libelleEtabTitreAcces;
    protected $codeDeptTitreAcces;
    protected $codePaysTitreAcces;

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
    public function getTheseId()
    {
        return $this->theseId;
    }

    /**
     * @return mixed
     */
    public function getTitreAccesInterneExterne()
    {
        return $this->titreAccesInterneExterne;
    }

    /**
     * @return mixed
     */
    public function getLibelleTitreAcces()
    {
        return $this->libelleTitreAcces;
    }

    /**
     * @return mixed
     */
    public function getTypeEtabTitreAcces()
    {
        return $this->typeEtabTitreAcces;
    }

    /**
     * @return mixed
     */
    public function getLibelleEtabTitreAcces()
    {
        return $this->libelleEtabTitreAcces;
    }

    /**
     * @return mixed
     */
    public function getCodeDeptTitreAcces()
    {
        return $this->codeDeptTitreAcces;
    }

    /**
     * @return mixed
     */
    public function getCodePaysTitreAcces()
    {
        return $this->codePaysTitreAcces;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

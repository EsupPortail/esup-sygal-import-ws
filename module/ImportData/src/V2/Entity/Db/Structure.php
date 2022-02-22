<?php

namespace ImportData\V2\Entity\Db;

/**
 * Structure
 *
 * @codeCoverageIgnore
 */
class Structure
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $typeStructureId;
    private $sigle;
    private $libelle;
    private $codePays;
    private $libellePays;
    private $sourceInsertDate;


    /**
     * Get id
     *
     * @return string
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Get sourceCode
     *
     * @return string
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
     * Get typeStructureId
     *
     * @return string
     */
    public function getTypeStructureId()
    {
        return $this->typeStructureId;
    }

    /**
     * Get sigle
     *
     * @return string
     */
    public function getSigle()
    {
        return $this->sigle;
    }

    /**
     * Get libelle
     *
     * @return string
     */
    public function getLibelle()
    {
        return $this->libelle;
    }

    /**
     * Get codePays
     *
     * @return string
     */
    public function getCodePays()
    {
        return $this->codePays;
    }

    /**
     * Get libellePays
     *
     * @return string
     */
    public function getLibellePays()
    {
        return $this->libellePays;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

<?php

namespace ImportData\V1\Entity\Db;

/**
 * Structure
 *
 * @codeCoverageIgnore
 */
class Structure
{
    /**
     * @var string
     */
    private $id;

    /**
     * @var string
     */
    private $sourceId;

    /**
     * @var string
     */
    private $typeStructureId;

    /**
     * @var string
     */
    private $sigle;

    /**
     * @var string
     */
    private $libelle;

    /**
     * @var string
     */
    private $codePays;

    /**
     * @var string
     */
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
     * Get sourceId
     *
     * @return string
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

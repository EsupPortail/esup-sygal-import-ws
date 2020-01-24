<?php

namespace ImportData\V1\Entity\Db;

/**
 * Financement
 *
 * @codeCoverageIgnore
 */
class Financement
{
    protected $id;
    protected $sourceId;
    protected $theseId;
    protected $annee;
    protected $origineFinancementId;
    protected $complementFinancement;
    protected $quotiteFinancement;
    protected $dateDebutFinancement;
    protected $dateFinFinancement;

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
    public function getAnnee()
    {
        return $this->annee;
    }

    /**
     * @return mixed
     */
    public function getOrigineFinancementId()
    {
        return $this->origineFinancementId;
    }

    /**
     * @return mixed
     */
    public function getComplementFinancement()
    {
        return $this->complementFinancement;
    }

    /**
     * @return mixed
     */
    public function getQuotiteFinancement()
    {
        return $this->quotiteFinancement;
    }

    /**
     * @return mixed
     */
    public function getDateDebutFinancement()
    {
        return $this->dateDebutFinancement;
    }

    /**
     * @return mixed
     */
    public function getDateFinFinancement()
    {
        return $this->dateFinFinancement;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

<?php

namespace ImportData\V1\Entity\Db;

/**
 * These
 *
 * @codeCoverageIgnore
 */
class These
{
    private $id;
    private $sourceId;
    private $etatThese;
    private $doctorantId;
    private $codeDiscipline;
    private $libDiscipline;
    private $title;
    private $codeLNG;
    private $datePremiereInsc;
    private $uniteRechId;
    private $ecoleDoctId;
    private $libPaysCotut;
    private $libEtabCotut;
    private $temAvenant;
    private $dateSoutenancePrev;
    private $temSoutenanceAutorisee;
    private $dateSoutenanceAutorisee;
    private $dateSoutenance;
    private $dateConfidFin;
    private $resultat;
    private $etatReporduction;
    private $correctionAutorisee;
    private $dateAbandon;
    private $dateTransfert;

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
    public function getUniteRechId()
    {
        return $this->uniteRechId;
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
    public function getEtatThese()
    {
        return $this->etatThese;
    }

    /**
     * @return mixed
     */
    public function getDoctorantId()
    {
        return $this->doctorantId;
    }

    /**
     * @return mixed
     */
    public function getCodeDiscipline()
    {
        return $this->codeDiscipline;
    }

    /**
     * @return mixed
     */
    public function getLibDiscipline()
    {
        return $this->libDiscipline;
    }

    /**
     * @return mixed
     */
    public function getTitle()
    {
        return $this->title;
    }

    /**
     * @return mixed
     */
    public function getCodeLNG()
    {
        return $this->codeLNG;
    }

    /**
     * @return mixed
     */
    public function getDatePremiereInsc()
    {
        return $this->datePremiereInsc;
    }

    /**
     * @return mixed
     */
    public function getEcoleDoctId()
    {
        return $this->ecoleDoctId;
    }

    /**
     * @return mixed
     */
    public function getLibPaysCotut()
    {
        return $this->libPaysCotut;
    }

    /**
     * @return mixed
     */
    public function getLibEtabCotut()
    {
        return $this->libEtabCotut;
    }

    /**
     * @return mixed
     */
    public function getTemAvenant()
    {
        return $this->temAvenant;
    }

    /**
     * @return mixed
     */
    public function getDateSoutenancePrev()
    {
        return $this->dateSoutenancePrev;
    }

    /**
     * @return mixed
     */
    public function getTemSoutenanceAutorisee()
    {
        return $this->temSoutenanceAutorisee;
    }

    /**
     * @return mixed
     */
    public function getDateSoutenanceAutorisee()
    {
        return $this->dateSoutenanceAutorisee;
    }

    /**
     * @return mixed
     */
    public function getDateSoutenance()
    {
        return $this->dateSoutenance;
    }

    /**
     * @return mixed
     */
    public function getDateConfidFin()
    {
        return $this->dateConfidFin;
    }

    /**
     * @return mixed
     */
    public function getResultat()
    {
        return $this->resultat;
    }

    /**
     * @return mixed
     */
    public function getEtatReporduction()
    {
        return $this->etatReporduction;
    }

    /**
     * @return mixed
     */
    public function getCorrectionAutorisee()
    {
        return $this->correctionAutorisee;
    }

    /**
     * @return mixed
     */
    public function getDateAbandon()
    {
        return $this->dateAbandon;
    }

    /**
     * @return mixed
     */
    public function getDateTransfert()
    {
        return $this->dateTransfert;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

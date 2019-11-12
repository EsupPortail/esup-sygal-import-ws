<?php

namespace ImportData\V1\Entity\Db;

/**
 * These
 *
 * @codeCoverageIgnore
 */
class These
{
    protected $id;
    protected $sourceId;
    protected $etatThese;
    protected $doctorantId;
    protected $codeDiscipline;
    protected $libDiscipline;
    protected $title;
    protected $codeLNG;
    protected $datePremiereInsc;
    protected $uniteRechId;
    protected $ecoleDoctId;
    protected $libPaysCotut;
    protected $libEtabCotut;
    protected $temAvenant;
    protected $dateSoutenancePrev;
    protected $temSoutenanceAutorisee;
    protected $dateSoutenanceAutorisee;
    protected $dateSoutenance;
    protected $dateConfidFin;
    protected $resultat;
    protected $etatReporduction;
    protected $correctionAutorisee;

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
}

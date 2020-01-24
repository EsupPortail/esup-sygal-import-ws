<?php

namespace ImportData\V1\Entity\Db;

/**
 * These
 *
 * @codeCoverageIgnore
 */
class Individu
{

    protected $id;
    protected $sourceId;
    protected $supannId;
    protected $type;
    protected $civilite;
    protected $nomUsuel;
    protected $nomPatronymique;
    protected $prenom1;
    protected $prenom2;
    protected $prenom3;
    protected $email;
    protected $dateNaissance;
    protected $nationalite;

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
     * @return string
     */
    public function getSupannId()
    {
        return $this->supannId;
    }

    /**
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @return mixed
     */
    public function getCivilite()
    {
        return $this->civilite;
    }

    /**
     * @return mixed
     */
    public function getNomUsuel()
    {
        return $this->nomUsuel;
    }

    /**
     * @return mixed
     */
    public function getNomPatronymique()
    {
        return $this->nomPatronymique;
    }

    /**
     * @return mixed
     */
    public function getPrenom1()
    {
        return $this->prenom1;
    }

    /**
     * @return mixed
     */
    public function getPrenom2()
    {
        return $this->prenom2;
    }

    /**
     * @return mixed
     */
    public function getPrenom3()
    {
        return $this->prenom3;
    }

    /**
     * @return mixed
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * @return mixed
     */
    public function getDateNaissance()
    {
        return $this->dateNaissance;
    }

    /**
     * @return mixed
     */
    public function getNationalite()
    {
        return $this->nationalite;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

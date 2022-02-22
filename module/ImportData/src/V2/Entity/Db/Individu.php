<?php

namespace ImportData\V2\Entity\Db;

/**
 * These
 *
 * @codeCoverageIgnore
 */
class Individu
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $supannId;
    private $type;
    private $civilite;
    private $nomUsuel;
    private $nomPatronymique;
    private $prenom1;
    private $prenom2;
    private $prenom3;
    private $email;
    private $dateNaissance;
    private $nationalite;
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

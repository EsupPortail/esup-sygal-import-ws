<?php

namespace ImportData\V2\Entity\Db;

/**
 * Acteur
 *
 * @codeCoverageIgnore
 */
class Acteur
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $theseId;
    private $roleId;
    private $individuId;
    private $acteurEtablissementId;
    private $codeRoleJury;
    private $libRoleJury;
    private $codeQualite;
    private $libQualite;
    private $temoinHDR;
    private $temoinRapport;
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
     * @return mixed
     */
    public function getTheseId()
    {
        return $this->theseId;
    }

    /**
     * @return mixed
     */
    public function getRoleId()
    {
        return $this->roleId;
    }

    /**
     * @return mixed
     */
    public function getIndividuId()
    {
        return $this->individuId;
    }

    /**
     * @return mixed
     */
    public function getActeurEtablissementId()
    {
        return $this->acteurEtablissementId;
    }

    /**
     * return $this;
     * }
     *
     * /**
     * @return mixed
     */
    public function getCodeRoleJury()
    {
        return $this->codeRoleJury;
    }

    /**
     * @return mixed
     */
    public function getLibRoleJury()
    {
        return $this->libRoleJury;
    }

    /**
     * @return mixed
     */
    public function getCodeQualite()
    {
        return $this->codeQualite;
    }

    /**
     * @return mixed
     */
    public function getLibQualite()
    {
        return $this->libQualite;
    }

    /**
     * @return mixed
     */
    public function getTemoinHDR()
    {
        return $this->temoinHDR;
    }

    /**
     * @return mixed
     */
    public function getTemoinRapport()
    {
        return $this->temoinRapport;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

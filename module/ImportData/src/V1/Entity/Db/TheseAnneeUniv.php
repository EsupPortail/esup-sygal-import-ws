<?php

namespace ImportData\V1\Entity\Db;

/**
 * TheseAnneeUniv
 *
 * @codeCoverageIgnore
 */
class TheseAnneeUniv
{
    protected $id;
    protected $sourceId;
    protected $theseId;
    protected $anneeUniv;

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
    public function getAnneeUniv()
    {
        return $this->anneeUniv;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

<?php

namespace ImportData\V3\Entity\Db;

/**
 * TheseAnneeUniv
 *
 * @codeCoverageIgnore
 */
class TheseAnneeUniv
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $theseId;
    private $anneeUniv;
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

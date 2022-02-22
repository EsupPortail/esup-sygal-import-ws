<?php

namespace ImportData\V2\Entity\Db;

/**
 * Role
 *
 * @codeCoverageIgnore
 */
class Role
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $libLongRole;
    private $libCourtRole;
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
    public function getLibLongRole()
    {
        return $this->libLongRole;
    }

    /**
     * @return mixed
     */
    public function getLibCourtRole()
    {
        return $this->libCourtRole;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

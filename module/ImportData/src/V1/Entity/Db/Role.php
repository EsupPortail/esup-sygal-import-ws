<?php

namespace ImportData\V1\Entity\Db;

/**
 * Role
 *
 * @codeCoverageIgnore
 */
class Role
{
    protected $id;
    protected $sourceId;
    protected $libLongRole;
    protected $libCourtRole;

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

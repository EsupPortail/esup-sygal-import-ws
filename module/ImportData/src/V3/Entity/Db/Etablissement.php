<?php

namespace ImportData\V3\Entity\Db;

/**
 * Structure
 *
 * @codeCoverageIgnore
 */
class Etablissement
{
    private $id;
    private $sourceCode;
    private $sourceId;
    private $structureId;
    private $sourceInsertDate;

    /**
     * @return string
     */
    public function getId(): string
    {
        return $this->id;
    }

    /**
     * @return string
     */
    public function getSourceCode(): string
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
    public function getStructureId(): string
    {
        return $this->structureId;
    }

    /**
     * @return mixed
     */
    public function getSourceInsertDate()
    {
        return $this->sourceInsertDate;
    }
}

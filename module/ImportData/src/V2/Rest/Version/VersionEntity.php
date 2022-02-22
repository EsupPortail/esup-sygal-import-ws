<?php

namespace ImportData\V2\Rest\Version;

class VersionEntity
{
    /**
     * @var string Version number, ex: "1.1.0"
     */
    private $id;

    /**
     * VersionEntity constructor.
     *
     * @param string $id Version number, ex: "1.1.0"
     */
    public function __construct($id)
    {
        $this->id = $id;
    }

    /**
     * Returns the version number, ex: "1.1.0".
     *
     * @return string
     */
    public function getId()
    {
        return $this->id;
    }
}

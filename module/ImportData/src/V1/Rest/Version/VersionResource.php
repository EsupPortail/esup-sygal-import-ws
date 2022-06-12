<?php

namespace ImportData\V1\Rest\Version;

use Laminas\ApiTools\ApiProblem\ApiProblem;
use Laminas\ApiTools\Rest\AbstractResourceListener;

class VersionResource extends AbstractResourceListener
{
    const VERSION_INCONNUE = 'Inconnue';

    /**
     * @var string
     */
    private $version;

    /**
     * VersionResource constructor.
     *
     * @param string $version
     */
    public function __construct($version = null)
    {
        $this->version = $version ?: self::VERSION_INCONNUE;
    }

    /**
     * Fetch a resource
     *
     * @param  string $id
     * @return VersionEntity
     */
    public function fetch($id)
    {
        return new VersionEntity($this->version);
    }
}

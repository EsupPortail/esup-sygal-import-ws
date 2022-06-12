<?php

namespace ImportData\V2\Rest\Version;

use Laminas\ApiTools\Rest\AbstractResourceListener;

class VersionResource extends AbstractResourceListener
{
    const INCONNUE = 'Inconnue';

    private array $appInfos;

    /**
     * VersionResource constructor.
     *
     * @param array $appInfos
     */
    public function __construct(array $appInfos)
    {
        $this->appInfos = $appInfos;
    }

    /**
     * Fetch a resource
     *
     * @param  string $id
     * @return VersionEntity
     */
    public function fetch($id): VersionEntity
    {
        return new VersionEntity(
            $this->appInfos['version'] ?: self::INCONNUE,
            $this->appInfos['date'] ?: self::INCONNUE
        );
    }
}

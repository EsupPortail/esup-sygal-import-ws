<?php

namespace ImportData\V3\Rest\Version;

use Laminas\ApiTools\Rest\AbstractResourceListener;

class VersionResource extends AbstractResourceListener
{
    const DEFAULTS = [
        'version' => '?',
        'date' => '?',
    ];

    private array $appInfos;

    /**
     * VersionResource constructor.
     *
     * @param array $appInfos
     */
    public function __construct(array $appInfos)
    {
        $this->appInfos = array_merge(self::DEFAULTS, $appInfos);
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
            $this->appInfos['version'],
            $this->appInfos['date']
        );
    }
}

<?php

namespace ImportData\V2\Rest\Version;

class VersionEntity
{
    private string $id;
    private string $number;
    private string $date;

    /**
     * VersionEntity constructor.
     *
     * @param string $versionNumber Version number, ex: "1.1.0"
     * @param string $versionDate Version date, ex : "11/07/2022"
     */
    public function __construct(string $versionNumber, string $versionDate)
    {
        $this->id = $versionNumber;
        $this->number = $versionNumber;
        $this->date = $versionDate;
    }

    /**
     * @return string Ex : "1.1.0".
     */
    public function getId(): string
    {
        return $this->id;
    }

    /**
     * @return string Ex : "1.1.0".
     */
    public function getNumber(): string
    {
        return $this->number;
    }

    /**
     * @return string Ex : "11/07/2022"
     */
    public function getDate(): string
    {
        return $this->date;
    }
}

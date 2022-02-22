<?php

namespace Application\Service;

use Doctrine\DBAL\ConnectionException;
use Doctrine\DBAL\DBALException;
use Doctrine\ORM\EntityManager;
use RuntimeException;
use Zend\Log\LoggerAwareTrait;

class TableService
{
    use LoggerAwareTrait;

    const DELETE_TEMPLATE = "delete from %s ;";
    const INSERT_TEMPLATE = "insert into %s (%s) select %s from V_%s ;";

    /**
     * @var EntityManager
     */
    private $entityManager;

    /**
     * @var array
     */
    private $servicesToEntityClassesConfig;

    /**
     * @var array
     */
    private $servicesPreSql = [];

    /**
     * Liste des colonnes à exclure lors de la mise à jour des tables sources.
     *
     * @var array
     */
    private $excludedColumnNames = [
        'SOURCE_INSERT_DATE',
    ];

    /**
     * @param EntityManager $entityManager
     */
    public function setEntityManager(EntityManager $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    /**
     * @param array $servicesToEntityClassesConfig
     */
    public function setServicesToEntityClassesConfig(array $servicesToEntityClassesConfig)
    {
        $this->servicesToEntityClassesConfig = $servicesToEntityClassesConfig;
    }

    /**
     * @param array $servicesPreSql
     */
    public function setServicesPreSql(array $servicesPreSql)
    {
        $this->servicesPreSql = $servicesPreSql;
    }

    /**
     * Lance la mise à jour des tables sources pour tous les services.
     */
    public function updateTablesForAllServices()
    {
        $services = array_keys($this->servicesToEntityClassesConfig);

        $this->updateTablesForServices($services);
    }

    /**
     * Lance la mise à jour des tables sources pour les services spécifiés.
     *
     * @param array $services Liste des noms de services dont on veut mettre à jour les tables sources.
     * Exemple : ['structure', 'etablissement']
     */
    public function updateTablesForServices(array $services)
    {
        $conn = $this->entityManager->getConnection();
        $sql = $this->generateSQLUpdatesForServices($services);

        $this->logger->debug("SQL généré : " . $sql);

        $conn->beginTransaction();
        try {
            $conn->executeQuery($sql);
            $conn->commit();
        } catch (DBALException $e) {
            $message = "Erreur lors de la requête SQL de mise à jour des tables";
            try {
                $conn->rollBack();
            } catch (ConnectionException $e) {
                $message .= " et en plus rollback impossible";
                $this->logger->err($message);
                throw new RuntimeException($message, null, $e);
            }
            $this->logger->err($message);
            throw new RuntimeException($message, null, $e);
        }

        $this->logger->info(
            "Les tables sources des services suivants ont été mises à jour avec succès :" . PHP_EOL .
            implode(PHP_EOL, $services)
        );
    }

    /**
     * Génère le SQL permettant de mettre à jour le contenu des tables sources pour les services spécifiés.
     *
     * @param array $services Liste des noms de services dont on veut mettre à jour les tables sources.
     * Exemple : ['structure', 'etablissement']
     *
     * @return string SQL généré, exemple :
     * <pre>
     * begin
     * delete from SYGAL_STRUCTURE ;
     * insert into SYGAL_STRUCTURE (SOURCE_ID, ...) select SOURCE_ID, ... from V_SYGAL_STRUCTURE ;
     * delete from SYGAL_STRUCTURE_V2 ;
     * insert into SYGAL_STRUCTURE_V2 (SOURCE_CODE, ...) select SOURCE_CODE, ... from V_SYGAL_STRUCTURE_V2 ;
     * delete from SYGAL_ETABLISSEMENT
     * insert into SYGAL_ETABLISSEMENT (SOURCE_ID, ...) select SOURCE_ID, ... from V_SYGAL_ETABLISSEMENT ;
     * delete from SYGAL_ETABLISSEMENT_V2 ;
     * insert into SYGAL_ETABLISSEMENT_V2 (SOURCE_CODE, ...) select SOURCE_CODE, ... from V_SYGAL_ETABLISSEMENT_V2 ;
     * end;
     * </pre>
     */
    private function generateSQLUpdatesForServices(array $services): string
    {
        $sqlParts = [];

        $sqlParts[] = 'begin';
        foreach ($services as $service) {
            $sqlParts[] = $this->generateSQLUpdatesForService($service);
        }
        $sqlParts[] = 'end;';

        return implode(PHP_EOL, $sqlParts);
    }

    /**
     * Génère le SQL permettant de mettre à jour le contenu des tables sources pour un service.
     *
     * @param string $service Nom du service dont on veut mettre à jour les tables sources.
     * Exemple : 'structure'
     *
     * @return string SQL généré, exemple :
     * <pre>
     * delete from SYGAL_STRUCTURE ;
     * insert into SYGAL_STRUCTURE (SOURCE_ID, ...) select SOURCE_ID, ... from V_SYGAL_STRUCTURE ;
     * delete from SYGAL_STRUCTURE_V2 ;
     * insert into SYGAL_STRUCTURE_V2 (SOURCE_CODE, ...) select SOURCE_CODE, ... from V_SYGAL_STRUCTURE_V2 ;
     * </pre>
     */
    private function generateSQLUpdatesForService(string $service): string
    {
        $sqlParts = [];

        // SQL à exécuter au préalable ?
        if (isset($this->servicesPreSql[$service])) {
            $sqlParts[] = $this->servicesPreSql[$service];
        }

        $classNames = $this->getEntityClassNamesForService($service);
        // NB : Il y a une classe d'entité Doctrine par version de l'API.

        foreach ($classNames as $className) {
            $metadata = $this->entityManager->getClassMetadata($className);
            $tableName = $metadata->getTableName();
            $columnNames = $metadata->getColumnNames();

            // exclusion éventuelle de certaines colonnes
            $columnNames = array_diff($columnNames, $this->excludedColumnNames);

            $cols = implode(', ', $columnNames);
            $sqlParts[] = sprintf(self::DELETE_TEMPLATE, $tableName);
            $sqlParts[] = sprintf(self::INSERT_TEMPLATE, $tableName, $cols, $cols, $tableName);
        }

        return implode(PHP_EOL, $sqlParts);
    }

    /**
     * Retourne les classes d'entité Doctrine correspondant au service spécifié.
     * NB : Il y a une classe par version de l'API.
     *
     * @param string $service
     * @return array
     */
    private function getEntityClassNamesForService(string $service): array
    {
        if (! isset($this->servicesToEntityClassesConfig[$service])) {
            throw new \LogicException("Service inconnu : '$service'");
        }

        return $this->servicesToEntityClassesConfig[$service];
    }
}

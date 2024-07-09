<?php

namespace Application\Service;

use Doctrine\DBAL\Exception;
use Doctrine\ORM\EntityManager;
use Laminas\Log\LoggerAwareTrait;
use LogicException;
use RuntimeException;
use Webmozart\Assert\Assert;

class TableService
{
    use LoggerAwareTrait;

    const DELETE_TEMPLATE = "delete from %s ;";
    const INSERT_TEMPLATE = "insert into %s (%s) select %s from V_%s ;";

    private EntityManager $entityManager;
    private array $servicesToEntityClassesConfig;
    private array $servicesPreSql = [];

    /**
     * Liste des colonnes à exclure lors de la mise à jour des tables sources.
     */
    private array $excludedColumnNames = [
        'SOURCE_INSERT_DATE',
    ];

    public function setEntityManager(EntityManager $entityManager): void
    {
        $this->entityManager = $entityManager;
    }

    public function setServicesToEntityClassesConfig(array $servicesToEntityClassesConfig): void
    {
        $this->servicesToEntityClassesConfig = $servicesToEntityClassesConfig;
    }

    public function setServicesPreSql(array $servicesPreSql): void
    {
        $this->servicesPreSql = $servicesPreSql;
    }

    /**
     * Lance la mise à jour des tables sources pour tous les services.
     *
     * @param string|null $version Version d'API concernée éventuelle, ex : 'V2'
     */
    public function updateTablesForAllServices(?string $version = null): void
    {
        $services = array_keys($this->servicesToEntityClassesConfig);

        $this->updateTablesForServices($services, $version);
    }

    /**
     * Lance la mise à jour des tables sources pour les services spécifiés.
     *
     * @param array $services Liste des noms de services dont on veut mettre à jour les tables sources.
     * Exemple : ['structure', 'etablissement']
     * @param string|null $version Version d'API concernée éventuelle, ex : 'V2'
     */
    public function updateTablesForServices(array $services, ?string $version = null): void
    {
        $conn = $this->entityManager->getConnection();
        $sql = $this->generateSQLUpdatesForServices($services, $version);

        $this->logger->debug("SQL généré : " . $sql);

        try {
            $conn->beginTransaction();
            $conn->executeQuery($sql);
            $conn->commit();
        } catch (Exception $e) {
            $message = "Erreur lors de la requête SQL de mise à jour des tables";
            try {
                $conn->rollBack();
            } catch (Exception $e) {
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
     * Génère le SQL permettant de màj le contenu des tables sources pour les services et la version spécifiés.
     *
     * @param array $services Liste des noms de services dont on veut mettre à jour les tables sources,
     * ex : ['structure', 'etablissement']
     * @param string|null $version Version d'API concernée éventuelle, ex : 'V2'
     *
     * @return string SQL généré
     */
    private function generateSQLUpdatesForServices(array $services, ?string $version = null): string
    {
        $sqlParts = [];

        $sqlParts[] = 'begin';
        foreach ($services as $service) {
            $sqlParts[] = $this->generateSQLUpdatesForServiceAndVersion($service, $version);
        }
        $sqlParts[] = 'end;';

        return implode(PHP_EOL, $sqlParts);
    }

    /**
     * Génère le SQL permettant de mettre à jour le contenu de la table source pour un service et une version donnés.
     *
     * @param string $service Nom du service dont on veut màj la table source, ex : 'these', 'titre-acces'
     * @param string|null $version Version d'API concernée éventuelle, ex : 'V2'
     *
     * @return string SQL généré, exemple :
     * <pre>
     * delete from SYGAL_STRUCTURE_V2 ;
     * insert into SYGAL_STRUCTURE_V2 (SOURCE_CODE, ...) select SOURCE_CODE, ... from V_SYGAL_STRUCTURE_V2 ;
     * delete from SYGAL_ETABLISSEMENT_V2 ;
     * insert into SYGAL_ETABLISSEMENT_V2 (SOURCE_CODE, ...) select SOURCE_CODE, ... from V_SYGAL_ETABLISSEMENT_V2 ;
     * </pre>
     */
    private function generateSQLUpdatesForServiceAndVersion(string $service, ?string $version = null): string
    {
        $sqlParts = [];

        // SQL à exécuter au préalable ?
        if (isset($this->servicesPreSql[$service])) {
            $sqlParts[] = $this->servicesPreSql[$service];
        }

        $classNames = $this->getEntityClassNamesForServiceAndVersion($service, $version);
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
     * Retourne les classes d'entité Doctrine correspondant au service et à la version spécifiés.
     * NB : Il y a une classe par version de l'API.
     *
     * @param string $service Nom du service, ex : 'these', 'titre-acces'
     * @param string|null $version Version d'API concernée éventuelle, ex : 'V1', 'V2', 'V3'
     *
     * @return array
     */
    private function getEntityClassNamesForServiceAndVersion(string $service, ?string $version = null): array
    {
        if (! isset($this->servicesToEntityClassesConfig[$service])) {
            throw new LogicException("Service inconnu : '$service'");
        }

        if ($version !== null) {
            $classMatchesVersion = fn(string $fqdn) => str_contains($fqdn, sprintf("\\%s\\", $version));
            $entityClasses = array_filter($this->servicesToEntityClassesConfig[$service], $classMatchesVersion);

            Assert::notEmpty($entityClasses, sprintf(
                "Aucune classe d'entité trouvée dans la config pour le service '%s' et la version '%s'.",
                $service,
                $version
            ));
            Assert::count($entityClasses, 1, sprintf(
                "Plus d'1 classe d'entité trouvée dans la config pour le service '%s' et la version '%s'.",
                $service,
                $version
            ));

            return $entityClasses;
        }

        // on prend la dernière ligne, sensée correspondre à la version la plus récente de l'API
        return array_slice($this->servicesToEntityClassesConfig[$service], -1);
    }
}

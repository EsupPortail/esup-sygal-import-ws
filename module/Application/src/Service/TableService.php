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

    /**
     * @var EntityManager
     */
    private $entityManager;

    /**
     * @var array
     */
    private $servicesToEntityClassesConfig;

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
     * Lance la mise à jour des tables sources.
     *
     * @param array|string|null $services Liste éventuelle des noms de services dont on veut mettre à jour
     *                                    les tables sources.
     *                                    Exemple : ['structure','etablissement','unite-recherche','ecole-doctorale']
     */
    public function updateTablesForServices($services = null)
    {
        $conn = $this->entityManager->getConnection();
        $services = (array)$services ?: array_keys($this->servicesToEntityClassesConfig);
        $sql = $this->generateTablesUpdateSQLForServices($services);

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
            implode(PHP_EOL, $services));
    }

    /**
     * Génère le SQL permettant de mettre à jour le contenu des tables sources.
     *
     * @param array|string $services Liste éventuelle des noms de services dont on veut mettre à jour
     *                              les tables sources.
     *                              Exemple : ['structure','etablissement','unite-recherche','ecole-doctorale']
     * @return string SQL généré.
     *                Exemple :
     * <pre>
     * begin
     * delete from SYGAL_STRUCTURE ;
     * insert into SYGAL_STRUCTURE (SOURCE_ID, TYPE_STRUCTURE_ID, SIGLE, LIBELLE, CODE_PAYS, LIBELLE_PAYS, ID) select SOURCE_ID, TYPE_STRUCTURE_ID, SIGLE, LIBELLE, CODE_PAYS, LIBELLE_PAYS, ID from V_SYGAL_STRUCTURE ;
     * delete from SYGAL_ETABLISSEMENT ;
     * insert into SYGAL_ETABLISSEMENT (SOURCE_ID, STRUCTURE_ID, CODE, ID) select SOURCE_ID, STRUCTURE_ID, CODE, ID from V_SYGAL_ETABLISSEMENT ;
     * delete from SYGAL_UNITE_RECH ;
     * insert into SYGAL_UNITE_RECH (SOURCE_ID, STRUCTURE_ID, ID) select SOURCE_ID, STRUCTURE_ID, ID from V_SYGAL_UNITE_RECH ;
     * delete from SYGAL_ECOLE_DOCT ;
     * insert into SYGAL_ECOLE_DOCT (SOURCE_ID, STRUCTURE_ID, ID) select SOURCE_ID, STRUCTURE_ID, ID from V_SYGAL_ECOLE_DOCT ;
     * end;
     * </pre>
     */
    private function generateTablesUpdateSQLForServices(array $services)
    {
        $deleteTemplate = "delete from %s ;";
        $updateTemplate = "insert into %s (%s) select %s from V_%s ;";
        $sqlParts = [];

        $sqlParts[] = 'begin';
        foreach ($services as $service) {
            $className = $this->getEntityClassNameForService($service);

            $metadata = $this->entityManager->getClassMetadata($className);
            $tableName = $metadata->getTableName();
            $columnNames = $metadata->getColumnNames();

            $sqlParts[] = sprintf($deleteTemplate, $tableName);
            $sqlParts[] = sprintf($updateTemplate, $tableName, $cols = implode(', ', $columnNames), $cols, $tableName);
        }
        $sqlParts[] = 'end;';

        $sql = implode(PHP_EOL, $sqlParts);

        return $sql;
    }

    /**
     * @param string $service
     * @return string
     */
    private function getEntityClassNameForService($service)
    {
        $className = $this->servicesToEntityClassesConfig[$service] ?? null;

        if ($className === null) {
            throw new \LogicException("Service inconnu : '$service''");
        }

        return $className;
    }
}
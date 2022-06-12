<?php

namespace ImportData;

use Doctrine\DBAL\Logging\SQLLogger;
use Psr\Log\LoggerAwareTrait;
use Laminas\EventManager\EventInterface;
use Laminas\EventManager\EventManagerInterface;
use Laminas\EventManager\ListenerAggregateInterface;
use Laminas\EventManager\ListenerAggregateTrait;
use Laminas\ApiTools\Doctrine\Server\Event\DoctrineResourceEvent;
use Laminas\ApiTools\ContentNegotiation\Request;
use Laminas\ApiTools\Hal\Plugin\Hal;
use Laminas\ApiTools\Rest\RestController;

class ApiLogging implements ListenerAggregateInterface, SQLLogger
{
    use ListenerAggregateTrait;
    use LoggerAwareTrait;

    /**
     * @var bool
     */
    private $enabled;

    /**
     * @var array
     */
    private $context;

    /**
     * @var float
     */
    private $sqlQuery;

    /**
     * @var float
     */
    private $getListStartTime;

    /**
     * @var float
     */
    private $sqlQueryStartTime;

    /**
     * @var float
     */
    private $renderStartTime;

    /**
     * ApiLogging constructor.
     */
    public function __construct()
    {
        $this->enabled = false;
        $this->context = [];
    }

    /**
     * @param bool $enabled
     * @return self
     */
    public function setEnabled(bool $enabled): self
    {
        $this->enabled = $enabled;

        return $this;
    }

    /**
     * @return bool
     */
    public function isEnabled(): bool
    {
        return $this->enabled;
    }

    /**
     * Ecoute de certains événements inteéressants pour chronométrer certains traitements.
     *
     * NB: Inutile d'écouter les évènements {@see DoctrineResourceEvent::EVENT_FETCH_ALL_PRE} et
     * {@see DoctrineResourceEvent::EVENT_FETCH_ALL_POST} pour mesurer le temps écoulé entre les 2
     * car en réalité les données ne sont réellement fetchée en BDD qu'au moment du parcours du paginator
     * par le plugin {@see Hal::renderCollection()}.
     *
     * @param EventManagerInterface $events
     * @param int $priority
     */
    public function attach(EventManagerInterface $events, $priority = 1)
    {
        if (! $this->isEnabled()) {
            return;
        }

        $events->getSharedManager()->attach(
            RestController::class,
            'getList.pre',
            [$this, 'preGetList']
        );

        $events->getSharedManager()->attach(
            Hal::class,
            'renderCollection',
            [$this, 'preRenderCollection']
        );
        $events->getSharedManager()->attach(
            Hal::class,
            'renderCollection.post',
            [$this, 'postRenderCollection']
        );
    }

    /**
     * Au début de {@see RestController::getList()}.
     *
     * @param EventInterface $e
     */
    public function preGetList(EventInterface $e)
    {
        $restController = $e->getTarget(); /** @var $restController RestController */
        $request = $restController->getRequest(); /** @var $request Request */

        $this->getListStartTime = microtime(true);
        $this->context = [];

        $message = $request->getMethod() . ' ' . $request->getUriString();

        $this->logger->info($message);
    }

    /**
     * Au début de la génération HAL.
     *
     * @param EventInterface $e
     */
    public function preRenderCollection(EventInterface $e)
    {
        $this->renderStartTime = microtime(true);
    }

    /**
     * Avant l'exécution d'une requête SQL.
     *
     * @param string $sql
     * @param array|null $params
     * @param array|null $types
     */
    public function startQuery($sql, array $params = null, array $types = null)
    {
        $this->sqlQuery = $sql;
        $this->sqlQueryStartTime = microtime(true);
    }

    /**
     * Après l'exécution d'une requête SQL.
     */
    public function stopQuery()
    {
        $duration = microtime(true) - $this->sqlQueryStartTime;
        $message = "  [SQL] " . substr($this->sqlQuery, 0, 30) . ' ... ' . substr($this->sqlQuery, -30);

        $this->logger->info($message, [
            'sql_query_duration' => sprintf("%f s", $duration),
        ]);
    }

    /**
     * À la fin de la génération HAL.
     *
     * @param EventInterface $e
     */
    public function postRenderCollection(EventInterface $e)
    {
        $duration = microtime(true) - $this->renderStartTime;
        $this->context['render_duration'] = sprintf("%f s", $duration);

        $totalDuration = microtime(true) - $this->getListStartTime;

        $this->logger->info("  [Render]", ['render_duration' => sprintf("%f s", $duration)]);
        $this->logger->info("  Total: " . sprintf("%f s", $totalDuration));
    }
}

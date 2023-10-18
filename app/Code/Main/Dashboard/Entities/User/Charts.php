<?php
namespace Code\Main\Dashboard\Entities\User;
use Argus;
use Log;
use Environment;
/**
 * User Chart Queries
 *
 * see Title
 *
 * PHP version 5.6+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@gmail.com
 * @since      File available since Release 1.0.0
 */
class Charts extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns information about the charts on a particular page along with additional information.  The page is identified through the namespace, controller, and action URI extracted variables
     *
     * @return iterator
     */
    public function fetchChartData() {
        $namespace  = ($this->getNamespace())   ? $this->getNamespace()     : Argus::_namespace();
        $controller = ($this->getController())  ? $this->getController()    : Argus::_controller();
        $action     = ($this->getAction())      ? $this->getAction()        : Argus::_action();
        $user_id    = ($this->getUserId())      ? $this->getUserId()        : Environment::whoAmI();
        $query = <<<SQL
            SELECT a.*, b.name, b.description, b.resource, c.package, b.namespace AS chart_namespace
              FROM dashboard_user_charts AS a
              LEFT OUTER JOIN dashboard_charts AS b
                ON a.chart_id   = b.`id`
              LEFT OUTER JOIN dashboard_chart_packages AS c
                ON b.package_id = c.id
             WHERE a.namespace  = '{$namespace}'
               AND a.controller = '{$controller}'
               AND a.action     = '{$action}'
               AND a.user_id    = '{$user_id}'
SQL;
        return $this->query($query);
    }
}
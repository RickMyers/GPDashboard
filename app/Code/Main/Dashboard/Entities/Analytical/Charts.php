<?php
namespace Code\Main\Dashboard\Entities\Analytical;
use Argus;
use Log;
use Environment;
/**
 *
 * Dashboard Analytics Queries
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Core
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Charts.html
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
     * Gets the necessary chart information to set up the dashboard analytical charts display
     * 
     * @return iterator
     */
    public function userCharts() {
        $user_id = $this->getUserId() ? $this->getUserId() : Environment::whoAmI();
        $query   = <<<SQL
            SELECT a.*, b.name, b.description, b.resource, c.package, b.namespace AS chart_namespace
              FROM dashboard_analytical_charts AS a
              LEFT OUTER JOIN dashboard_charts AS b
                ON a.chart_id   = b.`id`
              LEFT OUTER JOIN dashboard_chart_packages AS c
                ON b.package_id = c.id
             WHERE a.user_id    = '{$user_id}'                
SQL;
        return $this->query($query);
    }
}
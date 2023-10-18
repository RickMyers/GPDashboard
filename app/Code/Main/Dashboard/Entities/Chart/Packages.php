<?php
namespace Code\Main\Dashboard\Entities\Chart;
use Argus;
use Log;
use Environment;
/**
 *
 * Chart related queries
 *
 * see title
 *
 * PHP version 5.6+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@gmail.com
 * @since      File available since Release 1.0.0
 */
class Packages extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Generates a list of all packages, including the individual charts inside of the package.  Intended for generating drop down boxes
     *
     * @return iterator
     */
    public function inventory() {
        $query = <<<SQL
         SELECT a.*, a.id as chart_id, b.package, b.description
	       FROM dashboard_charts AS a 
	       LEFT OUTER JOIN dashboard_chart_packages AS b
	       ON a.package_id = b.id
	       WHERE a.package_id IN (
	       SELECT DISTINCT chart_package_id FROM dashboard_chart_roles 
	        WHERE role_id IN (SELECT role_id FROM argus_user_roles AS d WHERE user_id = '{$this->getUserId()}'))
	        AND resource IS NOT NULL
                order by package, name
SQL;
        return $this->query($query);
    }
}
<?php
namespace Code\Main\Dashboard\Entities\Installed;
use Argus;
use Log;
use Environment;
/**
 * 
 * Installed Apps related queries
 *
 * See Title
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Rick Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Apps extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets the list of apps a person has installed
     * 
     * @return iterator
     */
    public function installed() {
        $query = <<<SQL
        select a.app_id as id, b.namespace, b.name, b.action, b.setup_uri, b.icon, b.zones, b.description, b.callback, b.arguments, b.period, b.widget, b.render
          from dashboard_installed_apps as a
          left outer join dashboard_available_apps as b
          on a.app_id = b.id
         where a.user_id = '{$this->getUserId()}'                
SQL;
        return $this->query($query);
    }
}
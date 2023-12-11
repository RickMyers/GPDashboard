<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Queries that manage navigation options
 *
 * Manages what navigation options you see on which pages
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Navigation extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * This method examines the page URL and determines which dynamic navigation options are available by the roles that the person has
     *
     * @return iterator
     */
    public function optionsByRole() {
        $ns = Argus::_namespace();
        $cn = Argus::_controller();
        $ac = Argus::_action();
        $query = <<<SQL
            SELECT distinct a.option_id, c.title, c.class, c.method, c.style, c.image, c.image_style
              FROM dashboard_navigation AS a
             INNER JOIN argus_user_roles AS b
                ON a.namespace = '{$ns}'
               AND a.controller = '{$cn}'
               AND a.action = '{$ac}'
               AND a.role_id = b.role_id
               AND b.user_id = {$this->getUserId()}
             INNER JOIN dashboard_navigation_options AS c
               ON a.option_id = c.id
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns navigation options with the name of the role they apply to
     * 
     * @return iterator
     */
    public function options() {
        $opt_clause = ($id = $this->getOptionId()) ? "where option_id = ".$id : "";
        $query = <<<SQL
        SELECT a.*, b.name AS role_name
          FROM dashboard_navigation AS a
           LEFT OUTER JOIN argus_roles AS b
          ON a.role_id = b.id
        {$opt_clause}
SQL;
        return $this->query($query);
    }    
}
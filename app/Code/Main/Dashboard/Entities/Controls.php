<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Dashboard Control Queries
 *
 * Handles dashboard controls queries
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Controls extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets the controls available to me
     * 
     * @return type
     */
    public function availableByMyRoles() {
        $query = <<<SQL
            SELECT distinct c.title, c.icon_class, c.method, c.style 
             FROM argus_user_roles AS ur
             INNER JOIN dashboard_control_roles AS cr
               ON ur.role_id = cr.role_id
             INNER JOIN dashboard_controls AS c
               ON cr.control_id = c.id    
               WHERE ur.user_id = '{$this->getUserId()}'                
SQL;
        return $this->query($query);
    }
}
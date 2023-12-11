<?php
namespace Code\Main\Dashboard\Entities\Alert;
use Argus;
use Log;
use Environment;
/**
 * 
 * Alert methods and queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Roles extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns the alert polls that affect the person who is either passed in or is logged on
     * 
     * @param type $uid
     * @return boolean
     */
    public function myAlerts($uid=false) {
        $results = false;
        if ($uid = $uid ? $uid : Environment::whoAmI()) {
            $query = <<<SQL
                    
                    
SQL;
        }
        return $results;
    }
    
    /**
     * Fetches the alert polls for a particular user id
     * 
     * @param type $user_id
     * @return type
     */
    public function alertsByUserId($user_id=false) {
        $results = false;
        if ($user_id = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : ($this->getId() ? $this->getId() : false))) {
            $query = <<<SQL
                    
                    
SQL;
            $results = $this->query($query);
        }
        return $results;
    }    
    
    /**
     * Gets the alerts for a person with a particular role id
     * 
     * @param type $role_id
     * @return type
     */
    public function alertsByRole($role_id=false) {
        $results = false;
        if ($role_id = ($role_id) ? $role_id : ($this->getId() ? $this->getId() : false)) {
            $query = <<<SQL
                    
                    
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    
    /**
     * Gets the alerts for a person with a particular role name
     * 
     * @param type $role_name
     * @return type
     */
    public function alertsByRoleName($role_name=false) {
        $results = false;
        if ($role_name = ($role_name) ? $role_name : ($this->getRoleName() ? $this->getRoleName() : false)) {
            $query = <<<SQL
                    
                    
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
}
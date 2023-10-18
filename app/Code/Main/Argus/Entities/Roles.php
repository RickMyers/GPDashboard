<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Role Methosd
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Framework
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Roles.html
 * @since      File available since Release 1.0.0
 */
class Roles extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns the numeric representation of given role, or null if role has no numeric representation
     * 
     * @param string $name
     * @return int
     */
    public function getRoleIdByName($name=false) {
        $data = null;
        if ($name = ($name) ? $name : ($this->getName() ? $this->getName() : false)) {
            $data = $this->setName($name)->load(true);
        }
        return $data ? (isset($data['id']) ? $data['id'] : null) : null;
    }
    
    /**
     * Returns a list of the namespaces/modules I have access to
     * 
     * @param int $user_id
     * @return array
     */
    public function authorizations($user_id=false) {
        $authorizations = [];
        $user_id        = $user_id ? $user_id : Environment::whoAmI();
        $query          = <<<SQL
           select id
             from argus_roles
            where id in (SELECT DISTINCT role_id FROM argus_user_roles where user_id = '{$user_id}')
SQL;
        foreach ($this->query($query) as $role) {
            if (isset($role['authorizations'])) {
                $authorizations = array_merge($role['authorizations'],$authorizations);
            }
        }
        return $authorizations;
    }

}
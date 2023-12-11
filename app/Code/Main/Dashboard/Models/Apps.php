<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Dashboard Desktop App Methods
 *
 * See Title
 *
 * PHP version 7.3+
 *
 * @category   Apps
 * @package    Desktop
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.aflacbenefitssolutions.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Apps extends Model
{

    use \Code\Base\Humble\Event\Handler;

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    /**
     * All users with a specific role_id will be given the app on their desktop
     * 
     * @param type $role_id
     * @param type $app_id
     */
    public function grantAccessToApp($role_id=false,$app_id=false) {
       if ($role_id && $app_id) {
           $apps = Argus::getEntity('dashboard/desktop/installed/apps');
           foreach (Argus::getEntity('argus/user/roles')->usersWithRole($role_id) as $user) {
               $apps->reset()->setAppId($app_id)->setUserId($user['user_id'])->setAdded(date("Y-m-d H:i:s"))->save();
           }
       }
    }
    
    /**
     * Takes the serialized array of roles and establishes the relationship between the app and the people with that role
     */
    public function assignAppRoles() {
        $roles  = json_decode($this->getRoles());
        $app_id = $this->getAppId();
        if ($roles && $app_id) {
            $da = Argus::getEntity('dashboard/desktop/app/roles');
            foreach ($roles as $idx => $role_id) {
                $da->reset()->setAppId($app_id)->setRoleId($role_id)->save();
                $this->grantAccessToApp($role_id,$app_id);
            }
        }
        //now we should go through and "install" the app in everyones desktop who has that role
    }
}
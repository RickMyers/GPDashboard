<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**
 *
           ,-.
       ,--' ~.).
     ,'         `.
    ; (((__   __)))
    ;  ( (#) ( (#)
    |   \_/___\_/|
   ,"  ,-'    `__".
  (   ( ._   ____`.)--._        _
   `._ `-.`-' \(`-'  _  `-. _,-' `-/`.
    ,')   `.`._))  ,' `.   `.  ,','  ;
  .'  .     `--'  /     ).   `.      ;
 ;     `-        /     '  )         ;
 \                       ')       ,'
  \                     ,'       ;
   \               `~~~'       ,'
    `.                      _,'
hjw   `.                ,--'
        `-._________,--'

QUACK!
 * Dashboard Desktop Methods
 *
 * Methods for manipulating the desktop portion of the application
 *
 * PHP version 7.3+
 *
 * @category   Logical Model
 * @package    Desktop
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.aflacbenefitssolutions.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Desktop extends Model
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
     * Grants access to a desktop app to a whole class of people by role
     * 
     * @return string
     */
    public function grant() {
        $role     = Argus::getEntity('argus/roles')->setId($role_id = $this->getRoleId())->load();
        $app      = Argus::getEntity('dashboard/desktop/available/apps')->setId($app_id = $this->getAppId())->load();
        $users    = [];
        $message  = "An error occurred, please contact someone from support";
        if ($app_id && $role_id) {
            $access = Argus::getEntity('dashboard/desktop/installed/apps');
            foreach (Argus::getEntity('argus/user/roles')->usersWithRole($role_id) as $user) {
                $users[] = $user;
                $access->reset()->setAppId($app_id)->setUserId($user['user_id'])->setAdded(date('Y-m-d H:i:s'))->save();
            }
            $this->emit('DesktopAppAccessGranted',['Role'=>$role['name'],'Users'=>$users,'Granter'=>Environment::whoAmIReally()]);
            $message = 'Access Granted';
        }
        return $message;
    }

}
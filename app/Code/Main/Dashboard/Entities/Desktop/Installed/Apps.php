<?php
namespace Code\Main\Dashboard\Entities\Desktop\Installed;
use Argus;
use Log;
use Environment;
/**
 *
 * Desktop App related functions and queries
 *
 * Extensions to the basic CRUD features for installed apps
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Core
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Apps.html
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
     * Returns the app information to load the users desktop with 
     * 
     * @param int $user_id (optional)
     * @return iterator
     */
    public function myApps($user_id=false) {
        $results    = [];
        if ($user_id = $user_id ? $user_id : ($this->getUserId() ? $this->getUserId() : false)) {
            $query = <<<SQL
                    select b.*
                      from dashboard_desktop_installed_apps as a
                      left outer join dashboard_desktop_available_apps as b
                       on a.app_id = b.id
                    where a.user_id = '{$user_id}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
}
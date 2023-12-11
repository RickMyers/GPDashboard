<?php
namespace Code\Main\Dashboard\Entities\Available;
use Argus;
use Log;
use Environment;
/**
 *
 * Apps Queries
 *
 * Queries related to Apps on the dashboard
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 3.0.0
 */
class Apps extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    //PCP Reports
    public function getAppIdByName($name) {
        $data = null;
        if ($name = ($name) ? $name : ($this->getName() ? $this->getName() : false)) {
            $data = $this->setName($name)->load(true);
        }
        return $data ? (isset($data['id']) ? $data['id'] : null) : null;        
    }
    
    /**
     * Returns the list of available apps with an indicator as to whether the person has it installed
     *
     * @return iterator
     */
    public function availableAndInstalled() {
        $uid = $this->getUserId();
        $query = <<<SQL
            SELECT a.id, a.name, a.action, a.icon, a.default, a.zones, a.description, b.app_id
              FROM dashboard_available_apps AS a
              INNER JOIN (
		SELECT distinct app_id
		  FROM argus_apps_role_required
		 WHERE role_id IN (SELECT role_id FROM argus_user_roles WHERE user_id = '{$uid}')              
              ) AS c
              ON a.id = c.app_id
              LEFT OUTER JOIN dashboard_installed_apps b
                ON a.id = b.app_id
               AND b.user_id = '{$uid}'
SQL;
        return $this->query($query);
    }

    public function installApps() {
        $appList = json_decode($this->getData(),true);
        $uid = $this->getUserId();
        $app = Argus::getEntity('dashboard/installed_apps');
        foreach ($appList as $app_id => $status) {
            $app->reset();
            $app->setUserId($uid);
            $app->setAppId($app_id);
            if ($status == 'Y') {
                $app->save();
            } else {
                $app->delete(true);
            }
        }
    }
}
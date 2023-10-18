<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Dashboard Roles related methods
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Roles.html
 * @since      File available since Release 1.0.0
 */
class Roles extends Model
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
     * Sets whether a role is allowed to access a module, identified by its namespace
     */
    public function authorize() {
        $role_id    = $this->getRoleId();
        $namespace  = $this->getNamespace();
        $authorize  = $this->getAuthorize();
        if ($role_id && $namespace) {
            $role = Argus::getEntity('argus/roles')->_polyglot('Y')->setId($role_id);
            $attr = $role->load();
            $authorizations = isset($attr['authorizations']) ? $attr['authorizations'] : [];
            $authorizations[$namespace] = ($authorize=='Y');
            $role->reset()->setId($role_id)->setAuthorizations($authorizations)->save();
        }
    }
    
    /**
     * Uses a profile to build the basic dashboard configuration
     * 
     * @param type $user_id
     * @param type $role_id
     */
    public function dashboardConfigure($user_id=false,$role_id=false) {
        $user_id    = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI());
        $role_id    = ($role_id) ? $role_id : ($this->getRoleId() ? $this->getRoleId() : false);
        if ($user_id && $role_id) {
            $role_data  = Argus::getEntity('argus/roles')->setId($role_id)->load();
            $layout     = 'lib/Profiles/'.str_replace([' ','.'],['',''],$role_data['name']).'.xml';
            if (file_exists($layout)) {
                if ($configure = simplexml_load_file($layout)) {
                    if (isset($configure->default->graphs)) {
                        $graph_orm = Argus::getEntity('dashboard/user_charts');
                        foreach ($configure->default->graphs as $graphs) {
                            foreach ($graphs as $graph) {
                                $attr = $graph->attributes();
                                $graph_orm->reset()->setUserId($user_id)->setNamespace($attr->namespace)->setController($attr->controller)->setAction($attr->action)->setLayer($attr->layer)->setChartId($attr->id)->save();
                            }
                        }
                    }
                    if (isset($configure->default->apps)) {
                        $app_orm = Argus::getEntity('dashboard/installed_apps');
                        foreach ($configure->default->apps as $apps) {
                            foreach ($apps as $app) {
                                $attr = $app->attributes();
                                $app_orm->reset()->setUserId($user_id)->setAppId($attr->id)->save();
                            }
                        }
                    }
                    if (isset($configure->desktop->apps)) {
                        $app_orm = Argus::getEntity('dashboard/desktop/installed/apps');
                        foreach ($configure->desktop->apps as $apps) {
                            foreach ($apps as $app) {
                                $attr = $app->attributes();
                                $app_orm->reset()->setUserId($user_id)->setAppId($attr->id)->save();
                            }
                        }
                    }                    
                }
            }
        }
    }

    /**
     * When you assign a person a role, if that role as default apps or a dashboard layout, this routine sets those
     */
    public function dashboardAdjust() {
        $user_id    = $this->getUserId();
        $role_id    = $this->getRoleId();
        $role_data  = Argus::getEntity('argus/roles')->setId($role_id)->load();
        $layout     = 'lib/Profiles/'.str_replace([' ','.'],['',''],$role_data['name']).'.xml';
        if (file_exists($layout)) {
            if ($configure = simplexml_load_file($layout)) {
                if (isset($configure->default->graphs)) {
                    $graph_orm = Argus::getEntity('dashboard/user/charts');
                    foreach ($configure->default->graphs as $graphs) {
                        foreach ($graphs as $graph) {
                            $attr = $graph->attributes();
                            $graph_orm->reset()->setUserId($user_id)->setNamespace($attr->namespace)->setController($attr->controller)->setAction($attr->action)->setLayer($attr->layer)->setChartId($attr->id)->delete(true);
                        }
                    }
                }
                if (isset($configure->default->apps)) {
                    $app_orm = Argus::getEntity('dashboard/installed/apps');
                    foreach ($configure->default->apps as $apps) {
                        foreach ($apps as $app) {
                            $attr = $app->attributes();
                            $app_orm->reset()->setUserId($user_id)->setAppId($attr->id)->delete(true);
                        }
                    }
                }
                if (isset($configure->desktop->apps)) {
                    $app_orm = Argus::getEntity('dashboard/desktop/installed/apps');
                    foreach ($configure->desktop->apps as $apps) {
                        foreach ($apps as $app) {
                            $attr = $app->attributes();
                            $app_orm->reset()->setUserId($user_id)->setAppId($attr->id)->delete(true);
                        }
                    }
                }
                
            }
        }
    }        
}
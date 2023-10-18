<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Online Applications functionality
 *
 * Methods supporting our intake of online applications
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Applications.html
 * @since      File available since Release 1.0.0
 */
class Applications extends Model
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
     * This will attach a Group value to the event for use when adding a member to Aldera
     * 
     * @workflow use(process) configuration(/argus/onlineapps/group)
     * @param type $EVENT
     */
    public function assignGroupId($EVENT=false) {
        if ($EVENT!==false) {
            //@TODO: Check for annual/monthly group value  
            $cfg = $EVENT->fetch();
            if (isset($cfg['monthly_GroupGID'])) {
                $EVENT->update(['GroupGID'=>$cfg['monthly_GroupGID']]);
                
            }
        }
    }
    
    
    /**
     * Will change the status of a local application.
     * 
     *                      ###NOTE###
     * 
     * We were able to reuse the configuration page from the updateEhealthStatus action
     * 
     * @workflow use(process) configuration(/argus/onlineapps/status)
     * @param object $EVENT
     */
    public function setStatus($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['status_source'])) {
                $val = false;
                switch ($cfg['status_source']) {
                    case "value"    :
                        $val    = $cfg['status'];
                        break;
                    case "field"    :
                        $val    = (isset($data[$cfg['field']]) ? $data[$cfg['field']] : false);
                        break;
                    default         :  break;
                }
                $application = isset($data[$cfg['appfield']]) ? $data[$cfg['appfield']] : [];
                if ($val) {
                    $last_action    = (isset($cfg['last_action']) && $cfg['last_action']) ? $cfg['last_action'] : false;
                    $app_id         = $application['application-id'];
                    $app            = Argus::getEntity('argus/online_applications')->setApplicationId($app_id);
                    if (count($d = $app->load(true))) {
                        //comment this out to prevent the app status from changing
                        if ($last_action) {
                            $app->setLastAction($last_action);
                        }
                        $app->setStatus($val)->save();
                    }
                }
            }            
        }
    } 
    
    /**
     * Will check to see if there is a vision rider on the application
     * 
     * @workflow  use(decision) configuration(/argus/onlineapps/visionrider)
     * @param type $EVENT
     * @return boolean
     */
    public function hasVisionRider($EVENT=false) {
        $hasVisionRider = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
        return $hasVisionRider;
    }
}
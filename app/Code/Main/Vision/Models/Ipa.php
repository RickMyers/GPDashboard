<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * IPA Logic
 *
 * Methods for managing IPAs
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Hedis Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Ipa.html
 * @since      File available since Release 1.0.0
 */
class Ipa extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $default_password   = 'argus1234';
    
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
     * Creates a user id for an IPA
     * 
     * @param type $ipa_id
     * @return type
     */
    public function createIpaUserId($ipa_id=false) {
        if ($ipa_id     = ($ipa_id)     ? $ipa_id   : $this->getIpaId()) {
            $user_id = Argus::getEntity('humble/users')->newUser($this->_token(12),MD5($this->default_password));
        }
        return $user_id;
    }

    /**
     * Returns true if the special variable 'location_id' is set in the request meaning that we are trying to log in as a Location/Office and not an IPA
     * 
     * @param type $EVENT
     * @workflow use(DECISION)
     * @return boolean
     */
    public function isLocationIdPresent($EVENT=false) {
        $result     = false;
        if ($EVENT) {
            $data = $EVENT->load();
            $result = (isset($data['location_id']) && $data['location_id']);
        }
        return $result;
    }

    /**
     * Returns true if the special variable 'ipa_id' is set in the request meaning that we are trying to log in as an IPA and not as a general user
     * 
     * @param type $EVENT
     * @workflow use(DECISION)
     * @return boolean
     */
    public function isIpaIdPresent($EVENT=false) {
        $result     = false;
        if ($EVENT) {
            $data = $EVENT->load();
            $result = (isset($data['ipa_id']) && $data['ipa_id']);
        }
        return $result;
    }
    
    /**
     * Attaches to the event information about the IPA
     * 
     * @workflow use(PROCESS) config(/vision/location/attach)
     * @param type $EVENT
     */    
    public function attachLocationInformation($EVENT=false) {
        if ($EVENT) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if ($location = Argus::getEntity('vision/ipa/locations')->setId($data[$cfg['location_id_name']])->load()) {
                if ($location['user_id']) {
                    $account = Argus::getEntity('humble/users')->setUid($location['user_id'])->load(true);
                    $EVENT->update([$cfg['event_field_name'] => $account]);
                    if (!isset($data['user_name'])) {
                        $EVENT->update(['user_name' => $account['user_name']]);
                    }
                    $EVENT->update([
                        'login_page' => '/dashboard/ipa/login'
                    ]);
                }
            }
        }
    }
    
    /**
     * Attaches to the event information about the IPA
     * 
     * @workflow use(PROCESS) config(/vision/ipa/attach)
     * @param type $EVENT
     */
    public function attachIPAInformation($EVENT=false) {
        if ($EVENT) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if ($ipa = Argus::getEntity('vision/ipas')->setId($data[$cfg['ipa_id_name']])->load()) {
                if ($ipa['user_id']) {
                    if ($account = Argus::getEntity('humble/users')->setUid($ipa['user_id'])->load()) {
                        $arr = [
                            $cfg['event_field_name'] => $account,
                            'user_name' => $account['user_name']
                        ];
                        $EVENT->update($arr);
                    }
                }
                $EVENT->update([
                    'login_page' => '/dashboard/ipa/login'
                ]);
            }
        }
    }
    
}
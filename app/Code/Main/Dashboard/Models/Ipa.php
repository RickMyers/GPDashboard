<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * IPA Dashboard Methods
 *
 * see Description
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Ipa.html
 * @since      File available since Release 1.0.0
 */
class Ipa extends Model
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
     * For IPA (Entities), gets the userid associated with the IPA
     * 
     * @workflow use(process) configuration(/dashboard/ipa/userid)
     * 
     * @param type $EVENT
     */
    public function getIPAUserid($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['field']) && $cfg['field']) {
                if ($ipa = Argus::getEntity('vision/ipas')->setId($data['ipa_id'])->load()) {
                    $user = Argus::getEntity('humble/users')->setUid($ipa['user_id'])->load();
                    $EVENT->update([
                        'password' => MD5($data['user_password']),
                        $cfg['field'] => $user['user_name']
                    ]);
                }
            }
        }
    }
    

    
}
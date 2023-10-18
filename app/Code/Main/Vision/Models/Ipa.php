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
 * @author     Richard Myers <rmyers@argusdentalvision.com>
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
}
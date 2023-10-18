<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Import DM List Methods
 *
 * see Title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Import.html
 * @since      File available since Release 1.0.0
 */
class Import extends Model
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
     * 
     */
    public function freedomList($file=false) {
        $ipa        = Argus::getEntity('vision/ipas');
        $locations  = Argus::getEntity('vision/ipa_locations');
        $addresses  = Argus::getEntity('vision/ipa_location_addresses');
        $ipas       = Argus::getEntity('vision/client_ipas');
        if ($file && file_exists($file)) {
            foreach (Argus::getHelper('argus/CSV')->toHashTable($file) as $row) {
                print_r($row);
            }
        }
    }
    
    /**
     * 
     */
    public function careplusList($file=false) {
        
    }
    
    /**
     * 
     */
    public function dhcpList($file=false) {
        
    }
    
    /**
     * 
     */
    public function ultimateList($file=false) {
        
    }
}
<?php
namespace Code\AFLAC\Aldera\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Subscriber related actions
 *
 * A class to add stand alone subscriber to Aldera
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://enicity.com/docs/class-Subscriber.html
 * @since      File available since Release 1.0.0
 */
class Subscriber extends Model
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
    
    
    protected function pullDataFromEvent($EVENT) {
        $data = [];
        
        return $data;
    }
    
    /**
     * 
     * 
     * @return array
     */
    protected function extractDataFromSelf() {
        $this->_RPC(false);
        $data = [
            'first_name'    => $this->getFirstName(),
            'last_name'     => $this->getLastName(),
            'birth_date'    => $this->getBirthDate(),
            'gender'        => $this->getGender(),
            'address_line1' => $this->getAddressLine1(),
            'city'          => $this->getCity(),
            'state'         => $this->getState(),
            'zip_code'      => $this->getZipCode(),
            'smoker'        => $this->getSmoker(),
            'groupGID'      => $this->getGroupGID(),
            'memberID'      => $this->getMemberID(),
            'effectiveDate' => $this->getEffectiveDate(),
            'relationCode'  => $this->getRelationCode()
            
        ];
        $this->_RPC(true);
        return $data;
    }
    
    /**
     * This method will attempt to add a subscriber into Aldera, returning the new members information to the caller.  If this method is invoked
     * by passing an EVENT object, the data for the subscriber is pulled from there.  If no EVENT object is passed, the data is assumed to be 
     * self contained
     * 
     * @param \Code\Base\Core\Event\Object $EVENT
     * @return type
     */
    public function add($EVENT=false) {
        $data = ($EVENT) ? (($EVENT instanceof \Code\Base\Humble\Events\Event) ? $this->pullDataFromEvent($EVENT) : $EVENT) : $this->extractDataFromSelf();
        print_r($data);
        foreach ($data as $field => $val) {
            
            $method = 'set'.$this->underscoreToCamelCase($field,true);
            print($method."\n");
            $this->$method($val);
        }
        return [];
    }

}
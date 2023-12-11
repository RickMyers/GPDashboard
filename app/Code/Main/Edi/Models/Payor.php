<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Payor Model (related to EDI 837 claim processing)
 *
 * see Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Payor.html
 * @since      File available since Release 1.0.0
 */
class Payor extends EDIModel
{

    /**
     * Constructor
     */
    public function __construct() {
        //parent::__construct();
    }

    public function addParameter($var,$val) {
        $this->parameters[$var] = $val;
        return $this;
    }
    
    public function defaults() {
        return [
            'entity_code'               => '2',
            'name'                      => '',
            'id_code'                   => '',
            'street_address'            => '',
            'city'                      => '',
            'state'                     => '',
            'zip_code'                  => ''
        ];
    }
    
    public function name() {
        return 'payor';
    }    
    
    public function create($parameters) {
        $this->parameters                 = $parameters;
        
        return $this;
    }
}
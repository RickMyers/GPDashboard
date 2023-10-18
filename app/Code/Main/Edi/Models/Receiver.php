<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * EDI Receiver Model (related to EDI 837 processing)
 *
 * see Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @since      File available since Release 1.0.0
 */
class Receiver extends EDIModel
{
    
   
    /**
     * Constructor
     */
    public function __construct() {
    }
    
    public function defaults() {
        return [
            'entity_type'       => '2',
            'first_name'        => '',
            'last_name'         => '',
            'middle_name'       => '',
            'organization'      => ''
        ];
    }
    
    public function name() {
        return 'receiver';
    }    
    
    public function create($parameters) {
        $this->parameters                 = $parameters;
        return $this;
    }
}
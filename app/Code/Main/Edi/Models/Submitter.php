<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * EDI Submitter Model (related to EDI processing)
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
class Submitter extends EDIModel
{
    
    /**
     * Constructor
     */
    public function __construct() {
    }

    public function defaults() {
        return [
            'entity_type'           => '2',
            'last_name'             => '',
            'first_name'            => '',
            'middle_name'           => '',
            'identification_code'   => '',
            'organization'          => '',
            'phone_number'          => '',
            'extension'             => '',
            'email' => ''
        ];
    }
    
    public function name() {
        return 'submitter';
    }    
    
    public function create($parameters) {
        $this->parameters                 = $parameters;
        return $this;
    }
}
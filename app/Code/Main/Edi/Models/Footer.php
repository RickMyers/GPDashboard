<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * EDI Footer Model (related to EDI processing)
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
class Footer extends EDIModel
{
    
   
    /**
     * Constructor
     */
    public function __construct() {
    }
    
   
    public function defaults() {
        return [
            'number_of_segments' => '0',
            'transaction_control_number' => '',
            'control_group_number' => '',
            'group_number' => ''
        ];
    }
    
    public function name() {
        return 'footer';
    }    
    
    public function create($parameters) {
        $this->parameters                 = $parameters;
        return $this;
    }
}

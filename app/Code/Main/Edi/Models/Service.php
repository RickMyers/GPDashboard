<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * Services Model (related to EDI 837 claim processing)
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
class Service extends EDIModel
{
    
    private $line_item_control_base = null;
    
    /**
     * Constructor
     */
    public function __construct() {
        $this->line_item_control_base = date('Ymd');
    }
    
    public function parameters() {
        $this->parameters['line_item_control_number'] = $this->parameters['claim_number'].$this->parameters['service_line'];
        return $this->parameters;
    }
    
    public function addParameter($var,$val) {
        $this->parameters[$var] = $val;
        return $this;
    }
    
    public function getParameter($var) {
        return (isset($this->parameters[$var]) ? $this->parameters[$var] : null );
    }
    public function defaults() {
        return [
            'service_line'              => '',
            'procedure_code'            => '',
            'monetary_amount'           => '',
            'line_item_control_number'  => ''
        ];
    }
    
    public function name() {
        return 'service';
    }    
    
    public function create($service_type,$service_line,$parameters) {
        $this->parameters                 = $parameters;
        $this->parameters['service_type'] = 'SV'.$service_type;
        $this->parameters['service_line'] = $service_line;
       
        return $this;
    }
    
}
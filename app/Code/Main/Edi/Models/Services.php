<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * Services Iterator (related to EDI 837 claim processing)
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
class Services extends Model implements \Iterator, \Countable
{
    
    private $position = 0;    //for service lines, we start at 1
    private $services = [];

    /**
     * Constructor
     */
    public function __construct() {
    }

    
    public function count() {
        return count($this->services);
    }
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->services[$this->position];
    }

    public function key() {
        return $this->position+1;
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->services[$this->position]);
    }
    
    public function setLineItemControlBase($base) {
        $this->line_item_control_base = $base;
    }
    
    public function add($service_type,$service_line,$parameters) {
        $this->services[] = $svc =  Argus::getModel('edi/service')->create($service_type,$service_line,$parameters);
        return $svc;
    }
    
    public function getTotal() {
        return $this->total;
    }
    
    public function show() {
        print_r($this->services);
    }    
}
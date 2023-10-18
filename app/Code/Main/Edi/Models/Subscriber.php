<?php
namespace Code\Main\Edi\Models;
/**    
 *
 * Subscriber Model (related to EDI 837 claim processing)
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
class Subscriber extends EDIModel implements \Iterator
{

    private $position   = 0;
    private $claims     = null;
    private $payor      = null;
    
    /**
     * Constructor
     */
    public function __construct() {
    }

    /**
     * Default values embedded into the template
     * 
     * @return type
     */
    public function defaults () {
        return [
            "responsibility"    => '',
            "group_number"     => '',
            "last_name"         => '',
            'first_name'        => '',
            'has_children'      => '1',
            'street_address'    => '',
            'street_address_2'  => '',
            'city'              => '',
            'state'             => '',
            'zip_code'          => ''
        ];
    }    
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->parameters[$this->position];
    }

    public function key() {
        return $this->position;
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->parameters[$this->position]);
    }
    
    public function claims() {
        return $this->claims;
    }
    
    public function addClaims($claims) {
        $this->claims = $claims;
        return $this;
    }
    

    /**
     * The name of this section of the 837
     * 
     * @return string
     */
    public function name() {
        return 'subscriber';
    }
    
    public function payor($payor=false) {
        if ($payor) {
            $this->payor = $payor;
            return $this;
        }
        return $this->payor;
    }
    
    public function create($parameters) {
        $this->parameters = $parameters;
        return $this;
    }
    

}
<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * Providers Iterator (related to EDI 837 claim processing)
 *
 * see Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Providers extends Model implements \Iterator, \Countable
{
   
    private $position = 0;
    private $providers = [];
    
    /**
     * Constructor
     */
    public function __construct() {
    }

    public function count() {
        return count($this->providers);
    }
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->providers[$this->position];
    }

    public function key() {
        return $this->position;
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->providers[$this->position]);
    }
    
    public function providers() {
        return $this->providers;
    }
    
    public function add($parameters) {
        $this->providers[] = $prv = Argus::getModel('edi/provider')->create($parameters);
        return $prv;
    }
    public function show() {
        print_r($this->providers);
    }
   
}
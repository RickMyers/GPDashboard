<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Subscribers Iterator (related to EDI 837 claim processing)
 *
 * see Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Subscribers.html
 * @since      File available since Release 1.0.0
 */
class Subscribers extends Model implements \Iterator, \Countable
{


    private $position = 0;
    private $subscribers = [];
    
    /**
     * Constructor
     */
    public function __construct() {
    }

    public function getClassName() {
        return __CLASS__;
    }

    public function count() {
        return count($this->subscribers);
    }
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->subscribers[$this->position];
    }

    public function key() {
        return $this->position;
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->subscribers[$this->position]);
    }

    public function subscribers() {
        return $this->subscribers;
    }
    
    public function add($parameters,$payor) {
        $this->subscribers[] = $sub = Argus::getModel('edi/subscriber')->create($parameters)->payor(Argus::getModel('edi/payor')->create($payor));
        return $sub;
    }
    
    public function show() {
        print_r($this->subscribers);
    }    
}
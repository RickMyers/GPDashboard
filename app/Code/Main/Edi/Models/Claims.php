<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Claims Iterator (related to EDI 837 claim processing)
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
class Claims extends Model implements \Iterator, \Countable
{

    //when we iterate, we are going to add the position to the claim_number, so it is important to have a 
    //unique claim number base, perhaps datetime like 17040115523000 
    private $position       = 0;
    private $claims         = [];
    private $claim_number   = 0;
    private $salt           = '';
    
    public function __construct() {
        $this->claim_number = ((int)date('ymdHis'));
        $a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $l = strlen($a);
        $this->salt .= substr($a,rand(0,$l-1),1);
        $this->salt .= substr($a,rand(0,$l-1),1);
        $this->salt .= substr($a,rand(0,$l-1),1);
    }
    
    public function count() {
        return count($this->claims);
    }
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->claims[$this->position];
    }

    public function key() {
        $p = $this->claims[$this->position]->parameters();
        return $p['claim_number'];
        //return 'CLM_'.$this->salt.'_'.($this->claim_number+$this->position);
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->claims[$this->position]);
    }
    
    public function add($parameters) {
        //create new service,
        if (!isset($parameters['claim_number'])) {
            $parameters['claim_number'] = 'CLM_'.$this->salt.'_'.($this->claim_number+$this->position);
            //print('CLAIM: '.$parameters['claim_number']."\n");
        }
        $this->claims[] = $clm = Argus::getModel('edi/claim')->create($parameters);
        return $clm;
    }
    
    public function show() {
        print_r($this->claims);
    }    

}
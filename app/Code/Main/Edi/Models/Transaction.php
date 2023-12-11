<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * EDI Transaction Manager
 *
 * Will manage state issues for an EDI Transaction (ST-SE)
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Transaction.html
 * @since      File available since Release 1.0.0
 */
class Transaction extends EDIModel
{

    protected $parameters           = [
        'group_control_number'              => '0000',
        'transaction_control_number'        => '0000',
        'number_of_transactions'            => 0,
        'number_of_segments'                => 1,
        'create_date'                       => false,
        'create_time'                       => false
    ];
    private $name                   = 'transactionstart';
    private $defaults               = [
        
    ];
    private $rows                   = [
        
    ];
    
    /**
     * How many transactions did we process?
     * 
     * @return type
     */
    public function transactions() {
        return $this->parameters['number_of_transactions'];
    }
    
    /**
     * Constructor
     */
    public function __construct() {
        $this->parameters['create_date'] = date('Ymd');
        $this->parameters['create_time'] = date('Hi');
        parent::__construct();
    }

    public function __destruct() {
        //file_put_contents('segments.txt',print_r($this->rows,true));
    }
    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }
    
    /**
     * We are starting a new transaction set so increment the transaction control number and reset the number of segments being tracked
     */
    public function reset() {
        $this->parameters['number_of_segments']             = 1;
        $this->parameters['group_control_number']           = str_pad((string)((int)$this->parameters['group_control_number']+1),6,'0',STR_PAD_LEFT);
        $this->parameters['transaction_control_number']     = str_pad((string)((int)$this->parameters['transaction_control_number']+1),4,'0',STR_PAD_LEFT);
        $this->name                                         = 'transactionstart';
        return $this;
    }
    
    /**
     * We are "accumulating" the number of segments being generated for a particular transaction set
     * 
     * @param string $segments
     * @return string
     */
    public function accumulate($segments='') {
        $ctr = 0;
        foreach (explode('~',$segments) as $seg) {
            $ctr += (trim($seg) ? 1 : 0);
        }
        $this->parameters['number_of_segments'] += $ctr;
        return $segments;
    }
    
    /**
     * Returns the name of the template to use for the end transaction loop and also increments the number of transactions processed
     * 
     * @return $this
     */
    public function close() {
        $this->name = 'transactionend';
        $this->parameters['number_of_transactions']++;
        return $this;
    }
    
    public function name() {
        return $this->name;
    }
    /**
     * There are no defaults but we must return an array
     * 
     * @return array[void]
     */
    public function defaults() {
        return $this->defaults;
    }
}
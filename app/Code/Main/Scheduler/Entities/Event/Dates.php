<?php
namespace Code\Main\Scheduler\Entities\Event;
use Argus;
use Log;
use Environment;
/**
 *
 * Scheduler Event Type Methods
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Types.html
 * @since      File available since Release 1.0.0
 */
class Dates extends \Code\Main\Scheduler\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    
    
    
    
    
    
    
    /**
     * Modify as you see fit
     * 
     * @return CSV
     */
    public function formnormalizer() {
        
        $forms          = $this->fetch();                                       //Get a list of all data                
        $results        = [];                                                   //This will end up being the CSV
        $ctr            = 0;                                                    //We only want the records that meet our condition below
        $columns        = $this->getColumns($forms);                            //Gets the full list of columns, regardless of whether it was set per row
        $someCondition  = true; 
        
        foreach ($forms as $idx => $form) {
            $ctr++;
            foreach ($columns as $column) {
                
                                
                $results[$ctr][$column] = isset($form[$column]) ? $form[$column] : '';  //Now we "normalize" the data, providing a value for each column if that row didn't have it.  Also normalizes the order
                
                
            }
        }
        
        
        return $results;             
    }
    
    private function getColumns($forms) {
        $columns    = [];
        foreach ($forms as $form) {
            foreach ($form as $column => $value) {
                $columns[$column] = $column;
            }
        }
        return $columns;
    }
    
    
    
    
    
}
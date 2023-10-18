<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * XML Utilities
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dental & Vision
 * @version    1.0.0
 * @since      File available since Release 1.0.0
 */
class XML extends Helper
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    public function CSV2XML() {
        
    }
    
    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    private function _recurseXML($items,$itr,$nodeName='item') {
        $xml = '';
        foreach ($items as $key => $val) {
            $key = (is_numeric($key)) ? $nodeName : $key;            

            $xml .= str_repeat("\t",$itr)."<".$key.">";            
            if (is_array($val)) {
                $xml .= "\n".$this->_recurseXML($val,$itr+1,$nodeName);
            } else {
                $xml .= trim($val);
            }
            $xml .= str_repeat("\t",$itr)."</".$key.">\n";
        }
        return $xml;
    }
    
    /**
     * Converts a PHP Array to XML
     * 
     * @param type $arr
     * @param type $root
     * @param type $element
     * @return string
     */
    public function ARRAY2XML($arr=array(),$root="root",$element='element')    {
        $itr = 0;
        $xml = '<?xml version="1.0"?>'."\n";
        $xml .= "<".$root.">\n";
        $xml .= $this->_recurseXML($arr,++$itr,'scan');
        $xml .= "</".$root.">\n";
        return $xml;
    }    
}
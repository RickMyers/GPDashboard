<?php
namespace Code\Clients\Prestige\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Prestige data conversions
 *
 * A set of useful utilities for working with Prestige functionality
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Client
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dental & Vision
 * @version    1.0.0
 * @since      File available since Release 1.0.0
 */
class Data extends Helper
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
    
    /**
     * Modifies the Argus value to match the prestige format and returns the percent that the two match
     * 
     * @param type $prestige
     * @param type $argus
     * @return int
     */
    public function languageNameCompare($prestige=false,$argus=false) {
        $pct = 0;
        if ($prestige && $argus) {
            switch ($argus) {
                case "EN"       :
                    $argus = "ENGLISH";
                    break;
                case "ES"       :
                    $argus = "SPANISH";
                    break;
                case "FR"       :
                    $argus = 'FRENCH';
                    break;
                default         :
                    break;
            }
            $val = similar_text($prestige,$argus,$pct);
        }
        return $pct;
    }
    
    /**
     * Modifies the Argus value to match the prestige format and returns the percent that the two match
     * 
     * @param type $prestige
     * @param type $argus
     * @return int
     */
    public function serviceHoursCompare($prestige,$argus,$utility) {
        $pct = 0;
        $pct = 0;
        if ($prestige && $argus) {
            $d = explode('-',$prestige);
            if (isset($d[0])) {
                $e = explode(':',$d['0']);
                if (strlen($e[0])==1) {
                    $e[0] = '0'.$e[0];
                }
                $d[0] = implode('',$e);
            }
            if (isset($d[1])) {
                $e = explode(':',$d['1']);
                if (strlen($e[0])==1) {
                    $e[0] = '0'.$e[0];
                }
                $d[1] = implode('',$e);
            }
            $prestige = implode('-',$d);
            $argus    = str_replace(['A','P'],['AM','PM'],$argus);
            $val      = similar_text($prestige,$argus,$pct);
        }        
        return $pct;        
    }    
    
    /**
     * Modifies the Argus value to match the prestige format and returns the percent that the two match
     * 
     * @param type $prestige
     * @param type $argus
     * @return int
     */
    public function ageFormatCompare($prestige,$argus,$utility) {
        $pct = 0;
        $val      = similar_text($prestige,$argus,$pct);
        return $pct;        
    }    
}
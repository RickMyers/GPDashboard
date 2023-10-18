<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Date Methods
 *
 * Date related helpers
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dental and Vision
 * @since      File available since Release 1.0.0
 */
class Date extends Helper
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
     * Calculates the age of a person based on the date passed in compared to a second date or the current date.
     * 
     * @param type $date
     * @return type
     */
    public function age($date=false,$compare_date='NOW') {
        $age = "Unknown";
        if ($date) {
            $now = new \DateTime($compare_date);
            $age = $now->diff(new \DateTime($date))->format('%y');
        }
        return ($age==0) ? 1 : $age;
    }
    
    public function yearsBetween($date1=false,$date2=false) {
        $diff = false;
        if ($date1 && $date2) {
            $diff = $this->age($date1,$date2);
        }
        return $diff;
    }
    
    public function daysBetween($date1=false,$date2=false) {
        $days_between = false;
        if ($date1 && $date2) {
            $now = new \DateTime($date1);
            $days_between = $now->diff(new \DateTime($date2))->format('%d');
        }
        return $days_between;
    }
    
    public function monthsBetween($date1=false,$date2=false) {
        $months_between = false;
        if ($date1 && $date2) {
            $now = new \DateTime($date1);
            $months_between = $now->diff(new \DateTime($date2))->format('%m');
        }
        return $months_between;
    }
    
}
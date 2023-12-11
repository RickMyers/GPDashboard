<?php
namespace Code\Main\Vision\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * General Functions For NPIs
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Dashboard
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Npi extends Helper
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
    
    public function is_set($haystack,$needle) {
        return isset($haystack[$needle]);
    }
    
    /**
     * This is just a helper function for some Twig templating, since they don't seem to have such a simple function baked in
     * 
     * @param type $haystack
     * @param type $needle
     * @return array
     */
    public function node($haystack=false,$needle=false) {
        return isset($haystack[$needle]) ? $haystack[$needle] : [];
    }

}
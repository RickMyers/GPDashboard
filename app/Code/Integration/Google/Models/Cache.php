<?php
namespace Code\Integration\Google\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * API Manager
 *
 * A class to manage the cache of google addresses
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Rick Myers <rmyers@aflac.com>
 */
class Cache extends Model
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

    public function locationData($address=false) {
        $results = '{}';
        if ($address = $address ? $address : ($this->getAddress() ? $this->getAddress() : false)) {
            $key = MD5(strtoupper(str_replace(' ','',$address)));
            $orm = Argus::getEntity('google/cache');
            if ($results = $orm->setKey($key)->load(true)) {
                $results = $results['cache'];
            } else {
                if ($results = $this->geocodeLocation()) {
                   $orm->reset()->setKey($key)->setCache($results)->save();     //save a copy 
                }
                $a = 1;
            }
        }
        return $results;
    }
}
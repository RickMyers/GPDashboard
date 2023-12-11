<?php
namespace Code\Integration\USPS\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Call & Cache Manager
 *
 * Manages the USPS API using a cache
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Integration
 * @author     Rick Myers <rmyers@aflac.com>
 */
class Bulk extends Model
{

    private $throttleTimeout    = 2;  //measured in seconds
    private $address            = [
        'list' => [],
        'current' => []
    ];
    
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
     * Transfers the parameters that were passed into the request builder helper to be used in shaping the XML that is sent to the USPS API
     * 
     * @return object
     */
    // private function prepRequestBuilder() {
    //     $rb = Argus::getHelper('usps/requestBuilder');
    //     foreach ($this->_data as $field => $value) {
    //         $method = 'set'.$this->underscoreToCamelCase($field,true);
    //         $rb->$method($value);
    //     }
    //     return $rb;
    // }
    private function prepRequestBuilder() {
        $rb = Argus::getHelper('usps/bulkRequestBuilder');
        foreach ($this->_data as $field => $value) {
            $method = 'set'.$this->underscoreToCamelCase($field,true);
            $rb->$method($value);
        }
        return $rb;
    }

    /**
     * Builds the id, which is an MD5 token, based on all segments of the address, even if they weren't passed in
     * 
     * @return string
     */
    protected function buildCacheId($id='') {
        $id .= ','.$this->getAddress1() ?? '';
        $id .= ','.$this->getAddress2() ?? '';
        $id .= ','.$this->getCity() ?? '';
        $id .= ','.$this->getState() ?? '';
        $id .= ','.$this->getZipcode() ?? '';
        return MD5(strtoupper($id));
    }

    /**
     * Attempts to return a cached version of an address
     * 
     * @param type $id
     * @return type
     */
    protected function checkCache($id) {
        $result = Argus::getEntity('argus/cache')->setCacheId($id)->load(true);
        $this->address['list'][$this->address['current']]['cache'] = $result ? 'Y' : 'N';
        return $result ? $result['cache'] : null;
    }
    
    /**
     * Caches the response from USPS along with an MD5 token of the address
     * 
     * @param type $id
     * @param type $value
     * @return type
     */
    protected function setCache($id=false,$value=false) {
        if ($id && $value) {
            Argus::getEntity('argus/cache')->setCacheId($id)->setCache($value)->save();
        }
        return $value;
    }
    // [{"address1":"4120 Browndeer Circle","address2":"","city":"Las Vegas","state":"NV","zipcode":"","cache":""},{"address1":"12718 Ridge Road","address2":"","city":"West Springfield","state":"PA","zipcode":"","cache":""},{"address1":"6684 26TH ST N","address2":"","city":"SAINT PETERSBURG","state":"FL","zipcode":"","cache":""}]
    public function bulkAddressVerify() {
        $helper = Argus::getHelper('usps/BulkRequestBuilder');
        $xml = $helper->verifyAddressRequest($this->getAddresses());
        return $this->setXML($xml)->verifyAddress();
    }
    
    public function bulkLookupZipCode() {
        $helper = Argus::getHelper('usps/BulkRequestBuilder');
        $xml = $helper->zipcodeLookupRequest($this->getAddresses());
        return $this->setXML($xml)->zipCodeLookup();
    }
    
    public function bulkLookupCityState() {
        $helper = Argus::getHelper('usps/BulkRequestBuilder');
        $xml = $helper->cityStateLookupRequest($this->getAddresses());
        return $this->setXML($xml)->cityStateLookup();
    }
    
    public function throttle($results=false) {
        sleep($this->throttleTimeout);
        return $results;
    }
    /**
     * Relay for the USPS API
     * 
     * @return XML
     */
    public function addressVerify() {
        return $result = $this->checkCache($id = $this->buildCacheId('bulk-verify')) ? $result : $this->throttle($this->setCache($id,$this->setXML(($this->prepRequestBuilder())->verifyAddressRequest())->verifyAddress()));
    }

    /**
     * Relay for the USPS API
     * 
     * @return XML
     */
    public function lookupZipCode() {
        return ($result = $this->checkCache($id = $this->buildCacheId('bulk-zipcode'))) ? $result : $this->throttle($this->setCache($id,$this->setXML(($this->prepRequestBuilder())->zipcodeLookupRequest())->zipCodeLookup()));        
    }

    /**
     * Relay for the USPS API
     * 
     * @return XML
     */
    public function lookupCityState() {
        return $result = $this->checkCache($id = $this->buildCacheId('bulk-citystate')) ? $result : $this->throttle($this->setCache($id,$this->setXML(($this->prepRequestBuilder())->cityStateLookupRequest())->cityStateLookup()));                
    }    
}
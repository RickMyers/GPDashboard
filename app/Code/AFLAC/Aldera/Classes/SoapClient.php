<?php
namespace Code\AFLAC\Aldera\Classes;
use Argus;
use Log;
use Environment;
/**
 * 
 * A soap client subclass
 *
 * For special processing
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://enicity.com/license.txt
 * @version    1.0.0
 * @link       https://enicity.com/docs/class-SoapClient.html
 * @since      File available since Release 1.0.0
 */
class SoapClient extends \SoapClient
{
    public function __construct() {
        
    }
    
    public function init($parm1,$parm2) {
        parent::__construct($parm1,$parm2);
        return $this;
    }
    
    public function __doRequest($request, $location, $action, $version, $one_way = 0) {
        // Add code to inspect/dissect/debug/adjust the XML given in $request here

        // Uncomment the following line, if you actually want to do the request
        return parent::__doRequest($request, $location, $action, $version, $one_way);
    }
}
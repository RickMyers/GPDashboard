<?php
namespace Code\Main\Vision\Entities\Ipa\Location;
use Argus;
use Log;
use Environment;
/**
 *
 * IPA Location Addresses DAO
 *
 * Queries involving IPA Locations
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Addresses.html
 * @since      File available since Release 1.0.0
 */
class Addresses extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns a list of available offices related to a particular IPA
     * 
     * @return Iterator
     */
    public function listAddresses() {
        $result = [];
        if ($location_id = $this->getLocationId()) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select id as `value`, address as `text`
                  from vision_ipa_location_addresses
                 where location_id = '{$location_id}' 
                 order by `text`
SQL;
            $result = $this->query($query);
        }
        return $result;
    }        
    
}
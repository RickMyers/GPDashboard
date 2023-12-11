<?php
namespace Code\Main\Vision\Entities\Address;
use Argus;
use Log;
use Environment;
/**
 *
 * Location NPI Queries
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Npis.html
 * @since      File available since Release 1.0.0
 */
class Npis extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     * 
     * @param int $address_id
     * @return iterator
     */
    public function listNpis($address_id=false) {
        $result = [];
        if ($address_id = ($address_id) ? $address_id : ($this->getAddressId() ? $this->getAddressId() : false) ) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select id as `value`, npi as `text`
                  from vision_address_npis
                 where address_id = '{$address_id}' 
                 order by `text`                    
SQL;
            $result = $this->query($query);
        }
        return $result;
    }
    
    /**
     * This returns information about locations that have more than one NPI and is used for data cleanup
     * 
     * @return iterator
     */
    public function multipleNpisPerLocation() {
        $query = <<<SQL
            SELECT f.ipa, d.location_id, e.location, c.address_id, d.address, c.npi
              FROM
                (SELECT a.address_id, npi
                  FROM 
                        (SELECT address_id, COUNT(*) AS cnt
                          FROM vision_address_npis
                         GROUP BY address_id
                        HAVING cnt > 1) AS a
                 LEFT OUTER JOIN vision_address_npis AS b
                  ON a.address_id = b.address_id) AS c
                 LEFT OUTER JOIN vision_ipa_location_addresses AS d
                   ON c.address_id = d.id
                 LEFT OUTER JOIN vision_ipa_locations AS e
                   ON d.location_id = e.id
                 LEFT OUTER JOIN vision_ipas AS f
                   ON e.ipa_id = f.id                
SQL;
        return $this->query($query);
    }

    /**
     * Removes NPIs that have no longer are associated to an address
     * 
     * @return boolean
     */
    public function removeOrphanedNpis() {
        $query = <<<SQL
            DELETE FROM vision_address_npis WHERE id IN 
            (SELECT id FROM (SELECT a.id
              FROM vision_address_npis AS a
              LEFT OUTER JOIN vision_ipa_location_addresses AS b
                ON a.address_id = b.id
              WHERE address IS NULL) AS b)                
SQL;
        return $this->query($query);
    }
    
    public function addressesWithOnlyOneNPI() {
        $query = <<<SQL
                
SQL;
        return $this->query();
    }
}
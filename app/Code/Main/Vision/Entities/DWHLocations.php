<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * MS SQL Addresses DAO
 *
 * Locations really....
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-Present Jarvis Project
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Locations.html
 * @since      File available since Release 1.0.0
 */
class DWHLocations extends \Code\Main\Argus\Entities\MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Formats the address element returned by Aldera to one that we store in the Dashboard
     * 
     * @param array $addr
     * @return string
     */
    public function formatAddress($addr) {
        return $addr['Address_1'].", ".(trim($addr['Address_2']) ? $addr['Address_2'].", " : "").$addr['City'].', '.$addr['State'].', '.$addr['Zip_code'];
    }
    
    /**
     * Looks for a partial address by zip code and part of the main address line
     * 
     * @param string $text
     * @param string $zip
     * @return Iterator
     */
    public function searchFor($text=false,$zip=false,$alt_text=false) {
        $results = [];
        if ($text && $zip) {
            $alt_clause = $alt_text ? " and Address_2 like '{$alt_text}%'" : "";
            $query = <<<SQL
                Select 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,'') Address_2,
                       City,
                       State,
                       replace(Zip_Code,'-','') Zip_code,
                       isnull(County,'') County,
                       max(location_gid) Location_gid
                from [ArgusApp].dbo.Locations with (nolock)
                where  
                       record_status = 'A'
                       and Zip_Code like '{$zip}%'
                       and Address_1 like '{$text}%'
                       {$alt_clause}
                group by 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,''),
                       City,
                       State,
                       replace(Zip_Code,'-',''),
                       isnull(County,'') 
                order by
                       Zip_Code,
                       Address_1,
                       Address_2,
                       City,
                       State
SQL;
            $results = $this->query($query)->toArray();
        }
        return $results;
    }
    
    public function updateLocalCache($state=false) {
        if ($state) {
            $query = <<<SQL
                Select 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,'') Address_2,
                       City,
                       State,
                       replace(Zip_Code,'-','') Zip_code,
                       isnull(County,'') County,
                       max(location_gid) Location_gid
                from [ArgusApp].dbo.Locations with (nolock)
                where  
                       record_status = 'A'
                       and State = '{$state}'
                group by 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,''),
                       City,
                       State,
                       replace(Zip_Code,'-',''),
                       isnull(County,'') 
                order by
                       Zip_Code,
                       Address_1,
                       Address_2,
                       City,
                       State
SQL;
            $address = Argus::getEntity('argus/aldera_locations');
            foreach ($this->query($query) as $location) {
                $zipCode    = $location['Zip_code'];
                $zip        = substr($zipCode,0,5);
                $plus_four  = substr($zipCode,5);
                $id = $address->reset()->setAddress_1($location['Address_1'])->setAddress_2($location['Address_2'])->setCity($location['City'])->setState($location['State'])->setZipCode($zip)->setZipPlusFour($plus_four)->setCounty($location['County'])->save()."\n";
                if (((int)$id % 100) === 0) {
                    print($id."\n");
                }
            };
        }
        return $this;
    }
    
    /**
     * Returns a list of all valid addresses in Aldera
     * 
     * @return iterator
     */
    public function fetch($useKeys=false) {
        $query = <<<SQL
            Select 
                   Location_ID,
                   Address_1,
                   isnull(Address_2,'') Address_2,
                   City,
                   State,
                   replace(Zip_Code,'-','') Zip_code,
                   isnull(County,'') County,
                   max(location_gid) Location_gid
            from [ArgusApp].dbo.Locations with (nolock)
            where  
                   record_status = 'A'
                   and State = 'FL'
            group by 
                   Location_ID,
                   Address_1,
                   isnull(Address_2,''),
                   City,
                   State,
                   replace(Zip_Code,'-',''),
                   isnull(County,'') 
            order by
                   Zip_Code,
                   Address_1,
                   Address_2,
                   City,
                   State
SQL;
        return $this->query($query);
    }
    
    /**
     * Takes an address and tries to match it to an address in Aldera. We are accessing MS SQL Server here.
     * 
     * @return Boolean
     */
    public function validLocation($address=false) {
        $valid = false;
        if ($address) {
            $query = <<<SQL
                Select 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,'') Address_2,
                       City,
                       State,
                       replace(Zip_Code,'-','') Zip_code,
                       isnull(County,'') County,
                       max(location_gid) Location_gid
                from [ArgusApp].dbo.Locations with (nolock)
                where  
                       record_status = 'A'
                group by 
                       Location_ID,
                       Address_1,
                       isnull(Address_2,''),
                       City,
                       State,
                       replace(Zip_Code,'-',''),
                       isnull(County,'') 
                order by
                       Zip_Code,
                       Address_1,
                       Address_2,
                       City,
                       State
SQL;
            $result = $this->query($query);
        }
        return $valid;
    }
}
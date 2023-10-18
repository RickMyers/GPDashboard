<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Provider Search
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Application
 * @author     Rick Myers rick@humbleprogramming.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Providers.html
 * @since      File available since Release 1.0.0
 */
class Providers extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Performs a search for providers within a radius to a zip code
     * 
     * @return iterator
     */
    public function search($field=false,$text=false) {
        $coord_clause = ""; $dist_clause = "";
        if (($distance = $this->getDistance()) && ($zip_code = $this->getZipCode())) {
            $location     = json_decode(Argus::getModel('google/api')->setAddress($zip_code)->geocodeLocation(),true);
            $dist_clause  = ' having distance <= '.$distance;            
            $coord_clause = <<<SQL
                    ,ROUND(( 3959 *
                    
                    ACOS(
                        COS( RADIANS( {$location['results'][0]['geometry']['location']['lat']} ) ) *
                        COS( RADIANS( latitude ) ) *
                        COS(
                            RADIANS( longitude ) - RADIANS( {$location['results'][0]['geometry']['location']['lng']} )
                        ) +
                        SIN(RADIANS({$location['results'][0]['geometry']['location']['lat']})) *
                        SIN(RADIANS(latitude))
                    )
                ),2) AS distance                     
SQL;
        }
        $affiliation_clause         = ($this->getAffiliation()) ? " and plan_affiliation = '".$this->getAffiliation()."' " : "";
        $specialty_clause           = ($this->getSpecialty())   ? " and specialty = '".$this->getSpecialty()."' " : "";
        $query = <<<SQL
            select *
                {$coord_clause}
              from `argus_providers`
            where id is not null
            {$affiliation_clause}
            {$specialty_clause}
            {$dist_clause}
SQL;
        return $this->query($query);
    }    
}
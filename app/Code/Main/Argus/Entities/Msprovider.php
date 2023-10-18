<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * MS Provider Search
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Utility
 * @package    Application
 * @author     Rick Myers rick@humbleprogramming.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Msprovider.html
 * @since      File available since Release 1.0.0
 */
class Msprovider extends MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     * @return type
     */
    public function search() {
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
            select top 5 * from 
            [vm-win-p-dwh].[DWH].dbo.Web_Providers    
            where ProviderId is not null
                {$affiliation_clause}
                {$specialty_clause}

SQL;
        return $this->query($query);
    }
    
}
<?php
namespace Code\Main\Vision\Entities\Ipa;
use Argus;
use Log;
use Environment;
/**
 *
 * Client IPA Offices DAO
 *
 * Queries related to working with Vision clients and their IPAs
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Locations.html
 * @since      File available since Release 1.0.0
 */
class Locations extends \Code\Main\Vision\Entities\Entity
{

    private $role_id = false;
    private $config  = false;
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    
    /**
     * Returns a list of available offices related to a particular IPA, this is formatted for a drop down menu
     * 
     * @return Iterator
     */
    public function listOffices() {
        $result = [];
        if ($ipa_id = $this->getIpaId()) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select id as `value`, location as `text`
                  from vision_ipa_locations
                 where ipa_id = '{$ipa_id}' 
                 order by `text`
SQL;
            $result = $this->query($query);
        }
        return $result;
    }

    /**
     * Returns a list of active locations, optionally those only attached to a certain ipa_id
     * 
     * @param int $ipa_id
     * @return iterator
     */
    public function active($ipa_id=false) {
        $ipa_clause = '';
        if ($ipa_id = ($ipa_id) ? $ipa_id : (($this->getIpaId()) ? $this->getIpaId() : false)) {
            $ipa_clause = " and b.ipa_id = '".$ipa_id."' ";
        }
        $query = <<<SQL
            SELECT b.*
              FROM vision_ipas AS a
              LEFT OUTER JOIN vision_ipa_locations AS b
              ON a.id = b.ipa_id
              WHERE a.legacy != 'Y'
                {$ipa_clause}
SQL;
        return $this->query($query);
    }
    
    /**
     * Will register a location by creating an account (user_id) for it and setting it up
     * 
     * @param type $location_id
     * @param type $location
     */
    public function register($location_id=false,$location=false) {
        $location_id = ($location_id) ? $location_id : ($this->getLocationId() ? $this->getLocationId() : false);
        $location    = ($location)    ? $location : ($this->getLocation() ? $this->getLocation() : false);
        if (!$this->role_id) {
            $this->role_id = Argus::getEntity('argus/roles')->getRoleIdByName('Location');
        }
        if (!$this->config) {
            $this->config = Argus::getModel('argus/roles');
        }
        if ($location_id && $location) {
            if ($user_id = Argus::getEntity('humble/users')->setSalt($salt = $this->_token(16))->setPassword(crypt(MD5('argus1234'),$salt))->setUserName($this->_token(12))->setResetPasswordToken($this->_token(8))->save()) {
                Argus::getEntity('humble/user/identification')->setId($user_id)->setLastName($location)->setLocationId($location_id)->save();
                $this->reset()->setId($location_id)->setUserId($user_id)->save();
                $this->config->dashboardConfigure($user_id,$this->role_id);
            }
        }
        return $this;
    }
    
    /**
     * Returns the forms that are missing the location ID and thus would be lost from Business Office portals
     * 
     * @return iterator
     */
    public function missing() {
        $query = <<<SQL
        SELECT * 
          FROM vision_consultation_forms 
         WHERE (location_id IS NULL OR location_id = '' OR location_id = 0) 
           AND `status` IN ('C','I','R','A','S');           
SQL;
        return $this->query($query);
    }
    
    
    public function healthPlans() {
        $hp = [];
        if ($location_id = $location_id ? $location_id : ($this->getLocationId() ? $this->getLocationId() : false)) {
            foreach (Argus::getEntity('vision/consultation/forms')->setLocationId($location_id)->fetch() as $form) {
                $hp[$form['client_id']] = $form['screening_client'];
            }
            asort($hp);
        }
        return $hp;
    }
    
    /**
     * Returns a list of the physicians at a particular location
     * 
     * @param int $location_id
     * @return array
     */
    public function physicians($location_id=false) {
        $pcps = [];
        if ($location_id = $location_id ? $location_id : ($this->getLocationId() ? $this->getLocationId() : false)) {
            foreach (Argus::getEntity('vision/consultation/forms')->setLocationId($location_id)->fetch() as $form) {
                $pcps[$form['physician_npi_combo']] = $form['primary_doctor_combo'];
            }
            asort($pcps);
        }
        return $pcps;
    }
    
    
    /**
     * Returns the names of the IPA/Office relation
     * 
     * @param int $location_id
     * @return array
     */
    public function info($location_id=false) {
        $user_id     = $this->getUserId() ? $this->getUserId() : false;
        $location_id = $location_id ? $location_id : ($this->getLocationId() ? $this->getLocationId() : false);
        $loc_clause  = $location_id ? " a.id = '".$location_id."' " : "";
        $usr_clause  = $user_id     ? " a.user_id = '".$user_id."' " : "";
        $query = <<<SQL
            select b.ipa, a.location, b.id as ipa_id, a.id as location_id
              from vision_ipa_locations as a
              left outer join vision_ipas as b
                on a.ipa_id = b.id
             where {$loc_clause} {$usr_clause}
SQL;
        return $this->query($query)->toArray()[0];

    }
    
    /**
     * Returns a list of locations associated to an IPA
     * 
     * @param type $ipa_id
     * @return type
     */
    public function ipaLocations($ipa_id=false) {
        $result = [];
        if ($ipa_id = $ipa_id ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : false)) {
            $query = <<<SQL
                    select a.id, a.location, b.address
                      from vision_ipa_locations as a
                      left outer join vision_ipa_location_addresses as b
                        on a.id = b.location_id
                     where a.ipa_id = '{$ipa_id}'
SQL;
            $result = $this->query($query);
        }
        return $result;
    }    
}
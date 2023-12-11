<?php
namespace Code\Main\Dental\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Hygenist related queries
 *
 * This "entity" is in fact just a place to store adhoc queries relating
 * to dental hygenists
 *
 * PHP version 7.0
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Hygenists extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Gets the list of hygenists currently involved in a call
     * 
     * @return iterator
     */
    public function status() {
        $today = date('Y-m-d');
        $role  = 'HEDIS Hygenist';
        $query = <<<SQL
               SELECT a.*, COALESCE(b.active_calls,0) AS active_calls FROM
               (SELECT id AS user_id, first_name, last_name, use_preferred_name, preferred_name, gender, date_of_birth
                 FROM humble_user_identification  
                 WHERE id IN (SELECT user_id FROM argus_user_roles WHERE role_id IN (SELECT id FROM argus_roles WHERE `name` = '{$role}'))) AS a
                 LEFT OUTER JOIN
                 (SELECT assignee, COUNT(id) AS active_calls FROM dental_contact_call_schedule
                  WHERE in_progress = 'Y'
                  GROUP BY assignee) AS b
                  ON a.user_id = b.assignee                
SQL;
                 
        return $this->query($query);
    }
    
    
    
   
    
    
    
    

}
<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Consultation Form Queries
 *
 * Compound and Complex Queries pertaining to the forms we use for remote
 * vision consultations
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Members extends \Code\Main\Vision\Entities\Entity
{

    private $formData = [];
    
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
    public function peoplefind() {
        //SELECT * FROM vision_members
        $query = <<<SQL
            SELECT a.id AS `id`, (Case when a.member_number is null then '' else a.member_number end) AS member_number, CONCAT((CASE WHEN a.last_name IS NULL THEN '' ELSE a.last_name END),', ',(CASE WHEN a.first_name IS NULL THEN '' ELSE a.first_name END)) AS member_name, (CASE WHEN a.date_of_birth IS NULL THEN '' ELSE a.date_of_birth END) AS date_of_birth, (CASE WHEN a.gender IS NULL THEN '' ELSE a.gender END) as gender, (CASE WHEN c.address IS NULL THEN '' ELSE c.address END) AS address , (CASE WHEN d.client IS NULL THEN '' ELSE d.client END) AS `client`
              FROM vision_members AS a
              LEFT OUTER JOIN vision_member_addresses AS b
                ON b.member_id=a.id
              LEFT OUTER JOIN vision_addresses AS c
                ON b.address_id=c.id
              LEFT OUTER JOIN vision_clients AS d
                ON a.health_plan_id=d.id
             where (a.first_name is not null
                or a.last_name is not null)
SQL;
        return $this->query($query);
        
    }
    
    /**
     * 
     * 
     * @return iterator
     */
    public function search($field = false, $text = false) {
        $health_plan_data   = Argus::getEntity('vision/clients')->setClient($this->getHealthPlan())->load(true);
        $results            = [];
        $search             = $this->getSearch();
        $phonetic           = metaphone($search);
        if ($health_plan_id     = isset($health_plan_data['id']) ? $health_plan_data['id'] : false) {
            $query = <<<SQL
                SELECT first_name, last_name, date_of_birth, member_number, gender, address, city, state, zip_code
                  FROM vision_members AS a
                  LEFT OUTER JOIN vision_member_addresses AS b
                    ON a.id = b.member_id
                  LEFT OUTER JOIN vision_addresses AS c
                    ON b.address_id = c.id
                 WHERE health_plan_id = '{$health_plan_id}'
                   AND (a.first_name LIKE '{$search}%' OR a.last_name LIKE '{$search}%' OR phonetic_token_1 LIKE '{$phonetic}%' OR phonetic_token_2 LIKE '{$phonetic}%')                    
SQL;
            $results = $this->query($query);
            $rs = $results->toArray();
        }
        return $results;
        
    }
    
    /**
     * 
     * @return type
     */
    public function persontest() {
        
        $results = [];
        $member_id = $this->getMemberId();
        //if ($member_id = $this->getMemberId()) {
            $query = <<<SQL
            SELECT b.*
              FROM vision_members AS b 
             WHERE b.id = '{$member_id}'
            
SQL;
            
            //$results = $this->with('scheduler/events')->on('event_id')->query($query);
            $results = $this->query($query);
            
            
        //}
        return $results;
    }
    
    ////////////////////////delete after use
    
    
    
    
    public function personfind() {
        
        $theid=$_GET['theid'];
        
         $query = <<<SQL
             SELECT a.*, a.id AS `id`, (Case when a.member_number is null then '' else a.member_number end) AS member_number, CONCAT((CASE WHEN a.last_name IS NULL THEN '' ELSE a.last_name END),', ',(CASE WHEN a.first_name IS NULL THEN '' ELSE a.first_name END)) AS member_name, (CASE WHEN a.date_of_birth IS NULL THEN '' ELSE a.date_of_birth END) AS date_of_birth, (CASE WHEN a.gender IS NULL THEN '' ELSE a.gender END) as gender, (CASE WHEN c.address IS NULL THEN '' ELSE c.address END) AS address , (CASE WHEN d.client IS NULL THEN '' ELSE d.client END) AS `client`
                FROM vision_members AS a
                Left outer JOIN vision_member_addresses AS b
                 ON b.member_id=a.id
                 Left outer JOIN vision_addresses AS c
                 ON b.address_id=c.id
                Left outer JOIN vision_clients AS d
                 ON a.health_plan_id=d.id
              where a.id= {$theid}
              
                
SQL;
      
        return $this->query($query);
    
    }
    
    
    public function personsearch() {
        
        $searchitem=$_GET['searchvalue'];
        
         $query = <<<SQL
             SELECT *, a.id AS `id`, (Case when a.member_number is null then '' else a.member_number end) AS member_number, CONCAT((CASE WHEN a.last_name IS NULL THEN '' ELSE a.last_name END),', ',(CASE WHEN a.first_name IS NULL THEN '' ELSE a.first_name END)) AS member_name, (CASE WHEN a.date_of_birth IS NULL THEN '' ELSE a.date_of_birth END) AS date_of_birth, (CASE WHEN a.gender IS NULL THEN '' ELSE a.gender END) as gender, (CASE WHEN c.address IS NULL THEN '' ELSE c.address END) AS address , (CASE WHEN d.client IS NULL THEN '' ELSE d.client END) AS `client`
                FROM vision_members AS a
                LEFT OUTER JOIN vision_member_addresses AS b
                 ON b.member_id=a.id
                 LEFT OUTER JOIN vision_addresses AS c
                 ON b.address_id=c.id
                LEFT OUTER JOIN vision_clients AS d
                 ON a.health_plan_id=d.id
              where a.last_name like '%{$searchitem}%'
              or a.first_name like '%{$searchitem}%'
              or c.address like '%{$searchitem}%'
              or d.client like '%{$searchitem}%'  
              or a.member_number like '%{$searchitem}%' 
SQL;
         
        
        
        return $this->query($query);
    
    }
    
    /**
     * Modify as you see fit
     * 
     * @return CSV
     */
    public function formnormalizer() {
        $theid= $this->getId();        
        $forms          = $this->fetch();                                       //Get a list of all data
        $results        = [];                                                   //This will end up being the CSV
        $ctr            = 0;                                                    //We only want the records that meet our condition below
        $columns        = $this->getColumns($forms);                            //Gets the full list of columns, regardless of whether it was set per row
        $someCondition  = true; 
        
        foreach ($forms as $idx => $form) {
            $ctr++;
            $spline=false;
            foreach ($columns as $column) {
                
                if($theid=='' ){
                    
                }
                else{
                    if($column=='id'){
                        if($form[$column]==$theid){
                            $spline=true;
                        }
                       
                    }
                }
                //else if( $theid==$ctr){                
                    
                //}
                
                $results[$ctr][$column] = isset($form[$column]) ? $form[$column] : '';  //Now we "normalize" the data, providing a value for each column if that row didn't have it.  Also normalizes the order
                
                
            }
            if($spline){
                $bb=$results[$ctr];
                return $bb;
                        
            }
        }
        
        
        return $results;             
    }
    
    
    
    
    /**
     * Because of the variable columns per row, we need to get a list of all columns across our dataset
     */
    private function getColumns($forms) {
        $columns    = [];
        foreach ($forms as $form) {
            foreach ($form as $column => $value) {
                $columns[$column] = $column;
            }
        }
        return $columns;
    }
    
}
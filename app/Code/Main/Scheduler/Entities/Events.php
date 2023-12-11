<?php
namespace Code\Main\Scheduler\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Scheduler Event Actions
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Events.html
 * @since      File available since Release 1.0.0
 */
class Events extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     */
    public function eventsByRoles() {
        $date = date('Y-m-d',strtotime(($this->getMm()+1).'/'.$this->getDd().'/'.$this->getYyyy()));
        $this->setFormattedDate(date('m/d/Y',strtotime($date)));
        //what was I doing here again?
    }
    
    /**
     * Multi-function query to return a users event list, optionally by a single date, a month, or a year range
     * 
     * @param type $user_id
     * @return iterator
     */
    public function listMyEvents($user_id=false) {
        $results = [];
        $iam         = Environment::whoAmI();
        $roles       = Argus::getEntity('argus/user/roles');
        $user_id     = (!($roles->userHasRole('PCP Staff',$iam) || $roles->userHasRole('O.D.',$iam) || $roles->userHasRole('System Administrator',$iam) || $roles->userHasRole('Scheduler'))) ? $iam : false;
        $user_id     = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : false);
        $user_clause = ($user_id) ? " and a.user_id = '{$user_id}' " : "";
        $date_clause = ($this->getDate()) ? " and c.date = '".$this->getDate()."' " : "";
        $mm          = ($this->getMm()) ? $this->getMm() : false;
        $mm          = (strlen($mm)===1) ? '0'.$mm : $mm;
        $yyyy        = ($this->getYyyy()) ? $this->getYyyy() : false;
        $mm_clause   = ($mm && $yyyy) ? " and (c.date between '".$yyyy."-".$mm."-01' and '".$yyyy."-".$mm."-31') " : "";
        $yyyy_clause = (!$mm && $yyyy) ? " and (c.date between '".$yyyy."-01-01' and '".$yyyy."-12-31') " : "";
        if ($user_id = ($user_id) ? $user_id : (($this->getUserId()) ? $this->getUserId() : ($this->getId() ? $this->getId() : Environment::whoAmI()))) {
            $query = <<<SQL
                SELECT distinct a.event_id,
                        b.id, b.event_type_id, b.start_date, b.end_date, b.start_time, b.end_time,
                        c.date,
                        d.namespace, d.type,
                        e.participants
                  FROM scheduler_event_participants AS a
                  LEFT OUTER JOIN scheduler_events AS b
                    ON a.event_id = b.id
                  LEFT OUTER JOIN scheduler_event_dates AS c
                    ON b.id = c.event_id
                  LEFT OUTER JOIN scheduler_event_types AS d
                    ON b.event_type_id = d.id
                  left outer join (
                    SELECT c.event_id, GROUP_CONCAT(participant) AS participants FROM 
                    (SELECT a.event_id, CONCAT(b.first_name,' ',b.last_name) AS participant 
                      FROM scheduler_event_participants AS a
                      LEFT OUTER JOIN humble_user_identification AS b
                        ON a.user_id = b.id) AS c
                        GROUP BY c.event_id                    
                    ) as e
                  on a.event_id = e.event_id
                 WHERE a.id is not null
                   {$user_clause}
                   {$date_clause}
                   {$mm_clause}
                   {$yyyy_clause}
SQL;
             $results = $this->_normalize(true)->with('scheduler/events')->on('event_id')->query($query);
        }
        return $results;
    }

    /**
     * Same as above query but now looks across all users
     * 
     * @param type $user_id
     * @return type
     */
    public function listAllEvents($user_id=false) {
        $results = [];
        $date_clause = ($this->getDate()) ? " and c.date = '".$this->getDate()."' " : "";
        $mm          = ($this->getMm()) ? $this->getMm() : false;
        $mm          = (strlen($mm)===1) ? '0'.$mm : $mm;
        $yyyy        = ($this->getYyyy()) ? $this->getYyyy() : false;
        $mm_clause   = ($mm && $yyyy) ? " and (c.date between '".$yyyy."-".$mm."-01' and '".$yyyy."-".$mm."-31') " : "";
        $yyyy_clause = (!$mm && $yyyy) ? " and (c.date between '".$yyyy."-01-01' and '".$yyyy."-12-31') " : "";
        $user_id     = ($user_id) ? $user_id : (($this->getUserId()) ? $this->getUserId() : ($this->getId() ? $this->getId() : false));
        $user_clause = ($user_id) ? "and a.user_id = '{$user_id}' " : "";
        $query = <<<SQL
                SELECT distinct a.event_id,
                        b.id, b.event_type_id, b.start_date, b.end_date, b.start_time, b.end_time,
                        c.date,
                        d.namespace, d.type,
                        e.participants
                  FROM scheduler_event_participants AS a
                  LEFT OUTER JOIN scheduler_events AS b
                    ON a.event_id = b.id
                  LEFT OUTER JOIN scheduler_event_dates AS c
                    ON b.id = c.event_id
                  LEFT OUTER JOIN scheduler_event_types AS d
                    ON b.event_type_id = d.id
                  left outer join (
                    SELECT c.event_id, GROUP_CONCAT(participant) AS participants FROM 
                    (SELECT a.event_id, CONCAT(b.first_name,' ',b.last_name) AS participant 
                      FROM scheduler_event_participants AS a
                      LEFT OUTER JOIN humble_user_identification AS b
                        ON a.user_id = b.id) AS c
                        GROUP BY c.event_id                    
                    ) as e
                  on a.event_id = e.event_id
                 WHERE a.id is not null
                {$user_clause}
                {$date_clause}
                {$mm_clause}
                {$yyyy_clause}
SQL;
        return $this->_normalize(true)->with('scheduler/events')->on('event_id')->query($query);
    }
    
    /**
     * 
     * @return type
     */
    public function listMatchingCriteria() {
        $date_clause    = $this->getYear();                                     //this is required
        $date_clause    .= ($this->getMonth()) ? '-'.$this->getMonth() : '';
        $query = <<<SQL
            SELECT  a.event_id, a.user_id, 
                    b.id, b.event_type_id, b.start_date, b.end_date, b.start_time, b.end_time,
                    c.date,
                    d.namespace, d.type
              FROM scheduler_event_participants AS a
              LEFT OUTER JOIN scheduler_events AS b
                ON a.event_id = b.id
              LEFT OUTER JOIN scheduler_event_dates AS c
                ON b.id = c.event_id
              LEFT OUTER JOIN scheduler_event_types AS d
                ON b.event_type_id = d.id
             WHERE a.user_id = '{$user_id}'   
               {$date_clause}
SQL;
        return $this->_normalize(true)->with('scheduler/events')->on('event_id')->query($query);        
             
    }
    
    /**
     * Combines several event fields into one with the intent of using this in a drop down menu
     * 
     * '['.date('m/d/Y',strtotime($row['start_date'])).'-'.date('m/d/Y',strtotime($row['end_date'])).'] '.$row['ipa_id_combo'].' @ '.$row['location_id_combo']
     * 
     * @return array
     */
    public function review() {
        $result = [];
        $year   = $this->getYear();
        $query = <<<SQL
           select * from scheduler_events where start_date >= '{$year}-01-01' and start_date <= '{$year}-12-31' and active = 'Y'
SQL;
        if ($results = $this->query($query)) {
            foreach ($results as $row) {
                $result[] = [
                    'id' => $row['id'],
                    'event' => '['.date('m/d/Y',strtotime($row['start_date'])).'] - '.$row['id'].' - '.$row['ipa_id_combo'].' @ '.$row['location_id_combo'],
                    'title' => $row['address_id_combo']
                ];
            }
            $results->set($result);
        }
        return $results;
    }
    
    public function details($id=false) {
        $results = [];
        $id = (($id) ? $id : ($this->getId() ? $this->getId() : ($this->getEventId() ? $this->getEventId() : false))) ;
        if ($id) {
            $query = <<<SQL
            SELECT a.*,
                    b.`type`, b.namespace,
                    CONCAT(c.last_name,', ',c.first_name) AS schedule_by, a.modified AS scheduled_on
              FROM scheduler_events AS a
              LEFT OUTER JOIN scheduler_event_types AS b
                ON a.event_type_id = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.user_id = c.id
             WHERE a.id = '{$id}'
SQL;
             $results = $this->with('scheduler/events')->on('id')->query($query);
             if (count($results)) {
                 $results = $results->toArray()[0];
             }
        }
        return $results;
        
    }
    
    

    
    public function correlateEventsToForms() {
        $query = <<<SQL
SELECT DISTINCT b.screening_client as HealthPlan, event_id as id, event_address, '' AS 'Billable'
 FROM argus_claims AS a
 LEFT OUTER JOIN vision_consultation_forms AS b
   ON a.form_id = b.id
 LEFT OUTER JOIN scheduler_events AS c
   ON b.event_id = c.id
WHERE a.provider_id = 23
 AND event_id IS NOT NULL                
                
                
SQL;
        return $this->query($query);
    }
    public function npifind() {
        $thedateform=Argus::getEntity('scheduler/event_dates')->formnormalizer();
        $theeventform=Argus::getEntity('scheduler/events')->formnormalizer();
        $results= $this-> combinefunction($thedateform,$theeventform);
        return $results;
    }
    
    
    public function spnpifind() {
        
        $theid=$_GET['theid'];
        
        $thedateform=Argus::getEntity('scheduler/event_dates')->setId($theid)->formnormalizer();
        $theeventform=Argus::getEntity('scheduler/events')->formnormalizer();
        $results= $this-> combinefunction($thedateform,$theeventform,$theid);
        $resultstwo=json_encode($results);
        return $resultstwo;
    }
    
    
    public function combinefunction($thedateform,$theeventform, $findid='' ){
        $result=[];
        
        foreach ($thedateform as $form) {
            $temp=[];
            $temp['id']=isset($form['id']) ? $form['id'] : '';
            $temp['date']=isset($form['date']) ? $form['date'] : '';
            $temp['event_id']=isset($form['event_id']) ? $form['event_id'] : '';
            
            if(isset($form['event_id'])){
                $theinfo=[];
                $theinfo= $this-> addressfinder($form['event_id'],$theeventform);  
              //$theaddress= $this-> addressfinder($form['event_id'],$theeventform);  
              $temp['address']=isset($theinfo['address']) ? $theinfo['address'] : '';
              $temp['business_name']=isset($theinfo['business_name']) ? $theinfo['business_name'] : '';              
              $temp['health_plan']=isset($theinfo['health_plan']) ? $theinfo['health_plan'] : '';
              
              if(isset($theinfo['scanorscreen'])){$temp['scanorscreen']=$theinfo['scanorscreen']; }
              else{$temp['scanorscreen']='';}
            }
            else{
            $temp['address']='';
            
            }
            if($findid=='' || $findid==$form['id']){                
                $result[]=$temp;
                if($findid==$form['id']){                    
                    return $result;                    
                }
            }
        }
        return $result;
    }
    
    
    
    
    
    public function addressfinder($theid,$addressform){
        $theaddress=[];
        
        foreach ($addressform as $form) {
        
            if($form['id']==$theid){
                $testhere=true;
                $theaddress['address']=isset($form['screening_location']) ? $form['screening_location'] : '';
                $theaddress['business_name']=isset($form['business_name']) ? $form['business_name'] : '';
                $theaddress['health_plan']=isset($form['health_plan']) ? $form['health_plan'] : '';
                
                if(isset($form['screening_od']) && $form['screening_od']!='' ){$theaddress['scanorscreen']='screen';}
                if(isset($form['screening_technician']) && $form['screening_technician']!='' ){$theaddress['scanorscreen']='scan';}
                else{$theaddress['scanorscreen']='';}
                
                break;
            }
            
            
        }
        
        
        
        return $theaddress;
    }
    
    
    
   //
    
    /**
     * Modify as you see fit
     * 
     * @return CSV
     */
    public function formnormalizer() {
        
        $forms          = $this->fetch();                                       //Get a list of all data                
        $results        = [];                                                   //This will end up being the CSV
        $ctr            = 0;                                                    //We only want the records that meet our condition below
        $columns        = $this->getColumns($forms);                            //Gets the full list of columns, regardless of whether it was set per row
        $someCondition  = true; 
        
        foreach ($forms as $idx => $form) {
            $ctr++;
            foreach ($columns as $column) {
                
                                
                $results[$ctr][$column] = isset($form[$column]) ? $form[$column] : '';  //Now we "normalize" the data, providing a value for each column if that row didn't have it.  Also normalizes the order
                
                
            }
        }
        
        
        return $results;             
    }
    
    private function getColumns($forms) {
        $columns    = [];
        foreach ($forms as $form) {
            foreach ($form as $column => $value) {
                $columns[$column] = $column;
            }
        }
        return $columns;
    }
    
    
    
    
    
    
    
    
    
    public function diddobatch() {
        $theid=$_GET['eventid'];

        $query = <<<SQL
        SELECT *               
          FROM scheduler_events 
         WHERE id = {$theid}
SQL;
         $results = $this->query($query);
             
        return $results;
        
    }
    
    public function seteventbatch() {
        $theid=$_GET['eventid'];

        $query = <<<SQL
        UPDATE scheduler_events SET didmakebatch='Y' WHERE id={$theid}
SQL;
         $results = $this->query($query);
             
        return $results;
        
    }
    
    
    
    
    
    public function gettechequipod() {
        $theid= $this->getId();

        $query = <<<SQL
           select * from scheduler_events where id={$theid}
SQL;
         $results = $this->query($query);
          
        return $results;
        
    }
    
}
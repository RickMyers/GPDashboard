<?php
namespace Code\Main\Dental\Entities\Campaign;
use Argus;
use Log;
use Environment;
/**
 *
 * Campaign Result Queries
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Results extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns the number of calls that
     *
     * @return int
     */
    public function campaignContactsCompleted() {
        $query = <<<SQL
         SELECT COUNT(id) AS completed_contacts
              FROM dental_contact_call_schedule as a
             WHERE status in ('D','C')
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
            
       $results = $this->query($query)->toArray();
       return (isset($results[0]) ? $results[0]['completed_contacts'] : 0);
    }

    /**
     * Returns the number of calls that
     *
     * @return int
     */
    public function campaignContactsDeclined() {
        $query = <<<SQL
         SELECT COUNT(id) AS declined_contacts
              FROM dental_campaign_results as a
             WHERE counseling_completed = 'N'
               AND requested_appointment = 'N'
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
            
       //$results = $this->query($query)->toArray();
        $results = [];
        return (isset($results[0]) ? $results[0]['declined_contacts'] : 0);
    }

    /**
     * Returns the names and ID of the participants requesting counseling
     *
     * @return iterator
     */
    public function currentRequestingAppointment() {
        $assignee_clause = ($this->getAssignee()) ? " AND c.assignee = '".$this->getAssignee()."'" : "";
        $query = <<<SQL
             SELECT a.*, a.member_id, a.member_id, c.first_name, c.last_name, c.date_of_birth, b.assignee
               FROM dental_campaign_results AS a
               LEFT OUTER JOIN dental_contact_call_schedule AS b
                 ON a.contact_id = b.id
               LEFT OUTER JOIN dental_members AS c
                 ON a.member_id = c.member_id
              WHERE a.requested_appointment = 'Y'
             {$assignee_clause}
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
        return $this->query($query);
    }

    /**
     * Generates a quick run down of the active campaign
     * 
     * @return iterator
     */
    public function snapshot() {
        
        
        
        $query = <<<SQL
        SELECT 'Total Members Processed' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
          LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id      
         WHERE a.campaign_id = '{$this->getCampaignId()}'
         UNION
        SELECT 'Total Contacts Processed' AS `title`, COUNT(DISTINCT contact_id) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.campaign_id = '{$this->getCampaignId()}'
         UNION 
        SELECT 'Nutritional Counselings' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'Y'
           AND a.campaign_id = '{$this->getCampaignId()}'
         UNION
        SELECT 'Refused Counselings' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'N' 
           AND a.campaign_id = '{$this->getCampaignId()}'
           
           
           
           
         UNION
        SELECT 'Refused NC/Appt' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'N' 
           AND a.requested_appointment = 'N'
           AND a.campaign_id = '{$this->getCampaignId()}'
         UNION
        SELECT 'Requested Appointment' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.requested_appointment = 'Y'
           AND a.campaign_id = '{$this->getCampaignId()}'
           
           
           
           
           
           
           
           
         UNION
        SELECT 'Annual Dental Visit' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
         WHERE a.yearly_dental_visit = 'Y' 
           AND a.campaign_id = '{$this->getCampaignId()}'
           
           
           
           
           
           
           
           
           
           
           
           
         UNION
        SELECT 'Claims Generated' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.claim_status = 'Y' 
           AND a.counseling_completed='Y'
           AND a.campaign_id = '{$this->getCampaignId()}'
           
         UNION
        SELECT 'Contact Attempts' AS `title`, SUM(number_of_attempts) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule
         WHERE campaign_id = '{$this->getCampaignId()}'
        UNION
        SELECT 'Left Messages' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule
         WHERE left_message = 'Y' 
           AND campaign_id = '{$this->getCampaignId()}'
         UNION
        SELECT 'Non-Working Numbers' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule
         WHERE working_number = 'N' 
           AND campaign_id = '{$this->getCampaignId()}'
         UNION
        SELECT 'Wrong Numbers' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule
         WHERE wrong_number = 'Y' 
           AND campaign_id = '{$this->getCampaignId()}'
         UNION
           
           
        SELECT 'Do Not Call' AS `title`, COUNT(*) AS total,'Y' as detail_available
          FROM dental_campaign_results AS a
            LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
            WHERE b.status = 'D'
                  AND a.campaign_id = '{$this->getCampaignId()}'
           
           
           
         UNION   
        SELECT 'Completed Contacts' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule
         WHERE `status` = 'C' 
           AND campaign_id = '{$this->getCampaignId()}'
        UNION
        SELECT 'Members W/O Phone Numbers' AS title, COUNT(*) AS total, 'Y' as detail_available FROM
               (SELECT a.id, a.address_id, a.`status`, b.member_id, CONCAT(c.last_name,', ',c.first_name) AS full_name, d.phone_number_id, e.phone_number
                 FROM dental_contact_call_schedule AS a
                 INNER JOIN dental_contact_members AS b
                   ON a.address_id = b.address_id
                 INNER JOIN dental_members AS c
                   ON b.member_id = c.id
                 INNER JOIN dental_member_phone_numbers AS d
                   ON b.member_id = d.member_id
                 INNER JOIN dental_phone_numbers AS e
                   ON d.phone_number_id = e.id
                WHERE a.campaign_id = '{$this->getCampaignId()}'
             ) AS dd
        WHERE phone_number IS  NULL
            
                
                UNION
                SELECT 'Ineligibility' AS `title`, COUNT(*) AS total,'Y' as detail_available
          FROM dental_members AS a
          WHERE a.campaign_id = '{$this->getCampaignId()}'
          AND (
              
                Date(a.eligibility_end_date) < now()
              OR
                Date(a.eligibility_start_date) > now()
              
              )
               
           
           
SQL;
        return $this->query($query);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * Generates a quick run down of the active campaign
     * 
     * @return iterator
     */
    public function snapshotrefresh() {
        
        $val='';
        $val2='';
        
        $campaignid=$_GET['campid'];
        
        
        $val1=$_GET['startdate'];
            
        
        
        $val2=$_GET['enddate'];            
        
       
       $end_clausea='';
       $end_clauseb='';
        $start_clauseb='';
        $start_clausea='';
        
       if(($val1)!=''){
           $isstart=date('Y-m-d',strtotime($val1)); 
            $start_clauseb =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
            
            $start_clausea =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        if($val2!=''){
           $isend=date('Y-m-d', strtotime(' +1 day', strtotime($val2))); 
           $isend=date('Y-m-d', strtotime($val2)); 
            $end_clausea =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)<='".$isend."')  END   
	END ";
            
            $end_clauseb =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
       
        
        
        
        
        
        $query = <<<SQL
        SELECT 'Total Members Processed' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
          LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id      
         WHERE a.campaign_id = '{$campaignid}'
         {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Total Contacts Processed' AS `title`, COUNT(DISTINCT contact_id) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.campaign_id = '{$campaignid}'
         {$start_clauseb}
         {$end_clauseb}
         UNION 
        SELECT 'Nutritional Counselings' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'Y'
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Refused Counselings' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'N' 
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
           
           
           
         UNION
        SELECT 'Refused NC/Appt' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.counseling_completed = 'N' 
           AND a.requested_appointment = 'N'
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Requested Appointment' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.requested_appointment = 'Y'
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
                      
         UNION
        SELECT 'Annual Dental Visit' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
         WHERE a.yearly_dental_visit = 'Y' 
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
                      
         UNION
        SELECT 'Claims Generated' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_campaign_results as a
         LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id 
         WHERE a.claim_status = 'Y' 
           AND a.counseling_completed='Y'
           AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Contact Attempts' AS `title`, SUM(b.number_of_attempts) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule as b
         WHERE b.campaign_id = '{$campaignid}'
         {$start_clauseb}
         {$end_clauseb}
        UNION
        SELECT 'Left Messages' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule as b
         WHERE b.left_message = 'Y' 
           AND b.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Non-Working Numbers' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule as b
         WHERE b.working_number = 'N' 
           AND b.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
        SELECT 'Wrong Numbers' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule as b
         WHERE b.wrong_number = 'Y' 
           AND b.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
         UNION
           
           
        SELECT 'Do Not Call' AS `title`, COUNT(*) AS total,'Y' as detail_available
          FROM dental_campaign_results AS a
            LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
            WHERE b.status = 'D'
                  AND a.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
           
           
         UNION   
        SELECT 'Completed Contacts' AS `title`, COUNT(*) AS total, 'Y' as detail_available
          FROM dental_contact_call_schedule as b
         WHERE b.`status` = 'C' 
           AND b.campaign_id = '{$campaignid}'
           {$start_clauseb}
         {$end_clauseb}
        UNION
        SELECT 'Members W/O Phone Numbers' AS title, COUNT(*) AS total, 'Y' as detail_available FROM
               (SELECT a.id, a.address_id, a.`status`, b.member_id, CONCAT(c.last_name,', ',c.first_name) AS full_name, d.phone_number_id, e.phone_number
                 FROM dental_contact_call_schedule AS a
                 INNER JOIN dental_contact_members AS b
                   ON a.address_id = b.address_id
                 INNER JOIN dental_members AS c
                   ON b.member_id = c.id
                 INNER JOIN dental_member_phone_numbers AS d
                   ON b.member_id = d.member_id
                 INNER JOIN dental_phone_numbers AS e
                   ON d.phone_number_id = e.id
                WHERE a.campaign_id = '{$campaignid}'
                {$start_clausea}
         {$end_clausea}
             ) AS dd
        WHERE phone_number IS  NULL    
            
         
         
         
SQL;
        return $this->query($query);
    }
    
    
    
    
    
    
    
    
    
    
    
    /**
     * Returns the names and IDs of those how have completed their nutritional counseling
     *
     * @return iterator
     */
    public function currentCompletedCounseling() {
        $assignee_clause = ($this->getAssignee()) ? " AND c.assignee = '".$this->getAssignee()."'" : "";
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
	  SELECT last_name, first_name, counseling_completed, a.modified AS date_of_service, a.member_id, b.date_of_birth, b.gender, d.address, d.city
	    FROM dental_campaign_results AS a
	    LEFT OUTER JOIN dental_members AS b
	      ON a.member_id = b.member_id
	    LEFT OUTER JOIN dental_contact_call_schedule AS c
	      ON a.contact_id = c.id
	    LEFT OUTER JOIN dental_addresses AS d
	      ON c.address_id = d.id
	   WHERE c.assignee IS NOT NULL
                {$assignee_clause}
	     AND a.claim_status = 'N' AND a.counseling_completed = 'Y'
	    {$campaign_clause}
SQL;
          return $this->query($query);
    }

    
    /**
     * Returns the contacts where we have either completed counseling and appointments, or they were declined
     *
     *  @return type
     */
    public function currentCompletedContacts() {
        $assignee_clause = ($this->getAssignee()) ? " AND a.assignee = '".$this->getAssignee()."'" : "";
        $query = <<<SQL
            SELECT a.id AS contact_id, a.assignee, a.status, a.number_of_attempts, a.in_progress, a.address_id, a.working_number, a.wrong_number, a.left_message,
                  b.address, b.city, b.state, b.zip_code,
                c.members
             FROM dental_contact_call_schedule AS a
             LEFT OUTER JOIN dental_addresses AS b
               ON a.address_id = b.id
             left outer join (
                SELECT address_id, COUNT(id) AS members
                  FROM dental_contact_members
                 GROUP BY address_id
             ) as c
                on a.address_id = c.address_id
                where a.status = 'C'
             {$assignee_clause}
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
        return $this->query($query);

    }
    /**
     * Returns the participants who received nutritional counseling
     *
     * @return iterator
     */
    public function currentCounselingCompletedContacts() {
        $query = <<<SQL
             SELECT a.*, a.member_id, b.member_id, b.first_name, b.last_name, b.date_of_birth, c.assignee
               FROM dental_campaign_results AS a
               LEFT OUTER JOIN dental_contact_members AS d
                 ON a.member_id = d.member_id
               LEFT OUTER JOIN dental_contact_call_schedule AS c
                 ON d.address_id = c.address_id
               LEFT OUTER JOIN dental_members AS b
                 ON a.member_id = b.id
              WHERE a.counseling_completed = 'Y'
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
        return $this->query($query);
    }
    
    public function details($member_id = false) {
        $details    = [];
        $member_id  = ($member_id) ? $member_id : $this->getMemberId();
        if ($member_id) {
            $query = <<<SQL
                SELECT DISTINCT a.*, b.counseling_completed, b.requested_appointment, b.yearly_dental_visit,
                      d.address, d.city, d.state, d.zip_code, 
                      e.assignee, e.working_number, e.wrong_number, e.left_message, e.id AS contact_id,
                      f.first_name AS assignee_first_name, f.last_name AS assignee_last_name, f.gender AS assignee_gender,
                      h.phone_number
                 FROM dental_members AS a
                 LEFT OUTER JOIN (SELECT * FROM dental_campaign_results
                WHERE member_id = '{$member_id}' 
		    AND campaign_id = '{$this->getCampaignId()}'
                 
                 ) AS b
                   ON a.member_id = b.member_id
                 LEFT OUTER JOIN dental_contact_members AS c
                   ON a.id = c.member_id
                 LEFT OUTER JOIN dental_addresses AS d
                   ON c.address_id = d.id
                 LEFT OUTER JOIN (SELECT * FROM dental_contact_call_schedule WHERE campaign_id = '5') AS e
                   ON d.id = e.address_id
                 LEFT OUTER JOIN humble_user_identification AS f
                   ON e.assignee = f.id
                 LEFT OUTER JOIN dental_member_phone_numbers AS g
                   ON a.id = g.member_id
                 LEFT OUTER JOIN dental_phone_numbers AS h
                   ON g.phone_number_id = h.id
                 WHERE a.member_id = '{$member_id}' 
            AND b.campaign_id = '{$this->getCampaignId()}'
SQL;
            $details = $this->query($query)->toArray();
        }
        
        return (isset($details[0]) ? $details[0] : []);
    }
    
    /**
     * Returns those who are eligible for claims processing
     * 
     * @return iterator
     */
    public function newClaims() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.*, b.first_name, b.last_name, b.date_of_birth, b.gender, b.language, c.assignee, c.status, address_id, d.address, d.city, d.state, d.zip_code, d.type_id
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_members AS b
                ON a.member_id = b.member_id
              LEFT OUTER JOIN dental_contact_call_schedule AS c
                ON a.contact_id = c.id
              LEFT OUTER JOIN dental_addresses AS d
                ON c.address_id = d.id
             WHERE a.counseling_completed = 'Y'    
               and a.claim_status = 'N'
            {$campaign_clause}
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns those who are eligible for claims processing
     * 
     * @return iterator
     */
    public function fixClaims($member_list=false) {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.*, b.first_name, b.last_name, b.date_of_birth, b.gender, b.language, c.assignee, c.status, address_id, d.address, d.city, d.state, d.zip_code, d.type_id
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_members AS b
                ON a.member_id = b.member_id
              LEFT OUTER JOIN dental_contact_call_schedule AS c
                ON a.contact_id = c.id
              LEFT OUTER JOIN dental_addresses AS d
                ON c.address_id = d.id
             WHERE a.member_id in ({$member_list})
SQL;
        return $this->query($query);
    }    
    /**
     * Gets all pertinent information about a particular member id
     * 
     * @param type $member_id
     * @return type
     */
    public function fullResults($member_id=false) {
        $results        = [];
        if ($member_id  = ($member_id) ? $member_id : (($this->getMemberId()) ? $this->getMemberId() : ($this->getId() ? $this->getId() : false))) {
        $query          = <<<SQL
            SELECT a.*,
                    b.first_name, b.last_name, b.date_of_birth, b.gender, b.language, 
                    c.address_id, e.phone_number, 
                    f.address, f.city, f.state, f.zip_code
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_members AS b
                ON a.member_id = b.member_id
              LEFT OUTER JOIN dental_contact_call_schedule AS c
                ON a.contact_id = c.id
              LEFT OUTER JOIN dental_member_phone_numbers AS d
                ON a.id = d.member_id
              LEFT OUTER JOIN dental_phone_numbers AS e
                ON d.phone_number_id = e.id
              LEFT OUTER JOIN dental_addresses AS f
                ON c.address_id = f.id
             WHERE a.member_id = '{$member_id}'                
SQL;
            $results = $this->query($query)->toArray();
        }
        return (count($results)>0) ? $results[0] : null;
    }
}
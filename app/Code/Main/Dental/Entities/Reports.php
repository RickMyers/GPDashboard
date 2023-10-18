<?php
namespace Code\Main\Dental\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Canned reports for Dental Hygienist outreach
 *
 * These are reports that support the dental hygienists.  This is in the Entities folder due to the fact that we need a DB connection.
 * There is no corresponding reports table.
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Reports extends Entity
{

    private $helper = null;
    private $stamp  = null;
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
        $this->helper = Argus::getHelper('argus/CSV');
        $this->stamp  = 'R_'.date('Ymd').'_';
    }

    /**
     * Returns all the current nutritional counselings for the current campaign
     * 
     * @return text/csv
     */
    public function refusedNutritionalCounselings() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'refused_nutritional_counselings.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."') END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."') END   
	END ";
        }
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, g.phone_number, b.number_of_attempts as 'Total Number of Attempts', d.date_of_birth,  Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, a.modified
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
               
		LEFT OUTER JOIN (
			SELECT ahmpn.member_id, GROUP_CONCAT(ahpn.phone_number SEPARATOR ', ') AS phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id
		) AS g ON d.id = g.member_id

             WHERE a.counseling_completed = 'N'
                  AND a.campaign_id =  '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}                 
SQL;
        return $this->helper->toCSV($this->query($query));
    }

    /**
     * Returns all the current nutritional counselings for the current campaign
     * 
     * @return text/csv
     */
    public function nutritionalCounselings() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'nutritional_counselings.csv"');
        $start_clause   = ($this->getStartDate()) ? "and a.modified >= '".date('Y-m-d',strtotime($this->getStartDate()))."' " : "";
        $end_clause     = ($this->getEndDate()) ? "and a.modified <= '".date('Y-m-d',strtotime($this->getEndDate()))."' " : "";
        
        
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, GROUP_CONCAT( DISTINCT g.phone_number SEPARATOR ', ') AS phone_number, b.number_of_attempts as 'Total Number of Attempts', d.date_of_birth, Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
               
		LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number  FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.counseling_completed = 'Y'
                  AND a.campaign_id = '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}
             GROUP BY a.member_id, d.first_name, d.last_name, d.date_of_birth, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date, b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }    
    /**
     * Returns those who have done an annual dental visit
     * 
     * @return text/csv
     */    
    public function annualDentalVisit() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'annual_dental_visits.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, GROUP_CONCAT(g.phone_number SEPARATOR ', ') AS phone_number , d.date_of_birth, b.number_of_attempts as 'Total Number of Attempts', Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
               
		LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number  FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.yearly_dental_visit = 'Y'
                  AND a.campaign_id = '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}
                 GROUP BY a.member_id, d.last_name, d.first_name, d.date_of_birth,  a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code, e.comments, b.last_activity_date, b.status_change_date, b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    /**
     * Returns number that were either wrong or not working
     * 
     * @return text/csv
     */    
    public function nonWorkingNumbers() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'non_working_numbers.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)<='".$isend."')  END   
	END ";
        }
        $query = <<<SQL
            SELECT CONCAT(b.first_name,' ',b.last_name) AS hygienest, GROUP_CONCAT(Distinct d.phone_number SEPARATOR ', ') AS phone_number, COALESCE(a.working_number,' ') AS Working_Number, COALESCE(a.wrong_number,' ') AS Wrong_Number, a.status,
                    CASE a.status
                        WHEN 'R' THEN 'Returned'
                        WHEN 'C' THEN 'Completed'
                        WHEN 'A' THEN 'Open'
                        WHEN 'H' THEN 'Hold'
                        WHEN 'D' THEN 'Do Not Call'
                        ELSE 'Unknown'
                    END AS status_text,  a.number_of_attempts as 'Total Number of Attempts', c.address, c.city, c.state, c.zip_code, a.last_activity_date, a.status_change_date
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.assignee = b.id
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
              LEFT OUTER JOIN (
		SELECT address_id, phone_number
		FROM (
			SELECT a.address_id, a.member_id, COALESCE(c.phone_number,'N/A') AS phone_number
			FROM dental_contact_members AS a
			LEFT OUTER JOIN dental_member_phone_numbers AS b
				ON a.member_id = b.member_id
			LEFT OUTER JOIN dental_phone_numbers AS c
				ON b.phone_number_id = c.id
		) AS a
		GROUP BY address_id, phone_number
	      ) AS d
              ON a.address_id = d.address_id
             WHERE (a.working_number = 'N')
               AND a.campaign_id =  '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}      
                 GROUP BY b.first_name, b.last_name, a.working_number, a.wrong_number, a.status, c.address, c.city, c.state, c.zip_code, a.last_activity_date, a.status_change_date, a.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
 
    /**
     * Returns number that were either wrong or not working
     * 
     * @return text/csv
     */    
    public function wrongNumbers() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'wrong_numbers.csv"');   
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";   
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT CONCAT(b.first_name,' ',b.last_name) AS hygienest,GROUP_CONCAT(d.phone_number SEPARATOR '|') AS phone_number, COALESCE(a.working_number,' ') AS Working_Number, COALESCE(a.wrong_number,' ') AS Wrong_Number, a.status,
                    CASE a.status
                        WHEN 'R' THEN 'Returned'
                        WHEN 'C' THEN 'Completed'
                        WHEN 'A' THEN 'Open'
                        WHEN 'H' THEN 'Hold'
                        WHEN 'D' THEN 'Do Not Call'
                        ELSE 'Unknown'
                    END AS status_text,  a.number_of_attempts as 'Total Number of Attempts', c.address, c.city, c.state, c.zip_code, a.last_activity_date, a.status_change_date
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.assignee = b.id
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
              LEFT OUTER JOIN (
		      SELECT address_id, phone_number
		      FROM (
			SELECT a.address_id, a.member_id, COALESCE(c.phone_number,'N/A') AS phone_number
			FROM dental_contact_members AS a
			LEFT OUTER JOIN dental_member_phone_numbers AS b
				ON a.member_id = b.member_id
			LEFT OUTER JOIN dental_phone_numbers AS c
				ON b.phone_number_id = c.id
		      ) AS a
			GROUP BY address_id, phone_number
	      ) AS d
              ON a.address_id = d.address_id
             WHERE a.wrong_number = 'Y'
               AND a.campaign_id =  '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause} 
                 GROUP BY
               b.last_name, b.first_name , a.working_number, a.wrong_number, a.status, c.address, c.city, c.state, c.zip_code, a.last_activity_date, a.status_change_date, a.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }    
    /**
     * A summary of hygienist activity
     * 
     * @return text/csv
     */    
    public function hygienistSummary() {
//        header('Content-Disposition: inline; filename="'.$this->stamp.'non_working_numbers.csv"');  
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";        
        $query = <<<SQL
            select g.hygienist as Hygienist, g.AppointmentsGenerated, g.NutritionalCounselings, g.CompletionPercentage, h.TotalPotentialMembers, g.TotalMembersContacted, h.TotalPotentialMembers-g.TotalMembersContacted as MissedMembers, TotalMembersContacted/TotalPotentialMembers*100 as MemberOutreachPercentage from
            (SELECT CONCAT(e.first_name,' ',e.last_name) AS hygienist, d.*, NutritionalCounselings/TotalMembersContacted*100 as CompletionPercentage FROM
            (SELECT assignee, COUNT(requested_appointment = 'Y') AS AppointmentsGenerated, COUNT(counseling_completed = 'Y') AS NutritionalCounselings, COUNT(yearly_dental_visit = 'Y') AS DentalVisits, COUNT(*) AS TotalMembersContacted
              FROM
                    (SELECT b.assignee, contact_id, member_id, requested_appointment, yearly_dental_visit,counseling_completed, b.last_activity_date, b.status_change_date
                       FROM dental_campaign_results AS a
                       LEFT OUTER JOIN dental_contact_call_schedule AS b
                         ON a.contact_id = b.id
                         where a.campaign_id =  '{$this->getCampaignId()}') AS c
                        where b.contact_id is not null
                        {$start_clause}
                        {$end_clause}
                       GROUP BY assignee) AS d
             LEFT OUTER JOIN humble_user_identification AS e
               ON d.assignee = e.id) as g
             left outer join (
                    SELECT assignee, COUNT(*) AS TotalPotentialMembers FROM
                    (SELECT a.id, a.assignee, a.address_id, b.member_id, c.first_name, c.last_name
                      FROM dental_contact_call_schedule AS a
                      LEFT OUTER JOIN dental_contact_members AS b
                        ON a.address_id = b.address_id
                      LEFT OUTER JOIN dental_members AS c
                        ON b.member_id = c.id
                        where a.campaign_id =  '{$this->getCampaignId()}') AS d
                      GROUP BY assignee 
             ) as h
              on g.assignee = h.assignee                 
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    /**
     * Returns all members processed within timeline
     * 
     * @return text/csv
     */    
    public function totalMembersProcessed() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'total_members_processed.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."') END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, g.phone_number, d.date_of_birth, Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   b.last_activity_date, b.number_of_attempts as 'Total Number of Attempts', b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.campaign_id = '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}                
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    /**
     * Returns all contacted members who were processed within specified time
     * 
     * @return text/csv
     */    
    public function totalContactsProcessed() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'total_contacts_processed.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        
        $query = <<<SQL
            
                
                
SELECT                
                   
                   
                   CONCAT ( GROUP_CONCAT(DISTINCT d.last_name SEPARATOR ', ')  ,' Household') AS 'Family Household', COUNT(d.first_name) AS '# of people', (b.number_of_attempts) as 'Total Number of Attempts', GROUP_CONCAT(DISTINCT g.phone_number SEPARATOR ', ') AS phone_number, GROUP_CONCAT(DISTINCT a.member_id SEPARATOR ', ') AS member_id, 
                   c.address, c.city, c.state, c.zip_code
                
              FROM (SELECT contact_id, campaign_id, member_id, requested_appointment, yearly_dental_visit, counseling_completed FROM dental_campaign_results GROUP BY contact_id, id ) AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.campaign_id = '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}
             GROUP BY a.contact_id, c.address, c.city, c.state, c.zip_code,b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    /**
     * Returns the list of people who have requested Appointments
     * 
     * @return text/csv
     */    
    public function requestedAppointment() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'requested_appointments.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, GROUP_CONCAT( DISTINCT g.phone_number SEPARATOR ', ') AS phone_number, d.date_of_birth, Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', (b.number_of_attempts) as 'Total Number of Attempts', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
               
		LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.requested_appointment = 'Y'
                  AND a.campaign_id =  '{$this->getCampaignId()}'
            {$start_clause}
            {$end_clause}
            GROUP BY d.last_name, d.first_name, a.member_id,  d.date_of_birth,  a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code, e.comments, b.last_activity_date, b.status_change_date, b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    /**
     * Returns the list of people who have have claimed a status as well as completed counseling
     * 
     * @return text/csv
     */    
    public function claimsGenerated() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'claims_generated.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        
        $query = <<<SQL
            SELECT DISTINCT
	
 d.first_name, d.last_name, GROUP_CONCAT(g.phone_number SEPARATOR ', ') AS phone_number, d.date_of_birth, (b.number_of_attempts) as 'Total Number of Attempts', Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   b.last_activity_date, b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE a.claim_status = 'Y' 
           AND a.counseling_completed='Y' 
               AND a.campaign_id = '{$this->getCampaignId()}'
            {$start_clause}
            {$end_clause}
            GROUP BY a.member_id, d.last_name, d.first_name, d.date_of_birth, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   b.last_activity_date, b.status_change_date, b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    /**
     * Returns the list of households (# of people) who have been contacted (and how many times)
     * 
     * @return text/csv
     */    
    public function contactAttempts() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'contact_attempts.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT STRAIGHT_JOIN DISTINCT
COUNT(d.first_name) AS '# of people in household', GROUP_CONCAT(DISTINCT g.phone_number SEPARATOR ', ') AS 'phone_number', (b.number_of_attempts) AS '# of Attempts', 
                   c.address, c.city, c.state, c.zip_code
          FROM dental_contact_call_schedule AS b
          LEFT OUTER JOIN (SELECT * FROM dental_campaign_results ) AS a ON b.id=a.contact_id
          LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number AS phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id
                
                
         WHERE b.campaign_id = '{$this->getCampaignId()}'
            AND b.number_of_attempts>0
            {$start_clause}
            {$end_clause}
            GROUP BY c.address, b.number_of_attempts,  c.city, c.state, c.zip_code
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    /**
     * Returns the list of Left for a 
     * 
     * @return text/csv
     */    
    public function leftMessages() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'left_messages.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
          SELECT STRAIGHT_JOIN DISTINCT 
  CONCAT ( GROUP_CONCAT(DISTINCT d.last_name SEPARATOR ', ')  ,' Household') AS 'Family Household', (b.number_of_attempts) as 'Total Number of Attempts', COUNT(d.first_name) AS '# of people', GROUP_CONCAT(DISTINCT g.phone_number SEPARATOR ', ') AS phone_number, GROUP_CONCAT(DISTINCT a.member_id SEPARATOR ', ') AS member_id,  b.left_message AS 'Left Messages', 
                   c.address, c.city, c.state, c.zip_code, e.comments
 
          FROM dental_contact_call_schedule AS b
          LEFT OUTER JOIN (SELECT * FROM dental_campaign_results ) AS a ON b.id=a.contact_id
          LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
               
          LEFT OUTER JOIN ( 
          SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments FROM dental_contact_call_log GROUP BY contact_id
          ) AS e ON a.contact_id = e.contact_id               
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id
         WHERE b.campaign_id = '{$this->getCampaignId()}'
         AND b.left_message = 'Y'
            {$start_clause}
            {$end_clause}
            GROUP BY b.id, b.left_message, c.address, c.city, c.state, c.zip_code, e.comments , b.number_of_attempts
            
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    
    /**
     * Returns the list of Contacts whom have completed their appointment
     * 
     * @return text/csv
     */    
    public function completedContacts() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'completed_contacts.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        
        $query = <<<SQL
            SELECT STRAIGHT_JOIN DISTINCT 
        
  CONCAT ( GROUP_CONCAT(DISTINCT d.last_name SEPARATOR ', ')  ,' Household') AS 'Family Household', b.number_of_attempts as 'Total Number of Attempts', COUNT(d.first_name) AS '# of people', b.campaign_id, b.`status`, GROUP_CONCAT(DISTINCT g.phone_number SEPARATOR ', ') AS phone_number, GROUP_CONCAT(DISTINCT a.member_id SEPARATOR ', ') AS member_id,  b.left_message AS 'Left Messages',  
                   c.address, c.city, c.state, c.zip_code, e.comments
                   
          FROM dental_contact_call_schedule AS b
          LEFT OUTER JOIN (SELECT * FROM dental_campaign_results ) AS a ON b.id=a.contact_id
          LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
               
          LEFT OUTER JOIN ( 
          SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments FROM dental_contact_call_log GROUP BY contact_id
          ) AS e ON a.contact_id = e.contact_id               
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id
         WHERE b.campaign_id = '{$this->getCampaignId()}'
         AND b.`status` = 'C' 
         
            {$start_clause}
            {$end_clause}
            GROUP BY b.id, b.left_message, 
                   c.address, c.city, c.state, c.zip_code, e.comments , b.number_of_attempts
  
            
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    /**
     * Returns the list of Members without Phone Numbers 
     * 
     * @return text/csv
     */    
    public function noPhoneNum() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'members_without_phone_numbers.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN a.last_activity_date IS NOT NULL THEN (date(a.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN a.status_change_date IS NOT NULL THEN (date(a.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT * FROM
               (SELECT CONCAT(c.last_name,', ',c.first_name) AS full_name, b.number_of_attempts as 'Total Number of Attempts', a.address_id, f.address, f.city, f.state, f.zip_code, a.`status`, b.member_id, d.phone_number_id, e.phone_number
                 FROM dental_contact_call_schedule AS a
                 INNER JOIN dental_contact_members AS b
                   ON a.address_id = b.address_id
                 INNER JOIN dental_members AS c
                   ON b.member_id = c.id
                 INNER JOIN dental_member_phone_numbers AS d
                   ON b.member_id = d.member_id
                 INNER JOIN dental_phone_numbers AS e
                   ON d.phone_number_id = e.id
                 LEFT OUTER JOIN dental_addresses AS f
                ON a.address_id = f.id
                WHERE a.campaign_id = '{$this->getCampaignId()}'
                {$start_clause}
                {$end_clause}
             ) AS dd
        WHERE phone_number IS  NULL 
         
                
            
            
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
        
            
            
            
    
    /**
     * Returns the list of people who have stated that they don't want to be called
     * 
     * @return text/csv
     */    
    public function doNotCall() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'do_not_call.csv"'); 
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT DISTINCT 

d.first_name, d.last_name, GROUP_CONCAT(g.phone_number SEPARATOR ', ') AS phone_number, b.number_of_attempts as 'Total Number of Attempts', d.date_of_birth, Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, b.status, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date
                
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
                
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
                
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
                
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
               
		LEFT OUTER JOIN (
			SELECT ahmpn.member_id, ahpn.phone_number FROM dental_member_phone_numbers AS ahmpn 
			LEFT OUTER JOIN dental_phone_numbers AS ahpn ON ahmpn.phone_number_id=ahpn.id GROUP BY ahmpn.member_id, ahpn.phone_number
		) AS g ON d.id = g.member_id

             WHERE b.status = 'D'
                  AND a.campaign_id =  '{$this->getCampaignId()}'
            {$start_clause}
            {$end_clause}
            GROUP BY a.member_id, d.last_name, d.first_name, g.phone_number, d.date_of_birth,  b.status, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date, b.number_of_attempts
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    /**
     * Returns all refused nutritional counselings for the current campaign that also had no requested appointments
     * 
     * @return text/csv
     */
    public function reportName() {
        header('Content-Disposition: inline; filename="'.$this->stamp.'refused_nutritional_counselings.csv"');
        $start_clause = ($this->getStartDate()) ? "and a.modified >= '".$this->getStartDate()."' " : "";
        $end_clause = ($this->getEndDate()) ? "and a.modified <= '".$this->getEndDate()."' " : "";
        
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate())); 
            $start_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) >= '".$isstart."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)>='".$isstart."')  END   
	END ";
        }
        
        
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
            $end_clause =  " AND CASE WHEN b.last_activity_date IS NOT NULL THEN (date(b.last_activity_date) <= '".$isend."') ELSE
		CASE WHEN b.status_change_date IS NOT NULL THEN (date(b.status_change_date)<='".$isend."')  END   
	END ";
        }
        
        $query = <<<SQL
            SELECT Distinct d.first_name, d.last_name, g.phone_number, d.date_of_birth, b.number_of_attempts as 'Total Number of Attempts', Floor(datediff(now(), d.date_of_birth)/365.25) as 'age', a.member_id, a.requested_appointment, a.yearly_dental_visit, a.counseling_completed, 
                   c.address, c.city, c.state, c.zip_code,
                   e.comments, b.last_activity_date, b.status_change_date
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
              LEFT OUTER JOIN dental_addresses AS c
                ON b.address_id = c.id
              LEFT OUTER JOIN dental_members AS d
                ON a.member_id = d.member_id
              LEFT OUTER JOIN (
                    SELECT contact_id, GROUP_CONCAT(`comments` SEPARATOR '|') AS comments
                      FROM dental_contact_call_log 
                      GROUP BY contact_id) AS e
                ON a.contact_id = e.contact_id
              LEFT OUTER JOIN 
                 (SELECT member_id, phone_number_id FROM dental_member_phone_numbers) AS f
                ON d.id = f.member_id
	     LEFT OUTER JOIN dental_phone_numbers AS g
                ON f.phone_number_id = g.id
             WHERE a.counseling_completed = 'N'
                AND a.requested_appointment='N'
                  AND a.campaign_id =  '{$this->getCampaignId()}'
             {$start_clause}
             {$end_clause}                 
SQL;
        return $this->helper->toCSV($this->query($query));
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * IN PROGRESS
     * 
     * Returns the list of people who are ineligible at the time
     * 
     * @return text/csv
     */    
    public function ineligibility() {
        /*
        header('Content-Disposition: inline; filename="'.$this->stamp.'ineligibility.csv"'); 
        $calctime='';
        $isend='';
        $isstart='';
        // needs to be redone-> get values from prestige
        if($this->getStartDate()){
           $isstart=date('Y-m-d',strtotime($this->getStartDate()));             
        }
        
        if($this->getEndDate()){
           $isend=date('Y-m-d',strtotime($this->getEndDate())); 
        //    $end_clause =  " AND Date(eligibility_end_date) > '".$isend."')";
        }
        
        if($isend=='' && $isstart==''){            
            $calctime=' ((Date(eligibility_end_date)>=now() && Date(eligibility_start_date)<=now()) || (Date(eligibility_start_date)<=now() && Date(eligibility_end_date)<Date(eligibility_start_date)))';
        }
        
        else if($isend=='' && $isstart!=''){
            $calctime=' ((Date(eligibility_end_date)>=Date('.$isstart.') && Date(eligibility_start_date)<=Date('.$isstart.')) || (Date(eligibility_start_date)<=Date('.$isstart.') && Date(eligibility_end_date)<Date(eligibility_start_date)))';
            
        }
        
        else if($isend!='' && $isstart==''){
            $calctime=' ((Date(eligibility_end_date)>=Date('.$isend.') && Date(eligibility_start_date)<=Date('.$isend.')) || (Date(eligibility_start_date)<=Date('.$isend.') && Date(eligibility_end_date)<Date(eligibility_start_date)))';
            
        }
        
        else{
            
            
        }
        $query = <<<SQL
             SELECT DISTINCT CONCAT(first_name,' ', last_name) AS 'name', date_of_birth, Floor(datediff(now(), a.date_of_birth)/365.25) as 'age', gender, `language`, eligibility_start_date, eligibility_end_date
                
              FROM dental_members AS a
              where campaign_id =  '{$this->getCampaignId()}'
            AND (
              
                Date(eligibility_end_date) < now()
              OR
                Date(eligibility_start_date) > now()
              
              )            
SQL;
        return $this->helper->toCSV($this->query($query));
        */
        
        
        
        
        
        
        
        
        
        
        
        $util       = Argus::getHelper('argus/CSV'); 
        $results    = [];
        
        
       // $memid = ($this->getMemid()) ? $this->getMemid() : '';
       
       $startdate=($this->getStartDate()) ? $this->getStartDate() : '';
       $enddate=($this->getEndDate()) ? $this->getEndDate() : '';
       
      
       //$theid=1455;
        //$theform=Argus::getEntity('vision/consultation_forms')->setId($theid)->setStatus('C')->formnormalizer();
       
       
       
       
       
       $theform=Argus::getEntity('dental/members')->formnormalizer();
       
       $results= $this-> ineligconv($theform);
       
        header('Content-Disposition: inline; filename="'.$this->stamp.'ineligibility.csv"'); 
        return $util -> arrayToCSV(Argus::report($results,'dental/ineligiblefile'));
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    public function ineligconv($theform){
        $results=[];
         
        foreach ($theform as $form) {
            $temppage=[];
            $fname=   isset($form['first_name']) ? $form['first_name'] : '';
            $lname=   isset($form['last_name']) ? $form['last_name'] : '';
            
            $temppage['member_name']=$fname.' '.$lname;
            
            $temppage['member_id']=isset($form['member_id']) ? $form['member_id'] : '';
            
            $temppage['dob']=isset($form['date_of_birth']) ? $form['date_of_birth'] : '';
            
            if(isset($form['date_of_birth'])){
                $cdate=date("Y-m-d");
                $bdate=$form['date_of_birth'];
                $years = round((strtotime($cdate)-strtotime($bdate))/(3600*24*365.25));
                
                //$bdatetime=strtotime($bdate);
                //$newbdate = date('Y-m-d',$bdatetime);
                //$diffdates = $newbdate->diff($cdate);
                
                //$diffdates = date_diff($bdate,$cdate);
                //$diffyear=$diffdates->y; 
                
                
                
                
                
                
                
                $temppage['age'] = $years;
            }
            else{
                $temppage['age']='';
            }
            
            $temppage['gender']=isset($form['gender']) ? $form['gender'] : '';
            
            $temppage['language']=isset($form['language']) ? $form['language'] : '';
            
            
            //$eligib=getPrestigeEligibilityStatus()|json_decode;
            
            /*
             {assign var=mem value=$participant.member_id}
            {assign var=eligibility value=$elig->setMemberId($mem)->getPrestigeEligibilityStatus()|json_decode}
            {if ($participant.results_campaign_id && ($participant.results_campaign_id != $campaign_id))}
                {assign var=warning value=true}
            {/if}
            {assign var=eligible value=true}
            {if ($eligibility)}
                {assign var=eligible value=$eligibility->active}
            {/if}
            {*  I HAVE REVERSED THE ELIGIBILITY CALL TO MAKE EVERYONE ELIGIBLE, CHANGE BELOW WHEN THE CALL IS WORKING AGAIN *}
            <div class="nc_row" style="background-color: rgba({if (!$eligible)}255,189,189,.4{else}202,202,202,.2{/if}); margin-bottom: 10px; padding-top: 4px">
                <div style="min-width: 900px; width: 80%; clear: both;">
                    {$participant.first_name} {$participant.last_name} <div style="float: right">{if ($eligible && (isset($eligibility->effective_start_date)))}Eligible: [{$eligibility->effective_start_date|date_format:"m/d/Y"} - {$eligibility->effective_end_date|date_format:"m/d/Y"}]{else}<b><i>Eligibility Unknown</i></b>{/if}</div>
                </div>
             */
            
            $temppage['eligibility_start_date']=isset($form['eligibility_start_date']) ? $form['eligibility_start_date'] : '';
            $temppage['eligibility_end_date']=isset($form['eligibility_end_date']) ? $form['eligibility_end_date'] : '';
            
            
            
            $results[] = $temppage;
            
           
        }
        
        
        return $results;
    }
    
    
    
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
    
    
    
    
    
    
    
}
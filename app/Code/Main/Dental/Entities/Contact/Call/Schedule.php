<?php
namespace Code\Main\Dental\Entities\Contact\Call;
use Argus;
use Log as ArgusLog;
use Environment;
/**
 *
 * Call Schedule Queries
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
class Schedule extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns the number of calls currently in a hygenists queue, note that this returns a hash table and not an iterator
     *
     * @return hash_table
     */
    public function HEDISWorkloads() {
        $query = <<<SQL
            SELECT assignee, COUNT(id) AS work_load
              FROM dental_contact_call_schedule
             WHERE `status` = 'A'
               AND assignee IS NOT NULL
                and campaign_id = '{$this->getCampaignId()}'
              GROUP BY assignee
SQL;
        $hash = [];
        foreach ($this->query($query) as $workload) {
            $hash[$workload['assignee']] = $workload['work_load'];
        }
        return $hash;
    }
    
    /**
     * Gets the current status of a campaign for an individual hygenist
     * 
     * @return array
     */
    public function progress() {
        $metadata   = [
            "A" => ["label"=> 'Queued',     "base" => '#5555DD', "highlight" => "#3333FF"],
            "C" => ["label"=> 'Complete',   "base" => '#55DD55', "highlight" => "#33FF33"],
            "D" => ["label"=> 'DNC',        "base" => '#DD5555', "highlight" => "#553333"],
            "R" => ["label"=> 'Returned',   "base" => '#D5D500', "highlight" => "#00D5D5"],
            "H" => ["label"=> 'On Hold',    "base" => '#CCCCCC', "highlight" => "#DDDDDD"]
        ];
        $query      = <<<SQL
        SELECT `status`, COUNT(*) AS total
          FROM dental_contact_call_schedule
         WHERE assignee = '{$this->assignee}'
           and campaign_id = '{$this->campaign_id}'
         GROUP BY `status`
SQL;
           
        $results = $this->query($query)->toArray();
        foreach ($results as $idx => $row) {
            foreach ($metadata[$row['status']] as $field => $value) {
                $results[$idx][$field] = $value;
            }
        }
        
        
        return $results;
    }

    /**
     * Gets the current progress of the active campaign 
     * 
     * @return array
     */
    public function campaignProgress() {
        $metadata   = [
            "A" => ["label"=> 'Active',     "base" => '#5555DD', "highlight" => "#3333FF"],
            "C" => ["label"=> 'Completed',  "base" => '#55DD55', "highlight" => "#33FF33"],
            "D" => ["label"=> 'DNC',        "base" => '#DD5555', "highlight" => "#553333"],
            "R" => ["label"=> 'Returned',   "base" => '#D5D500', "highlight" => "#00D5D5"],
            "H" => ["label"=> 'On Hold',    "base" => '#CCCCCC', "highlight" => "#DDDDDD"]
        ];
        $query      = <<<SQL
        SELECT `status`, COUNT(*) AS total
          FROM dental_contact_call_schedule
         WHERE campaign_id = '{$this->getCampaignId()}'
         GROUP BY `status`
SQL;
        $results = $this->query($query)->toArray();
        foreach ($results as $idx => $row) {
            foreach ($metadata[$row['status']] as $field => $value) {
                $results[$idx][$field] = $value;
            }
        }
        return $results;
    }
    
    /**
     * Displays the ratio between counseling completed calls and non-completed
     * 
     * @return array
     */
    public function completions() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $metadata   = [
            "N" => ["label"=> 'Incomplete',   "base" => '#55DD55', "highlight" => "#33FF33"],
            "Y" => ["label"=> 'Counseling Completed',     "base" => '#5555DD', "highlight" => "#3333FF"],
            "" => ["label"=> 'Rejected',   "base" => '#DD5555', "highlight" => "#FF3333"]
        ];
        $query      = <<<SQL
        SELECT counseling_completed, COUNT(*) AS total FROM
        (SELECT b.counseling_completed
          FROM dental_contact_call_schedule AS a
          LEFT OUTER JOIN dental_campaign_results AS b
            ON a.id = b.contact_id
         WHERE a.assignee = '{$this->assignee}'
            and a.campaign_id = '{$this->campaign_id}') AS c
         GROUP BY counseling_completed                    
SQL;
        $results = $this->query($query)->toArray();
        foreach ($results as $idx => $row) {
            foreach ($metadata[$row['counseling_completed']] as $field => $value) {
                $results[$idx][$field] = $value;
            }
        }
        
        return $results;
    }    
    
    /**
     * Returns a dataset of all the calls that are currently unassigned
     *
     * @return type
     */
    public function fetchUnassignedContacts() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
          select * from dental_contact_call_schedule as a
            where assignee is null
              and `status` = 'A'
                {$campaign_clause}
SQL;
   
        return $this->query($query);
    }

    /**
     * Returns a dataset of contacts that have no one assigned to them
     *
     * @return iterator
     */
    public function currentOnHoldContacts() {
        $assignee_clause = ($this->getAssignee()) ? " AND a.assignee = '".$this->getAssignee()."'" : "";
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";        
        $query = <<<SQL
            SELECT a.id AS contact_id, a.members, c.address, c.city, a.number_of_attempts, c.zip_code
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
             WHERE a.status = 'H'
                {$assignee_clause} 
                {$campaign_clause}
SQL;
        return $this->query($query);
    }

    /**
     * Returns a dataset of contacts that have no one assigned to them
     *
     * @return iterator
     */
    public function currentReturnedContacts() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.id AS contact_id, a.members, c.address, c.city, a.number_of_attempts, c.zip_code
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
             WHERE a.status = 'R'
                {$campaign_clause}
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns a dataset of contacts that have no one assigned to them
     *
     * @return iterator
     */
    public function currentUnassignedContacts() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.id AS contact_id, a.members, c.address, c.city, a.number_of_attempts, c.zip_code
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
             WHERE a.assignee IS NULL
               and a.status = 'A'
                {$campaign_clause}
              order by members DESC, zip_code ASC
SQL;
        return $this->query($query);
    }

    /**
     * Returns a dataset of contacts who are in the process of being contacted
     *
     * @return iterator
     */
    public function currentInProgressContacts() {
        $assignee_clause = ($this->getAssignee()) ? " AND a.assignee = '".$this->getAssignee()."'" : "";
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";   
        $query = <<<SQL
            SELECT a.id AS contact_id, a.members, c.address, c.city, a.number_of_attempts, c.zip_code
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
             WHERE a.assignee IS NOT NULL
               AND a.status != 'C'
               AND a.in_progress = 'Y'
             {$assignee_clause}
             {$campaign_clause}
             order by members DESC, zip_code ASC
SQL;
        return $this->query($query);
    }

    /**
     * Returns a dataset of contacts that are assigned but are not being worked on and are not complete
     *
     * @return iterator
     */
    public function currentQueuedContacts() {
        $today = date('Y-m-d');
        $assignee_clause = ($this->getAssignee()) ? " AND a.assignee = '".$this->getAssignee()."'" : "";
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.id AS contact_id, a.members, c.address, c.city, a.number_of_attempts, c.zip_code
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS c
                ON a.address_id = c.id
             WHERE a.assignee IS NOT NULL
                and `status` = 'A'
                {$assignee_clause}
                {$campaign_clause}
                order by members DESC, zip_code ASC
SQL;
        return $this->query($query);
    }

    /**
     * Returns detailed information about a specific contact household
     *
     * @return array
     */
    public function details() {
        //$this->_polglot('Y');
        $query = <<<SQL
            SELECT distinct a.id AS contact_id, a.campaign_id, a.address_id, a.assignee, a.status, a.number_of_attempts, a.in_progress, a.working_number, a.wrong_number, a.left_message,
                   a.number_of_attempts, b.address, b.city, b.state, b.zip_code,
                   d.id AS hedis_member_id, d.member_id, d.first_name, d.last_name, d.date_of_birth,
                   f.phone_number,
                   g.requested_appointment, g.yearly_dental_visit, g.counseling_completed, g.campaign_id as results_campaign_id
              FROM (select * from  dental_contact_call_schedule
		     WHERE id = '{$this->getId()}'
              ) AS a
              inner JOIN dental_addresses AS b
                ON a.address_id = b.id
              inner JOIN dental_contact_members AS c
                ON a.address_id = c.address_id
              inner JOIN dental_members AS d
                ON c.member_id = d.id
              inner JOIN dental_member_phone_numbers AS e
                ON c.member_id = e.member_id
              inner JOIN dental_phone_numbers AS f
                ON e.phone_number_id = f.id
              LEFT OUTER JOIN dental_campaign_results AS g
                ON d.member_id = g.member_id
                and a.campaign_id = g.campaign_id
SQL;
        return $this->query($query)->toArray();
    }

    //###############################################################################################
    //                     CHARTING RELATED QUERIES FOLLOW BELOW
    //###############################################################################################
    /**
     * Returns the number of calls to assign to hygenists based on todays date
     *
     * @return integer
     */
    public function campaignUnassignedContacts() {
        $query = <<<SQL
          select count(*) as unassigned_contacts 
            from dental_contact_call_schedule as a
            where assignee is null
              and `status` = 'A'
            and a.campaign_id = '{$this->getCampaignId()}'
SQL;
        $results = $this->query($query)->toArray();
        return (isset($results[0]) ? $results[0]['unassigned_contacts'] : 0);
    }

    /**
     * Returns the number of contacts that are assigned but not in progress or completed
     *
     * @TODO: Need to revisit this and look at participants in household... see if they have been scheduled if so then it isn't queued, it is completed
     * @return int
     */
    public function campaignQueuedContacts() {
        $query = <<<SQL
            SELECT COUNT(id) AS queued_contacts
              FROM dental_contact_call_schedule as a
             WHERE `status` != 'C'
               AND assignee is not null
               and in_progress != 'Y'
           and a.campaign_id = '{$this->getCampaignId()}'
SQL;
       $results = $this->query($query)->toArray();
       return (isset($results[0]) ? $results[0]['queued_contacts'] : 0);
    }

    /**
     * Returns the number of contacts that are assigned and in progress
     *
     * @return int
     */
    public function campaignInProgressContacts() {
        $query = <<<SQL
         SELECT COUNT(id) AS inprogress_contacts
              FROM dental_contact_call_schedule as a
             WHERE in_progress = 'Y'
           and a.campaign_id = '{$this->campaign_id}'
SQL;
           
       $results = $this->query($query)->toArray();
       return (isset($results[0]) ? $results[0]['inprogress_contacts'] : 0);
    }

    /**
     * Returns the number of contacts assigned to each hygienist
     *
     * @return int
     */
    public function campaignHygenistWorkloads() {
        $query = <<<SQL
           select b.assignee, work_load, first_name, last_name from
            (SELECT assignee, COUNT(id) AS work_load
              FROM dental_contact_call_schedule as a
             WHERE `status` = 'A'
               AND assignee IS NOT NULL
               and a.campaign_id = '{$this->getCampaignId()}'
              GROUP BY assignee) as b
              left outer join humble_user_identification as c
               on b.assignee = c.id
SQL;
       return $this->query($query);
    }
    
    
    /**
     * 
     * @return type
     */
    public function completedContacts() {
        $assignee_clause = ($this->getAssignee()) ? " AND a.assignee = '".$this->getAssignee()."'" : "";
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT a.address_id, a.status, b.*, a.assignee, a.id as contact_id, a.number_of_attempts, c.members
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS b
                ON a.`address_id` = b.id
              LEFT OUTER JOIN (
		     SELECT address_id, COUNT(id) AS members
		       FROM dental_contact_members
		      GROUP BY address_id
              ) AS c
               on a.`address_id` = c.address_id
             WHERE a.status in ('D','C')
                {$assignee_clause}
                {$campaign_clause}
SQL;
        return $this->query($query);
    }
    
   
    /**
     * Returns the contact information of  those how have completed their nutritional counseling
     *
     * @return iterator
     */
    public function currentCompletedContacts() {
        $query = <<<SQL
            SELECT a.address_id, a.counseling_completed,a.status, b.*, a.id as contact_id
              FROM dental_contact_call_schedule AS a
              LEFT OUTER JOIN dental_addresses AS b
                ON a.`address_id` = b.id
             WHERE a.status in ('D','H','L','C')
           and a.campaign_id = '{$this->getCampaignId()}'
SQL;
          return $this->query($query);
    }   
    
   /**
     * Increments the number of attempts
     */
    public function increment() {
        $this->load();
        $this->setNumberOfAttempts((int)$this->getNumberOfAttempts()+1)->save();
    }
    
    /**
     * Returns the number of completed counselings per hygienist
     * 
     * @return type
     */
    public function counselingPerHygenists() {
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        $query = <<<SQL
            SELECT completed_counseling, assignee, b.first_name, b.last_name FROM
            (SELECT COUNT(*) AS completed_counseling, a.assignee FROM
            (SELECT a.member_id, a.contact_id, a.counseling_completed, b.assignee, b.status, b.campaign_id
              FROM dental_campaign_results AS a
              LEFT OUTER JOIN dental_contact_call_schedule AS b
                ON a.contact_id = b.id
           where a.campaign_id = '{$this->getCampaignId()}') AS a
              GROUP BY assignee) AS a
              LEFT OUTER JOIN humble_user_identification AS b
                 ON a.assignee = b.id             
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns the number of completed counselings per hygenist
     * 
     * @return type
     */
    public function contactsCompletedPerHygenists() {
        $query = <<<SQL
       SELECT b.completed_contacts, b.assignee, c.first_name, c.last_name FROM
       (SELECT COUNT(*) AS completed_contacts, assignee
         FROM dental_contact_call_schedule as a
         WHERE `status` = 'C'
           and campaign_id = '{$this->getCampaignId()}'
         GROUP BY assignee) AS b
         LEFT OUTER JOIN humble_user_identification AS c
	   ON b.assignee = c.id                
SQL;
        return $this->query($query);
    }    
    
    
    /**
     * Returns a list of current hygenists and all available clients they have
     * 
     * @return type
     */
    public function hygenistavailable() {
        $query = <<<SQL
        SELECT a.total, b.first_name AS hygienist FROM
(SELECT assignee, `status`, COUNT(*) total
  FROM dental_contact_call_schedule
 WHERE assignee IS NOT NULL
   AND `status` = 'A'
   and campaign_id = '{$this->getCampaignId()}'
  GROUP BY assignee, `status`) AS a
  LEFT OUTER JOIN humble_user_identification AS b
  ON a.assignee = b.id                   
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns the call durations per hygenists
     * 
     * @return type
     */
    public function callDurations() {
        $query = <<<SQL
        SELECT b.*, c.first_name, c.last_name FROM
        (SELECT a.user_id, COUNT(*) AS obs, AVG(a.duration) AS average_duration FROM
        (SELECT user_id, (end_time-start_time) AS duration
           FROM dental_call_log WHERE end_time IS NOT NULL) AS a
          GROUP BY user_id) AS b
           LEFT OUTER JOIN humble_user_identification AS c
            ON b.user_id = c.id                
SQL;
        return $this->query($query);
    }
    
    /**
     * Does a search against either a member ID or member name... will also add member address at some time
     * 
     * @return iterator
     */
    public function search($field=false,$text=false) {
        $text = $this->getText();
        $campaign_clause = ($this->getCampaignId()) ? " and a.campaign_id = '".$this->getCampaignId()."' " : "";
        if (is_numeric($text)) {
            //Let's run this as member ID
            $query = <<<SQL
                SELECT a.id AS contact_id, d.member_id, d.first_name, d.last_name, d.date_of_birth, CONCAT(e.first_name,' ',e.last_name) AS assignee, a.`status`,a.number_of_attempts,b.address,b.city,b.state,b.zip_code,c.member_id AS member_index
                  FROM dental_contact_call_schedule AS a
                  LEFT OUTER JOIN dental_addresses AS b
                    ON a.address_id = b.id
                  LEFT OUTER JOIN dental_member_addresses AS c
                    ON b.id = c.address_id
                  LEFT OUTER JOIN dental_members AS d
                   ON c.member_id = d.id
                  LEFT OUTER JOIN humble_user_identification AS e
                   ON a.assignee = e.id
                 WHERE c.member_id IN (
                SELECT id
                  FROM dental_members
                 WHERE member_id LIKE '%{$text}%' )
                 union
                SELECT a.id AS contact_id, d.member_id, d.first_name, d.last_name, d.date_of_birth, CONCAT(e.first_name,' ',e.last_name) AS assignee, a.`status`,a.number_of_attempts,b.address,b.city,b.state,b.zip_code,c.member_id AS member_index
                  FROM dental_contact_call_schedule AS a
                  LEFT OUTER JOIN dental_addresses AS b
                    ON a.address_id = b.id
                  LEFT OUTER JOIN dental_member_addresses AS c
                    ON b.id = c.address_id
                  LEFT OUTER JOIN dental_members AS d
                   ON c.member_id = d.id
                  LEFT OUTER JOIN humble_user_identification AS e
                   ON a.assignee = e.id                 
                 where a.id in (
                    SELECT d.id 
                      FROM dental_phone_numbers AS a
                     INNER JOIN dental_member_phone_numbers AS b
                        ON a.id = b.phone_number_id
                      LEFT OUTER JOIN dental_contact_members AS c
                        ON b.member_id = c.member_id
                      LEFT OUTER JOIN dental_contact_call_schedule AS d
                        ON c.address_id = d.address_id
                     WHERE a.phone_number LIKE '%{$text}%' )
SQL;
        } else {
            $query = <<<SQL
                SELECT a.id AS contact_id, d.member_id, d.first_name, d.last_name, d.date_of_birth, CONCAT(e.first_name,' ',e.last_name) AS assignee, a.`status`,a.number_of_attempts,b.address,b.city,b.state,b.zip_code,c.member_id AS member_index
                  FROM dental_contact_call_schedule AS a
                  LEFT OUTER JOIN dental_addresses AS b
                    ON a.address_id = b.id
                  LEFT OUTER JOIN dental_member_addresses AS c
                    ON b.id = c.address_id
                  LEFT OUTER JOIN dental_members AS d
                   ON c.member_id = d.id
                  LEFT OUTER JOIN humble_user_identification AS e
                   ON a.assignee = e.id
                 WHERE c.member_id IN (
                SELECT id
                  FROM dental_members
                 WHERE first_name LIKE '%{$text}%'
                    OR last_name LIKE '%{$text}%' )
                union
                SELECT a.id AS contact_id, d.member_id, d.first_name, d.last_name, d.date_of_birth, CONCAT(e.first_name,' ',e.last_name) AS assignee, a.`status`,a.number_of_attempts,b.address,b.city,b.state,b.zip_code,c.member_id AS member_index
                  FROM dental_contact_call_schedule AS a
                  LEFT OUTER JOIN dental_addresses AS b
                    ON a.address_id = b.id
                  LEFT OUTER JOIN dental_member_addresses AS c
                    ON b.id = c.address_id
                  LEFT OUTER JOIN dental_members AS d
                   ON c.member_id = d.id
                  LEFT OUTER JOIN humble_user_identification AS e
                   ON a.assignee = e.id
                 WHERE address LIKE '%{$text}%'
                   OR city LIKE '%{$text}%'
SQL;
        }
        return $this->query($query);
    }
    
    /**
     * Returns the presently on-hold contacts back to the assignee
     * 
     * @return boolean
     */
    public function returnOnHoldContacts() {
        $assignee_clause = ($this->getAssignee()) ? " and assignee = '".$this->getAssignee()."'" : "";
        $query = <<<SQL
        update dental_contact_call_schedule
           set `status` = 'A'
         where `status` = 'H'
           and assignee is not null
             {$assignee_clause}
SQL;
        return $this->query($query);
    }

    /**
     * Returns all on-hold contacts back to be reassigned
     * 
     * @return boolean
     */    
    public function recallOnHoldContacts() {
        $assignee_clause = ($this->getAssignee()) ? " and assignee = '".$this->getAssignee()."'" : "";
        $query = <<<SQL
        update dental_contact_call_schedule
           set `status` = 'A',
               assignee = null
         where `status` = 'H'
           and assignee is not null
            {$assignee_clause}
SQL;
        return $this->query($query);
    }    

    
    /**
     * Takes a user_id from a variety of input sources and unassigns any active contacts that user_id is assigned to
     * 
     * @param type $user_id
     */
    public function returnContacts($user_id=false) {
        if ($user_id = $this->getUserId() ? $this->getUserId() : ($this->getId() ? $this->getId() : $user_id)) {
            $query = <<<SQL
            update dental_contact_call_schedule
               set assignee = null
             where assignee = '{$user_id}'
               and `status` = 'A'
SQL;
              $this->query($query);
        }
    }
    
}
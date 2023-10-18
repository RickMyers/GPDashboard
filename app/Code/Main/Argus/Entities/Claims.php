<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Claims DAO
 *
 * Queries involving claims
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Claims.html
 * @since      File available since Release 1.0.0
 */
class Claims extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    public function exportClaims() {
        $healthplan_clause  = ($this->getClientId()) ? "and a.health_plan_id = '".$this->getClientId()."'" : "";
        $member_clause      = ($this->getMemberNumber()) ? "and b.member_id = '".$this->getMemberNumber()."'" : "";
        $event_id_clause    = ($this->getEventId())      ? "and b.event_id = '".$this->getEventId()."'" : "";
        $event_date_clause  = ($this->getEventDate())    ? "and b.event_date = '".date('Y-m-d',strtotime($this->getEventDate()))."'" : "";
        $claim_date_clause  = ($this->getClaimDate())    ? "and date(a.modified) = '".date('Y-m-d',strtotime($this->getClaimDate()))."'" : "";
        $provider_clause    = ($this->getProviderId())   ? "and a.provider_id = '".$this->getProviderId()."'" : "";
        $name_clause        = ($this->getMemberName())   ? "and b.member_name like '%".$this->getMemberName()."%'" : "";
        $verified_clause    = ($this->getVerified())     ? "and a.verified = '".$this->getVerified()."'" : "";
        $query = <<<SQL
        SELECT a.*, b.event_id, b.event_date, b.address_id_combo as 'Event Address', b.form_type, b.screening_client, b.member_name
          FROM argus_claims AS a
          LEFT OUTER JOIN vision_consultation_forms AS b
            ON a.form_id = b.id
         where a.id is not null
           {$healthplan_clause}
           {$provider_clause}
           {$member_clause}
           {$verified_clause}
           {$claim_date_clause}
           {$event_date_clause}
           {$event_id_clause}
           {$name_clause}
SQL;
        return $this->with('argus/claims')->on('id')->query($query);
        
    }
    
    /**
     * Returns claim information joined with data taken from the actual vision consultation form
     * 
     * @return iterator
     */
    public function listClaims() {
        $healthplan_clause  = ($this->getHealthPlanId()) ? "and a.health_plan_id = '".$this->getHealthPlanId()."'" : "";
        $member_clause      = ($this->getMemberNumber()) ? "and b.member_id = '".$this->getMemberNumber()."'" : "";
        $event_id_clause    = ($this->getEventId())      ? "and b.event_id = '".$this->getEventId()."'" : "";
        $event_date_clause  = ($this->getEventDate())    ? "and b.event_date = '".date('Y-m-d',strtotime($this->getEventDate()))."'" : "";
        $claim_date_clause  = ($this->getClaimDate())    ? "and date(a.modified) = '".date('Y-m-d',strtotime($this->getClaimDate()))."'" : "";
        $provider_clause    = ($this->getProvider())     ? "and a.provider_id = '".$this->getProvider()."'" : "";
        $name_clause        = ($this->getMemberName())   ? "and b.member_name like '%".$this->getMemberName()."%'" : "";
        $verified_clause    = ($this->getVerified())     ? "and a.verified = '".$this->getVerified()."'" : "";
        $query = <<<SQL
        SELECT a.*, 
               b.event_id, b.event_date, b.event_address, b.form_type, b.screening_client, b.member_name, b.tag
          FROM argus_claims AS a
          LEFT OUTER JOIN vision_consultation_forms AS b
            ON a.form_id = b.id
         where a.id is not null
           {$healthplan_clause}
           {$provider_clause}
           {$member_clause}
           {$verified_clause}
           {$claim_date_clause}
           {$event_date_clause}
           {$event_id_clause}
           {$name_clause}
SQL;
        return $this->with('vision/consultation_forms')->on('form_id')->query($query);
    }
    
    /**
     * Returns extended data about a claim, including event information
     * 
     * @return iterator
     */
    public function extendedData() {
        $id = $this->getId();
        $claim = $this->load();
        $query = <<<SQL
                select a.*, b.*, concat(c.last_name,', ',c.first_name) as reviewer, concat(d.last_name,', ',d.first_name) as technician_name
                  from argus_claims as a
                  left outer join vision_consultation_forms as b
                    on a.form_id = b.id
                  left outer join humble_user_identification as c
                    on provider_id = c.id
                  left outer join humble_user_identification as d
                    on b.technician = d.id
                 where a.id = '{$id}'
SQL;
        if ($extended_data = $this->with('scheduler/events')->on('event_id')->query($query)->toArray()) {
            if (isset($claim['aldera_details'])) {
                $extended_data[0]['aldera_details'] = $claim['aldera_details'];
            }
        }
        
        return isset($extended_data[0]) ? $extended_data[0] : [];
    }
    
    /**
     * XREF for the claim status
     * 
     * @param string $status
     * @return string
     */
    public function expandClaimStatus($status = false) {
        $result = '';
        switch ($status) {
            case "F0"   :
                $result = 'Paid [F0]';
                break;            
            case "F1"   :
                $result = 'Paid [F1]';
                break;
            case "F2"   :
                $result = 'Denied [F2]';
                break;
            case "F4"   :
                $result = 'Pending/In-Process [F4]';
                break;
            case "P1"   :
                $result = 'Pending [P1]';
                break;            
            default:
                $result = $status;
                break;
        }
        return $result;
    }
    
    /**
     * 
     * 
     * @return type
     */
    public function duplicates() {
        $query = <<<SQL
            SELECT member_number, COUNT(*) AS cnt
              FROM argus_claims
             GROUP BY member_number
            HAVING cnt > 1                
SQL;
        return $this->query($query);
    }
    
    /**
     * 
     * @return type
     */
    public function duplicatePending() {
        $query = <<<SQL
            SELECT form_id, COUNT(*) AS cnt
              FROM argus_claims AS a
              WHERE verified = 'P'
              GROUP BY form_id
              HAVING cnt>1                
SQL;
        return $this->query($query);
    }    

    /**
     * Returns claims that haven't been either verified as paid or voided. Might need to do some other statuses as well
     * 
     * @return iterator
     */
    public function unfinishedClaims() {
        $query = <<<SQL
            SELECT * FROM argus_claims
             WHERE `verified` NOT IN ('Y','V');        
SQL;
        return $this->query($query);
    }

    /**
     * Generates the data necessary to create the Current Claim Status bar chart if you have the 'Claiming' role
     * 
     * @return array
     */    
    public function currentStatus() {
        $labels = [ "I"=>'Pending','P'=>'In-Process','A'=>'Accepted','D'=>'Denied','M'=>'Missing','N'=>'New' ];
        $skip   = [ 'V'=>true, 'Y'=>true, 'N'=>true ];
        $data   = [ 'labels'=>[],'values'=>[] ];
        $query = <<<SQL
            SELECT `verified`, COUNT(*) AS total 
              FROM argus_claims
             GROUP BY verified                
SQL;
        foreach ($results = $this->query($query) as $row) {
            if (isset($skip[$row['verified']])) {
                continue;
            }
            if (isset($labels[$row['verified']])) {
                $data['labels'][] = $labels[$row['verified']];
                $data['values'][] = $row['total'];
            }
        }
        return $data;
    }
    
    /**
     * Generates the data necessary to create the Current Claim Status bar chart if you have the 'O.D.' role
     * 
     * @return array
     */
    public function odCurrentStatus() {
        $id     = Environment::whoAmI();
        $labels = [ "I"=>'Pending','P'=>'In-Process','A'=>'Accepted','D'=>'Denied','M'=>'Missing', 'N'=>'New' ];
        $skip   = [ 'V'=>true, 'Y'=>true, 'N'=>true ];
        $data   = [ 'labels'=>[],'values'=>[] ];
        $query = <<<SQL
            SELECT `verified`, COUNT(*) AS total 
              FROM argus_claims
             WHERE provider_id = '{$id}'
             GROUP BY verified                
SQL;
        foreach ($results = $this->query($query) as $row) {
            if (isset($skip[$row['verified']])) {
                continue;
            }
            $data['labels'][] = $labels[$row['verified']];
            $data['values'][] = $row['total'];
        }
        return $data;        
    }
    
    /**
     * Returns the total value of each individual claim file
     * 
     * @return iterator
     */
    public function claimFileSums() {
        $query = <<<SQL
        SELECT claim_file, COUNT(*) AS claims, SUM(total) AS total 
          FROM argus_claims 
         WHERE `date` >= '{$this->getYear()}-01-01'
         GROUP BY claim_file;                
SQL;
        return $this->query($query);
    }

    /**
     * Returns the total amount paid by provider per claim file
     * 
     * @return iterator
     */    
    public function claimFileSumsByProvider() {
        $query = <<<SQL
            SELECT CONCAT('Dr. ',b.first_name,' ',b.last_name) AS provider, a.provider_id, a.total FROM
            (SELECT provider_id, SUM(total) AS total FROM argus_claims WHERE `date` >= '{$this->getYear()}' GROUP BY provider_id) AS a 
              LEFT OUTER JOIN humble_user_identification AS b 
                ON a.provider_id = b.id;                    
SQL;
        return $this->query($query);
    }

    /**
     * Returns the total amount paid by provider per health plan
     * 
     * @return iterator
     */    
    public function claimFileSumsByHealthplan() {
        $query = <<<SQL
            SELECT a.health_plan_id, a.total, b.client FROM
            (SELECT health_plan_id, SUM(total) AS total FROM argus_claims WHERE `date` >= '{$this->getYear()}-01-01' GROUP BY health_plan_id) AS a 
              LEFT OUTER JOIN vision_clients AS b 
                ON a.health_plan_id = b.id;                
SQL;
        return $this->query($query);
    }
    
    /**
     * 
     * 
     * @return iterator
     */
    public function claimFileClaimsByHealthplan() {
        $query = <<<SQL
            SELECT a.health_plan_id, a.claims, b.client FROM
            (SELECT health_plan_id, COUNT(*) AS claims FROM argus_claims WHERE `date` >= '{$this->getYear()}' GROUP BY health_plan_id) AS a 
              LEFT OUTER JOIN vision_clients AS b 
                ON a.health_plan_id = b.id
              ORDER BY b.client                
SQL;
        return $this->query($query);
    }
    
}
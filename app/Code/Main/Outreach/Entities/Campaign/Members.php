<?php
namespace Code\Main\Outreach\Entities\Campaign;
use Argus;
use Log;
use Environment;
/**
 *
 * Campaign Member And Contact Queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Desktop
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Members extends \Code\Main\Outreach\Entities\Entity
{

    private  $red    = 0;
    private  $green  = 0;
    private  $blue   = 0;
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    
    public function getColor() {
        $this->red    = rand(17,230);
        $this->green  = rand(17,230);
        $this->blue   = rand(17,230);
        
        return '#'.base_convert($this->red,10,16).base_convert($this->green,10,16).base_convert($this->blue,10,16);
    }
    
    public function getHighlight() {
        $this->red += 24;
        $this->green += 24;
        $this->blue += 24;
        return '#'.base_convert($this->red,10,16).base_convert($this->green,10,16).base_convert($this->blue,10,16);
    }
    /**
     * No idea what I am doing here
     * 
     * @param type $user_id
     */
    public function calculate($user_id=false) {
        if ($user_id = $user_id ? $user_id : ($this->getUserId() ? $this->getUserId() : false)) {
            $query = <<<SQL
                SELECT campaign_id, assignee, `status`, COUNT(*) AS total
                  FROM outreach_campaign_members
                  WHERE campaign_id = 3
                 GROUP BY campaign_id, assignee, `status`
                   ORDER BY assignee, `status`            
SQL;
            $obs1 = $this->query($query);
            $query = <<<SQL
                SELECT COUNT(id) AS total
                  FROM outreach_campaign_members
                 WHERE assignee = 2
                   AND `status` NOT IN ('C','R')                    
SQL;
            $obs2 = $this->query($query);
        }
    }

    
    public function campaignContacts($campaign_id=false,$status='C') {
        $results = [];
        if ($campaign_id = $campaign_id ? $campaign_id : ($this->getCampaignId() ? $this->getCampaignId() : false)) {
            $query = <<<SQL
                SELECT campaign_id, CONCAT(b.last_name, ', ',b.first_name) AS assignee_name, `status`, COUNT(*) AS total
                  FROM outreach_campaign_members AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.assignee = b.id
                  WHERE campaign_id = '{$campaign_id}'
                    AND `status` = '{$status}'
                 GROUP BY campaign_id, assignee_name, `status`
                   ORDER BY total                   
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    
    /**
     * Get count of contacts in campaign optionally excluding those of a certain status, like completed
     * 
     * @param int $campaign_id
     * @param char $status
     * @return int
     */
    public function totalContacts($campaign_id=false,$status=false) {
        $results = 0;
        if ($campaign_id = $campaign_id ? $campaign_id : ($this->getCampaignId() ? $this->getCampaignId() : false)) {
            $status_clause = ($status) ? "and `status` != '".$status."'" : "";
            $query = <<<SQL
                    select count(id) as total from outreach_campaign_members
                     where campaign_id = '{$campaign_id}'
                     {$status_clause}
SQL;
            if (count($results = $this->query($query)->toArray())) {
                $results = $results[0]['total'];
            }
        }
        return $results;
    }
    
    /**
     * Returns total number of assignments per person depending on criteria
     * 
     * @param int $user_id
     * @param mixed $campaign_id
     * @param mixed $status_equal
     * @param mixed $status_not_equal
     * @return int
     */
    public function assignments($user_id=false,$campaign_id=false,$status_equal=false,$status_not_equal=false) {
        $results = [];
        $assignee_clause = ($user_id)           ? "and assignee = '".$user_id."'" : "";
        $campaign_clause = ($campaign_id)       ? "and campaign_id = '".$campaign_id."' " : "";
        $status1_clause  = ($status_equal)      ? "and `status` = '".$status_equal."'" : "";        
        $status2_clause  = ($status_not_equal)  ? "and `status` != '".$status_not_equal."'" : ""; 
        $query = <<<SQL
                    select count(id) as total from outreach_campaign_members
                     where id is not null
                     {$assignee_clause}
                     {$campaign_clause}
                     {$status1_clause}
                     {$status2_clause}
SQL;
       $results = $this->query($query)->toArray();

        return isset($results[0]) ? $results[0]['total'] : 0;
    }
    
}
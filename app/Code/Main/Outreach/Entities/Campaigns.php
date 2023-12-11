<?php
namespace Code\Main\Outreach\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Outreach Campaigns queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Desktop
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Campaigns extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns a set of campaigns that the participant has a role in
     * 
     * @param type $participant_id
     * @return array
     */
    public function involved($participant_id=false) {
        $campaigns = [];
        if ($participant_id = $participant_id ? $participant_id : ($this->getParticipantId() ? $this->getParticipantId() : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI()))) {
            $query = <<<SQL
                SELECT a.*
                  FROM outreach_campaigns AS a
                  LEFT OUTER JOIN outreach_participant_roles AS b
                    ON a.id = b.campaign_id
                 WHERE b.participant_id = '{$participant_id}'
                   AND (b.manager = 'Y' OR b.coordinator = 'Y')
                   AND `active` = 'Y'
SQL;
           $campaigns = $this->query($query);
        }
        return $campaigns;
    }

}
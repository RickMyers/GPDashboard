<?php
namespace Code\Main\Outreach\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Outreach Participant Role methods and queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Desktop
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 */
class Roles extends Model
{

    private $userRoles = [];
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    /**
     * Will build an array of roles indexed by the participants user id
     * 
     * @param type $campaign_id
     */
    public function loadRoles($campaign_id=false) {
        if ($campaign_id = ($campaign_id) ? $campaign_id : ($this->getCampaignId() ? $this->getCampaignId() : false)) {
            foreach (Argus::getEntity('outreach/participant/roles')->setCampaignId($campaign_id)->fetch() as $roles) {
                $this->userRoles[$roles['participant_id']] = [
                    'manager' => ($roles['manager']==='Y'),
                    'coordinator' => ($roles['coordinator']==='Y')
                ];
            }
        }
        return $this;
    }
    
    /**
     * Will return the list of roles that a participant has in the current campaign
     * 
     * @param type $participant_id
     * @return type
     */
    public function participantRoles($participant_id=false) {
        $roles = ['manager'=>false,'coordinator'=>false];
        if ($participant_id = ($participant_id) ? $participant_id : ($this->getParticipantId() ? $this->getParticipantId() : ($this->getUserId() ? $this->getUserId() : false))) {
            $roles = isset($this->userRoles[$participant_id]) ? $this->userRoles[$participant_id] : $roles;
        }
        return $roles;
    }
    
}
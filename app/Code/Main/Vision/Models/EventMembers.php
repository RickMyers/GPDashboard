<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Event Member Methods
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Members.html
 * @since      File available since Release 1.0.0
 */
class EventMembers extends \Code\Main\Vision\Models\Model
{

    use \Code\Base\Humble\Event\Handler;

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
     * This methods execution is solely for the purpose of checking to see whether the member id passed to us is in our member population and if not
     * to use the rarely used 'alert' feature to signal that the person needs to enter the member into the population before assigning them to this event,
     * otherwise we just call "save" and save the event member...
     */
    public function execute() {
        $member         = $this->getMember();                                   //reference to the event/members DAO
        $member_number  = trim($this->getMemberNumber());
        $health_plan_id = null;
        if ($this->getHealthPlan() && (count($health_plan = Argus::getEntity('vision/clients')->setClient($this->getHealthPlan())->load(true)))) {
            $health_plan_id = $health_plan['id'];
        }
        $mem_data       = json_decode(Argus::getModel('vision/aldera')->setMemberId($member_number)->demographicInformation(),true);
        if ($mem_data) {
            $member->setLastName($mem_data['demographics']['last_name'])->setFirstName($mem_data['demographics']['first_name'])->setMemberName($mem_data['demographics']['last_name'].", ".$mem_data['demographics']['first_name'])->setDateOfBirth(date('Y-m-d',strtotime($mem_data['demographics']['date_of_birth'])))->setGender($mem_data['demographics']['gender'])->setMemberNumber($member_number)->setHealthPlanId($health_plan_id)->save();
        } else {
            $this->_notices("The member number was not found in Aldera");
        }
        
    }

    /**
     * This method will automatically add a member to the Outreach when he/she didn't get scanned when the event is closed.
     */
    public function addToOutreach() {
        $event_id = $this->getEventId();
        foreach(Argus::getEntity('vision/event/members')->setEventId($event_id)->fetch() as $member) {
            if($member['result'] !== 'S') {
                // Add to Outreach
                Argus::getEntity('outreach/campaign/members')->setMemberNumber($member['member_id'])->setStatus('N')->setCampaignId(7)->save();
            }
        }
    }
}
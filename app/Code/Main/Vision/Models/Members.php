<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Member Methods
 *
 * *see title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Members.html
 * @since      File available since Release 1.0.0
 */
class Members extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $members    = [];
    private $eligible   = [];
    
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
     * We are "capturing" the current member roster for a healthplan for comparison purposes later
     * 
     * @param int $healthplan_id
     */
    protected function capture($healthplan_id=false) {
        if ($healthplan_id) {
            foreach (Argus::getEntity('vision/members')->setHealthPlanId($healthplan_id)->fetch() as $member) {
                $this->members[$member['member_number']] = $member['gap_closed'];
            } 
        }
    }
    
    /**
     * We are going to compare the imported member list with our present member population. Any of our member population not on the imported list will be marked as "closed"
     * 
     * @workflow use(event)
     * @param array $eligibilityList
     */
    protected function closeGaps($health_plan_id=false,$eligibilityList=[]) {
        if ($health_plan_id && isset($eligibilityList['MEMBER_ID']) && is_array($eligibilityList['MEMBER_ID'])) {
            $member_xref = [];
            $gap_closed  = [];
            $member      = Argus::getEntity('vision/members');
            foreach ($eligibilityList['MEMBER_ID'] as $eligible_member) {
                $member_list[$eligible_member] = true;
            }
            foreach ($this->members as $member_id => $m) {
                if (!isset($member_list[$member_id])) {
                    $gap_closed[] = $member_id;
                    $member->reset()->setHealthPlanId($health_plan_id)->setMemberNumber($member_id)->setGapClosed(date('Y-m-d'))->setComment('Gap Automatically Closed')->save();
                }
            }
            if (count($gap_closed)) {
                $this->trigger('importGapsClosed',__CLASS__,["health_plan_id"=>$health_plan_id,"gaps_closed"=>count($gap_closed)]);
            }
        }
    }
    
    /**
     * Will mark this member as being a "gap closed" if the screening form is completed and the scans were readable
     */
    public function closeGap() {
        if ($form_id        = $this->getFormId()) {
            $health_plan_id = false;
            $form           = Argus::getEntity('vision/consultation/forms')->setId($form_id)->load();
            if (isset($form['screening_client']) && $form['screening_client']) {
                if (count($hp_data = Argus::getEntity('vision/clients')->setClient($form['screening_client'])->load(true))) {
                    $health_plan_id = $hp_data['id'];
                }
            }
            if ($health_plan_id) {
                if (isset($form['images_unreadable']) && ($form['images_unreadable']=='Y')) {
                    Argus::getEntity('vision/members')->setHealthPlanId($health_plan_id)->setMemberNumber($form['member_id'])->setGapClosed(null)->setComment('Gap Not Closed Due To Unreadable Images ['.date('m/d/Y').']')->save();
                } else {
                    Argus::getEntity('vision/members')->setHealthPlanId($health_plan_id)->setMemberNumber($form['member_id'])->setGapClosed(date('Y-m-d'))->setComment('HEDIS Closed Gap')->save();
                }
            }
        }
    }
    
    /**
     * Invokes the eligibility import process.  We have to first though capture the list of current members and if the member isn't included in the 
     * new eligibility list, we need to mark that as a "gap closed".
     */
    public function import() {
        @mkdir('progress/'.Environment::whoAmI(),0775,true);
        if ($hp     = Argus::getEntity('vision/clients')->setId($this->getHealthPlanId())->load()) {
            $this->capture($this->getHealthPlanId());
            $progressFile = 'progress/'.Environment::whoAmI().'/member_import.json';
            file_put_contents($progressFile,json_encode(['app'=>'member_import','row'=>0,'rows'=>0,'percent'=>0]));
            $file   = $this->getMemberList();
            $map    = Argus::importLayouts('vision/'.strtolower($hp['client']));
            $attr   = $map[0]->attributes();
            if (isset($attr->delimiter)) {
                $source = false;
                switch ($attr->delimiter) {
                    case ","    :
                        $source = Argus::getHelper('argus/CSV')->toHashTable($file['path']);
                        break;
                    case "|"    :
                    case "~"    :
                        break;
                    default     :
                        break;
                }
                if ($source) {
                    $util = Argus::getHelper('argus/import');
                    $util->xrefEntity('vision','members','member_number');
                    $util->processEligibilityFile($this->getHealthPlanId(),$source,$map,$progressFile);
                    $this->closeGaps($this->getHealthPlanId(),$util->getImportRecord());
                }
            }        
        }
    }
    
    /**
     * 
     */
    public function add() {
        $event_id       = $this->getEventId();
        $health_plan_id = $this->getHealthPlanId();
        $first_name     = $this->getFirstName();
        $last_name      = $this->getLastName();
        $member_number  = $this->getMemberNumber();
        $gender         = $this->getGender();
        $hba1c          = $this->getHba1c();
        $hba1c_date     = $this->getHba1cDate();
        $fbs            = $this->getFbs();
        $fbs_date       = $this->getFbsDate();
        if ($dob        = $this->getDateOfBirth()) {
            $dob        = date('Y-m-d',strtotime($dob));
        }
        $member_id      = Argus::getEntity('vision/members')->setHealthPlanId($health_plan_id)->setLastName($last_name)->setFirstName($first_name)->setDateOfBirth($dob)->setGender($gender)->setMemberNumber($member_number)->save();
        $address        = $this->getAddress();
        if ($address && ($address_id     = Argus::getEntity('vision/addresses')->setAddress($address)->setCity($this->getCity())->setState($this->getState())->setZipCode($this->getZipCode())->save())) {
            Argus::getEntity('vision/member_addresses')->setMemberId($member_id)->setAddressId($address_id)->save();
        }
        if ($event_id && $member_id) {
           if ($event_member_id = Argus::getEntity('vision/event_members')->setEventId($event_id)->setMemberId($member_id)->setHba1c($hba1c)->setHba1cDate($hba1c_date)->setFbs($fbs)->setFbsDate($fbs_date)->save()) {
               Argus::getModel('vision/forms')->setEventId($event_id)->generate();
               if ($data = Argus::getEntity('vision/event_members')->setId($event_member_id)->load()) {
                   if ($data['form_generated']=='Y') {
                       Argus::getEntity('vision/missing_members')->setHealthPlanId($health_plan_id)->setMemberNumber($member_number)->delete(true);
                   }
               }
           }
        }
    }

}
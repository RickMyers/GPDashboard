<?php
namespace Code\Main\Vision\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Member utilities
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @since      File available since Release 1.0.0
 */
class Members extends Helper
{

    private $xref = [
        'HEALTH PLAN' => 'health_plan',
        'MEMBER NAME' => 'member_name',
        'MEMBER ID' => 'member_id',
        'EVENT DATE' => 'event_date',
        'APPT TIME' => 'appt_time',
        'PCP' => ''
    ];
      
    
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

    public function upload() {
        $stuff      = $this->getMemberData();
        $helper     = Argus::getHelper('argus/CSV');
        if (isset($stuff['path']) && file_exists($stuff['path'])) {
            $event_id   = Argus::getEntity('vision/events')->setDate($this->getEventDate())->setOffice($this->getOfficeName())->setAddress($this->getOfficeAddress())->save();
            $arr        = [];
            $obs        = [];
            $data       = $helper->toHashTable($stuff['path']);
            $member_orm = Argus::getEntity('vision/event_members');
            foreach ($data as $member) {
                if ($member['MBR ID']){
                    $member_orm->reset();
                    $member_orm->setMemberName($member['MBR (LAST,FIRST)']);
                    $member_orm->setMemberId($member['MBR ID']);
                    $member_orm->setDateOfBirth(date('Y-m-d',strtotime($member['MBR DOB'])));
                    $member_orm->setMemberAddress($member['MBR ADDRESS']);
                    $member_orm->setEventDate(date('Y-m-d',strtotime($member['DATE'])));
                    $member_orm->setFbs($member['FBS']);
                    $member_orm->setA1c($member['A1C']);
                    $member_orm->setTypeOne($member['TYPE 1 DM']);
                    $member_orm->setTypeTwo($member['TYPE 2 DM']);
                    $member_orm->setControlled($member['CONTROLLED']);
                    $member_orm->setUncontrolled($member['UNCONTROLLED']);
                    $member_orm->setYrsDiabetic($member['# YRS DIABETIC']);
                    $member_orm->save();
                }
            }
        }
    }
}
<?php
namespace Code\Main\Vision\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Event Scheduling Helper
 *
 * Assorted utilities for working with managing vision scanning/screening
 * events
 *
 * PHP version 7.2+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-Event.html
 * @since      File available since Release 1.0.0
 */
class Event extends Helper
{

    use \Code\Base\Humble\Event\Handler;
    
    private $default = [
        'health_plan'=>'',
        'health_plan_id'=>''
        ];

    private $xref = [
        "APPT TIME"                                     => "TIME",
        "APPT TIME AMPM"                                => "TIME",
        "PCP LAST NAME FIRST NAME"                      => "PCP",
        "PCP NAME"                                      => "PCP",        
        "PCPS NPI NUMBER"                               => "PCP NPI",
        "PRACTICE NAME"                                 => "PRACTICE GROUP",
        "IPA IF APPLICABLE"                             => "IPA",
        "EVENT LOCATION EX 123 MAIN ST TAMPA FL 33607"  => "EVENT LOCATION",
        "HEALTH PLAN"                                   => "HEALTH PLAN",
        "EVENT LOCATION NPI NUMBER"                     => "LOCATION NPI",
        "LOCATION NPI"                                  => "LOCATION NPI",
        "MEMBER NAME LAST NAME FIRST NAME"              => "MEMBER NAME",
        "MEMBER ID NUMBER"                              => "MEMBER ID",
        "GENDER MF"                                     => "GENDER",
        "HBA1C"                                         => "HBA1C",
        "HBA1C DATE RETRIEVED"                          => "HBA1C DATE",
        "FBS"                                           => "FBS",
        "FBS DATE RETRIEVED"                            => "FBS DATE",
        "DIABETES TYPE USE DROPDOWN ONLY"               => "DIABETES TYPE"
    ];
    
    private $address_xref = [
        'NORTH'=>'N',
        'N.'=>'N',
        'SOUTH'=>'S',
        'S.'=>'S',
        'EAST'=>'E',
        'E.'=>'E',
        'WEST'=>'W',
        'W.'=>'W',
        'ROAD'=>'RD',
        'RD.'=>'RD',
        'PARKWAY'=>'PKWY',
        'PKWY.'=>'PKWY',
        'PK'=>'PARK',
        'PK.'=>'PARK',
        'AVENUE'=>'AV',
        'AV.'=>'AV',
        'AVE'=>'AV',
        'AVE.'=>'AV',
        'STREET'=>'ST',
        'STR'=>'ST',
        'STR.'=>'ST',
        'ST.'=>'ST',
        'BOULEVARD'=>'BLVD',
        'BLVD.'=>'BLVD',
        'BD' => 'BLVD',
        'LANE'=>'LN',
        'LN.'=>'LN',
        'DRIVE' => 'DR',
        'DRV' => 'DR',
        'DRV.' => 'DR',
        'DR.' => 'DR',
        'HIGHWAY' => 'HWY',
        'HWY.' => 'HWY',
        'CIRCLE' => 'CIR',
        'CIR.' => 'CIR'
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

    /**
     * Gets rid of unnecessary characters or too many spaces within the address and replaces abbreviations with their expanded variation
     * 
     * @param type $address
     * @return string
     */
    public function fixAddress($address=false)   {
        $result = '';
        if ($address) {
            $address = str_replace([","],[" "],$address);                       //first get rid of extraneous commas
            $address = str_replace(["  "],[" "],$address);                      //then get rid of any extra space that might have caused
            $addr    = explode(' ',$address);
            foreach ($addr as $idx => $word) {
                if (isset($this->address_xref[$word])) {
                    $addr[$idx] = $this->address_xref[$word];
                }
            }
            $result = implode(' ',$addr);
        }
        return $result;
    }
    
    /**
     * Normalizes and records a healthplans address so that it can be looked up later or selected form a drop down list
     */
    public function recordLocation() {
        $this->setAddress($address = trim($this->fixAddress(strtoupper($this->getAddress()))));
        $this->setCity($city = trim(strtoupper($this->getCity())));
        $this->setState($state = trim(strtoupper($this->getState())));
        $this->setZipCode($zip_code = trim(strtoupper($this->getZipCode())));
        $health_plan = Argus::getEntity('vision/clients')->setClient($this->getHealthPlan())->load(true);
        $this->setHealthPlanId($health_plan['id']);
        $this->setFullAddress(trim($address).', '.trim($city).', '.trim($state).', '.trim($zip_code));
        Argus::getEntity('vision/locations')->setHealthPlanId($health_plan['id'])->setAddress1($address)->setCity($city)->setState($state)->setZipCode($zip_code)->save();
    }
    
    /**
     * Adds a member to an existing event
     * 
     * @param object $member_orm
     * @param int $event_id
     * @param string $member_id
     * @param object $member
     * @return int
     */
    protected function addMemberToEvent($member_orm,$event_id,$member) {
        $member_orm->reset();
        $member_orm->setEventId($event_id)->setHealthPlan($member['HEALTH_PLAN']);
        foreach ($member as $field => $value) {
            if (!$field = trim($field)) {
                continue;   //gets rid of any blank rows
            };
            $method = 'set'.$this->underscoreToCamelCase(strtolower($field));
            $member_orm->$method($value);
        }
        return $member_orm->setMemberNumber($member_id)->save();        
    }
    
    /**
     * Associates a member to an address
     * 
     * @param type $mem_address_orm
     * @param type $member_id
     * @param type $address_id
     * @return type
     */
    protected function addMemberAddress($mem_address_orm,$member_id,$address_id) {
        return $mem_address_orm->reset()->setAddressTypeId(1)->setMemberId($member_id)->setAddressId($address_id)->save();
    }
    
    /**
     * Just adds an address to our database of addresses
     * 
     * @param type $address_orm
     * @param type $mem_address_orm
     * @param type $member_id
     * @param type $member
     * @return type
     */
    protected function addAddress($address_orm, $mem_address_orm, $member_id, $member) {
        $address1 = ''; $city = ''; $state = ''; $zip = ''; $address_id = false;
        $parts = explode(',',$member['MEMBER ADDRESS']);
        if (substr_count($member['MEMBER ADDRESS'],',') == 4) {
            $address1 = $parts[0]; $city = $parts[1]; $state=$parts[2]; $zip=$parts[3];
        } else {
            $text   = str_replace([","],[" "],$member['MEMBER ADDRESS']);
            $text   = str_replace(["  "],[" "],$text);
            $words  = explode(' ',$text);
            $zip    = $words[count($words)-1];
            $state  = $words[count($words)-2];
            $city   = $words[count($words)-3];
            $address1 = $this->fixAddress(implode(" ",array_slice($words,0,count($words)-3)));
        }
        if ($address1 && $city && $state && $zip) {
            if ($address_id = $address_orm->reset()->setAddress($address1)->setCity($city)->setState($state)->setZipCode($zip)->save()) {
                $this->addMemberAddress($mem_address_orm,$member_id,$address_id);
            }
        }            
        return $address_id;
    }
    
    /**
     * Create an account for a new PCP and send email
     * 
     * @param type $pcp
     * @param type $npi
     */
    /*private function createPCPAccount($pcp=false,$npi=false) {
        $user = Argus::getEntity('humble/users');
        if ($pcp && $npi) {
            $name  = explode(",",$pcp);
            $uname = substr(trim(strtolower($name[1])),0,1).strtolower(trim($name[0]));
            //@TODO: Check that the user name doesn't already exist
            if ($uid = $user->setUserName($uname)->save()) {
                Argus::getEntity()->setId($uid)->setFirstName(trim($name[1]))->setLastName($name[0])->save();
                $this->sendEmail('rickmyers1969@gmail.com','New PCP Registered','Dr. '.$name[1].' '.$name[0]);
            }
        }
    }*/
    
     /**
     * 
     * @param type $members
     * @param type $report
     * @return type
     */
    protected function processUploadedMembers($members=[],$report) {
        $aldera      = Argus::getModel('vision/aldera');                        
        $event_orm   = Argus::getEntity('vision/event/members');
        $event_id    = $report['event_id'];
        foreach ($members as $member) {
            $m = [];
            foreach ($member as $field => $value) {                             //The HEDIS folks changed the column names to a format that I can't read properly using CSV tool
                if ($field && isset($this->xref[trim($field)])) {
                   $m[$this->xref[trim($field)]] = $value;                      //This changes them back to how I need them to process.  It's a klugey fix
                }
            }
            $member = $m;
            if (isset($member['MEMBER ID']) && $member['MEMBER ID']) {
                $member_number  = explode('*',$member['MEMBER ID']);            //this is done because Freedom tends to add an *01/-01 to the end of the member number
                $member_number  = explode('-',$member_number[0]);
                $member_number  = $member_number[0];
                if ($member_dmg = json_decode($aldera->setMemberId($member_number)->emographicInformation(),true)) {
                    $report['members_processed']++; $report['members']['added'][] = $member;
                    foreach ($member as $field => $value) {                 //This routine replaces spaces with underscores in the keys to keep it consistent
                        unset($member[$field]);
                        $member[str_replace(' ','_',strtolower(trim($field)))] = (strpos($field,'DATE') && $value) ? date('Y-m-d',strtotime($value))  : $value;
                    }
                    $member = array_merge($member, $member_dmg['demographics']);
                    if (!isset($hp_xref[$member['health_plan']])) {
                        $hp_xref[$member['health_plan']] = Argus::getEntity('vision/clients')->setClient($member['health_plan'])->load(true);
                    }
                    //we try to get the client id from 
                    if (!$health_plan_id = isset($client_xref[strtoupper($member['health_plan'])]) ? $client_xref[strtoupper($member['health_plan'])] : false) {
                        $health_plan_id = isset($hp_xref[$member['health_plan']]) ? $hp_xref[$member['health_plan']]['id'] : $this->default['health_plan'];
                    }
                    $event_orm->reset();
                    foreach ($member as $field => $value) {
                        if (isset($extract_fields[$field]) && !$extract_fields[$field]) {
                            $extract_fields[$field] = $value;
                        }
                        if (!$field = trim($field)) {
                            continue;   //gets rid of any blank rows
                        };
                        $method = 'set'.$this->underscoreToCamelCase($field,true);
                        $event_orm->$method($value);
                    }
                    if ($event_id && $health_plan_id && $member_number) {
                        $attendees[] = $event_orm->setEventId($event_id)->setHealthPlanId($health_plan_id)->setMemberNumber($member_number)->save();                            
                    }
                } else {
                    $report['members_skipped']++; $report['members']['error'][] = $member;
                    //this is where we add the missing member info
                }
            }
        }
        return $report;
    }
    
    /**
     * We are going to be processing a specifically formatted CSV rather than just a general one
     * 
     * @workflow use(event) emit(eventUploaded)
     */
    public function newUpload() {
        $report             = [
            'event_id' => $this->getEventId(),
            'members' => [
                "added" => [],
                "error" => []
            ],
            'members_processed' => 0,
            'members_skipped' => 0
        ];        
        $member_file        = $this->getMemberList();
        $extract_fields     = [
            'location_npi' => false
        ];
        $attendees          = [];     
        $client_xref        = [];
        foreach (Argus::getEntity('vision/clients')->fetch() as $client) {
            $client_xref[strtoupper($client['client'])] = $client['id'];
        }        
        //make the XREF uppercase, because we can't trust anyone anymore
        $x = [];
        foreach ($this->xref as $field => $value) {
            $x[trim(strtoupper($field))] = $value;
        }
        $this->xref = $x;
        if ($member_file && isset($member_file['path']) && file_exists($member_file['path'])) {
            $data = explode("\n",file_get_contents($member_file['path']));
            $fields = []; $member_flag = false; $members = [];
            foreach ($data as $line) {
                if (trim($line)) {
                    if ($member_flag || ($member_flag = (substr($line,0,4)==='APPT'))) {
                        $members[] = $line;
                    } else {
                        $fields[] = $line;
                    }
                }
            }
            if (count($members)) {
                file_put_contents($member_file['path'],implode("\n",$members));
                $report = $this->processUploadedMembers(Argus::getHelper('argus/CSV')->toHashTable($member_file['path']),$report);
            }
        }
        $this->_notices("Members Added To Event: ".$report['members_processed']."<br><br>Members Skipped (no member information): ".$report['members_skipped']."<br><br>");
        $this->trigger('membersUploadedToEvent',
                __CLASS__,
                __METHOD__,
                $report);
        return $report;
   }
   
   /**
    * Runs some basic tests on an event schedule, highlighting any problem with it
    * 
    * @return string
    */
   public function test() {
       $result = ["The following errors were encountered:\n"];
       if ($schedule = $this->getSchedule()) {
           if ($rows = Argus::getHelper('argus/CSV')->toHashTable($schedule['path'])) {
               $headers = [];
               $match   = [];
               foreach ($rows[0] as $header => $value) {
                   $headers[trim($header)] = $header;
               }
               foreach ($this->xref as $alias => $header) {
                   $match[$header] = $match[$header] || isset($headers[$alias]);
               }
               foreach ($match as $header => $ok) {
                   if (!$ok) {
                       $result[] = "The ".$header." column was not found or did not match spec";
                   }
               }
           } else {
               $result[] = "Could not process the file";
           }
       }
       if (count($result)===1) {
           $result[] = "\n\tNo Errors Found";
       }
       return implode("\n",$result);
   }
   
   /**
    * 
    */
   public function recap() {
       
   }
   
}
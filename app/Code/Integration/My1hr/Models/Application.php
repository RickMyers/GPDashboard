<?php
namespace Code\Integration\My1hr\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * My1HR Methods
 *
 * Functionality used in support of integrating with My1HR
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Application.html
 * @since      File available since Release 1.0.0
 */
class Application extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $agent      = null;
    
    /**
     * Constructor
     */
    public function __construct() {
        \Event::register('my1hr','my1hrMemberImport','A member has been extracted from the CSV and needs to be added to Aldera');
        $this->agent    = Argus::getEntity('my1hr/application_agents');
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

    public function storeAgentInfo($row=false) {
        if (!isset($row['EPPID'])) {
            return;
        }
        $this->agent->reset();
        $this->agent->setEppid($row['EPPID'])->setAgentName($row['AGENCY NAME'])->setAgencyName($row['AGENCY NAME']);
        $this->agent->setAgentNpn($row['AGENT NPN'])->setSubproducer($row['SUBPRODUCER'])->setLineOfCoverage($row['LINE OF COVERAGE']);
        $this->agent->setRatingArea($row['RATING AREA'])->setPlan($row['PLAN ELECTED'])->setPremium($row['MONTHLY PREMIUM'])->setNetPremium($row['NET MONTHLY PREMIUM']);
        $this->agent->setRelationship($row['RELATIONSHIP'])->setIsSubscriber($row['IS SUBSCRIBER'])->setSubscriberId($row['SUBSCRIBER ID'])->setMemberId($row['MEMBER ID']);
        $this->agent->save();
    }
    
    /**
     * Will store key elements of data from importing a member from my1hr
     * 
     * @workflow use(process) configuration(/my1hr/application/store)
     * @param type $EVENT
     */
    public function store($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch(); 
            if ($source = isset($data[$cfg['source_field']]) ? $data[$cfg['source_field']] : false) {
                $app = Argus::getEntity('my1hr/applications');
                foreach ($data[$cfg['result_field']] as $result) {
                    $app->reset(); $member = $result['member'];
                    $id = $EVENT->_id();
                    $app->setMongoId($EVENT->_id());
                    $app->setFirstName($member['first-name'])->setLastName($member['last-name'])->setGender($member['gender'])->setSsn($member['ssn'])->setApplicationId($source['application-id'])->setDob(date("Y-m-d",strtotime($member['DOB'])));
                    $app->setAddress1($member['address1'])->setAddress2($member['address2'])->setCity($member['city'])->setState($member['state'])->setZipCode($member['zip']);
                    $app->setEppid($member['eppid']);
                    if (isset($result['aldera']->SubscriberAddResult) || isset($result['aldera']->DependentAddResult)  ) {
                        $who = isset($result['aldera']->SubscriberAddResult) ? 'SubscriberAddResult' : 'DependentAddResult';
                        $app->setStatusMessage($result['aldera']->$who->StatusMessage)->setStatusCode($result['aldera']->$who->StatusCode);
                        if (isset($result['aldera']->$who->MemberID) && $result['aldera']->$who->MemberID) {
                            $app->setAlderaId($result['aldera']->$who->MemberID);
                        }
                    }
                    $app_id = $app->save();
                }
            }
        }        
    }
    
    /**
     * Groups related members from the CSV upload into accounts for processing
     * 
     * @param type array
     * @return array
     */
    protected function groupRelatedMembers($data) {
        $accounts = [];
        foreach ($data as $row) {
            if (!isset($row['EPID'])) {
                continue;
            }
            $row['REQ EFFECTIVE DATE'] = $row['REQ. EFFECTIVE DATE'];
            unset($row['REQ. EFFECTIVE DATE']);                                 //Mongo doesn't like field names with periods.... got to swap and remove
            if (!isset($accounts[$row['EPID']])) {
                $accounts[$row['EPID']] = ["Self" => false, "Spouse"=> false, 'Child' => []];
            }
            switch ($row['RELATIONSHIP']) {
                case "Child" :
                    $accounts[$row['EPID']]['Child'][] = $row;
                    break;
                default     :
                    $accounts[$row['EPID']][$row['RELATIONSHIP']] = $row;
                    break;
            }
        }
        return $accounts;
    }
    
    /**
     * This process records the arrival of an application from My1HR into the online_applications table
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function recordApplication($EVENT=false) {
        if ($EVENT!==false) {
            
        }
    }
    
    private function correctDate($date=false) {
        $date = explode('/',$date);
        if (strlen((string)$date[2])<4) {
            $date[2] = ((int)$date[2]<20) ? '20'.$date[2] : '19'.$date[2];
        }
        return implode('/',$date);
    }
    
    /**
     * Will throw an event of 'my1hrMemberImport' 
     * 
     * @workflow use(process) configuration(/my1hr/application/csv)
     * @param type $EVENT
     */
    public function processCSV($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (isset($data[$cfg['csv_field']]) && $data[$cfg['csv_field']]) {
                $rows   = Argus::getHelper('argus/CSV')->strToHashTable($data[$cfg['csv_field']]);
                foreach ($rows as $row) {
                    $this->storeAgentInfo($row);
                }
                \Argus::cache('aldera_session_id',false);  //make sure to get a new session id
                $accounts = $this->groupRelatedMembers($rows);
                foreach ($accounts as $epid => $row) {
                    if (!$epid) {
                        continue; //this is a cheesy hack for when I get a blank row, which shouldn't be there to begin with
                    }
                    $self       = isset($row['Self'])   ? $row['Self'] : false;
                    $spouse     = isset($row['Spouse']) ? $row['Spouse'] : false;
                    $children   = isset($row['Child']) ? $row['Child'] : [];
                    $struct = [
                        "application-id" => $self['POLICY NUMBER'],
                        "start-date"     => date('Y-m-d',strtotime($self['REQ EFFECTIVE DATE'])),
                        "end-date"       => '9999-12-31',
                        "subscriber" => [
                            'ssn'       => ((($self['SSN']=='N/A') || !$self['SSN'] ) ? '000-00-0000' : $self['SSN']),
                            'gender'    => substr($self['GENDER'],0,1),
                            'relation'  => 'Self('.ucfirst(strtolower($self['GENDER'])).")",
                            'first-name'=> $self['FIRST NAME'],
                            'last-name' => $self['LAST NAME'],
                            'DOB'       => $this->correctDate($self['DOB']),
                            'email'     => strtolower($self['EMAIL']),
                            'phone'     => $self['PHONE 1'],
                            "address1"  => $self['ADDRESS LINE 1'],
                            "address2"  => $self['ADDRESS LINE 2']==='N/A' ? '' : $self['ADDRESS LINE 2'],
                            "city"      => $self['CITY'],
                            "state"     => $self['STATE'],
                            "zip"       => $self['ZIP CODE'],     
                            "eppid"     => $self['EPPID'],
                            "vision"    => $self['PLAN ELECTED']==='MasterPlan with Vision',
                            'dependents'=> [
                                
                            ]
                        ],
                        "addresses" => [
                            "home" => [
                                "address1"  => $self['ADDRESS LINE 1'],
                                "address2"  => $self['ADDRESS LINE 2']==='N/A' ? '' : $self['ADDRESS LINE 2'],
                                "city"      => $self['CITY'],
                                "state"     => $self['STATE'],
                                "zip"       => $self['ZIP CODE']
                            ]
                        ]
                    ];
                    if ($spouse) {
                        $struct['subscriber']['dependents'][] = [
                            "relation" => (($spouse['GENDER']==="Female")? 'Wife' :'Husband'),
                            'first-name' => $spouse['FIRST NAME'],
                            'last-name' => $spouse['LAST NAME'],
                            'gender'    => substr($spouse['GENDER'],0,1),
                            'ssn'       => ((($spouse['SSN']=='N/A') || !$spouse['SSN']) ? '000-00-0000' : $spouse['SSN']),
                            'DOB'       => $this->correctDate($spouse['DOB']),
                            'phone'     => $spouse['PHONE 1'],
                            "address1"  => $spouse['ADDRESS LINE 1'],
                            "address2"  => $spouse['ADDRESS LINE 2']==='N/A' ? '' : $spouse['ADDRESS LINE 2'],
                            "city"      => $spouse['CITY'],
                            "state"     => $spouse['STATE'],
                            "zip"       => $spouse['ZIP CODE'],
                            "email"     => strtolower($spouse['EMAIL']),
                            "eppid"     => $spouse['EPPID']
                        ];
                    }
                    foreach ($children as $child) {
                        $struct['subscriber']['dependents'][] = [
                            "relation" => (($child['GENDER']==="Female")? 'Daughter' :'Son'),
                            'first-name' => $child['FIRST NAME'],
                            'last-name' => $child['LAST NAME'],
                            'gender'    => substr($child['GENDER'],0,1),
                            'ssn'       => ((($child['SSN']=='N/A') || !$child['SSN']) ? '000-00-0000' : $child['SSN']),
                            'DOB'       => $this->correctDate($child['DOB']),
                            'phone'     => $child['PHONE 1'],
                            "address1"  => $child['ADDRESS LINE 1'],
                            "address2"  => $child['ADDRESS LINE 2']==='N/A' ? '' : $child['ADDRESS LINE 2'],
                            "city"      => $child['CITY'],
                            "state"     => $child['STATE'],
                            "zip"       => $child['ZIP CODE'],
                            "email"     => strtolower($child['EMAIL']),
                            "eppid"     => $child['EPPID']
                        ];
                    }
                    $this->fire($this->_namespace(),$cfg['event_name'],[$cfg['member_field']=>$struct]);
                }
                Argus::cache('aldera_session_id',false); //blow away session id to prevent caching for too long
            }
        }
    }    
}
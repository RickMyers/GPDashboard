<?php
namespace Code\AFLAC\Aldera\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Aldera related methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @since      File available since Release 1.0.0
 */
class Manager extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $relationshipXref = [
        'Self'          => '1',
        'Self(Female)'  => '1',
        'Self(Male)'    => '1',
        'Son'           => '3',
        'Daughter'      => '3',
        'Husband'       => '2',
        'Wife'          => '2',
        'Spouse'        => '2',
        'Father or Mother' => '2'
    ];
    
    /**
     * Constructor
     * 
     * We are going to use a cached session ID if available, or if not, we will get a new session id and cache if for future use
     */
    public function __construct() {
        parent::__construct();
     //   if (!$session_id = Argus::cache('aldera_session_id')) {
     //       Argus::cache('aldera_session_id',$session_id = Argus::getModel('aldera/core')->getAlderaAuthentication()->LoginResult->SessionID);
     //   };
     //   $this->setSessionId($session_id);
    }
    
    /**
     * Removes any unneeded transaction elements
     * 
     * @param type $transaction
     * @return type
     */
    protected function filterTransaction($data) {
        foreach ($data as $var => $val) {
            if (is_array($val)) {
                $data[$var] = $this->filterTransaction($val);
                if (!$data[$var]) {
                    unset($data[$var]);
                }
            } else {
                if (!$val && ($val !== 0)) {
                    unset($data[$var]);
                }
            }
        }
        return $data;
    }
    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    protected function subscriberAdd($subscriber=false,$addr=false,$effective_date=false) {
        if (isset($subscriber['ssn']) && $subscriber['ssn']) {
            $this->setSocialSecurityNumber(str_replace('-','',$subscriber['ssn']));
        }                
        $this->setPhoneNumber(str_replace(['(','-',' ',')'],['','','',''],$subscriber['phone']));
        $this->setLastName($subscriber['last-name'])->setFirstName($subscriber['first-name'])->setBirthDate(date('m/d/Y',strtotime($subscriber['DOB'])));
        $this->setSmoker('N')->setGender($subscriber['gender'])->setRelationshipCode($this->relationshipXref[$subscriber['relation']]);
        $this->setEmailAddress($subscriber['email']);
        $this->setAddressLine1($addr['address1'])->setCity($addr['city'])->setState($addr['state'])->setZipCode((isset($addr['zip']) ? $addr['zip'] : $addr['zip-code']));
        //Everybody gets IND now... it's converted to FAM if they add dependents later
        $this->setEffectiveDate(date('m/d/Y',strtotime($effective_date)))->setCoverageCode((count($subscriber['dependents']) ? 'IND' : 'IND'));
        $result = $this->getNewAlderaMember();
        return $result;
    }
    
    protected function dependentAdd($dependent=false) {
        $this->setFirstName($dependent['first-name']);
        $this->setLastName($dependent['last-name']);
        $this->setGender($dependent['gender']);
        $this->setBirthDate(date('m/d/Y',strtotime($dependent['DOB'])));
        $this->setRelationshipCode($this->relationshipXref[$dependent['relation']]);
        if (isset($dependent['phone']) && $dependent['phone']) {
            $this->setPhoneNumber(str_replace(['(','-',' ',')'],['','','',''],$dependent['phone']));
        }
        $this->setCoverageCode('IND');
        $this->setSocialSecurityNumber('');
        if (isset($dependent['ssn']) && $dependent['ssn']) {
            $this->setSocialSecurityNumber(str_replace('-','',$dependent['ssn']));
        }
        //$this->setAddressLine1($dependent['address1']);
       // $this->setCity($dependent['city']);
       // $this->setState($dependent['state']);
       // $this->setZipCode($dependent['zip']);   
        return $this->getNewAlderaDependent();
    }
    /**
     * From a field in the event, extracts data to create a new subscriber and dependents in Aldera
     * 
     * @workflow use(process) configuration(/aldera/subscriber/addconfig)
     * @param event $EVENT
     * 
     */
    public function addSubscriber($EVENT=null) {
        if ($EVENT!==false) {
            $dat      = $EVENT->load();
            $cfg      = $EVENT->fetch();
            $result   = isset($cfg['result']) ? $cfg['result'] : 'new_aldera_subscriber';
            $outcomes = [];
            if (isset($dat[$cfg['field']])) {
                $this->setGroupGID((isset($dat['GroupGID']) && $dat['GroupGID']) ? $dat['GroupGID'] : 271);
                $data       = $dat[$cfg['field']];
                $outcomes[] = ['Aldera' => $subscriber = $this->subscriberAdd($data['subscriber'],$data['addresses']['home'],$data['start-date']),'member'=>$data['subscriber'], 'subscriber'=>true];                     
                //now we do the dependents...
                if ($subscriber && isset($subscriber->SubscriberAddResult) && isset($subscriber->SubscriberAddResult->MemberID)) {
                    $this->setMemberGID($subscriber->SubscriberAddResult->MemberGID)->setMemberID($subscriber->SubscriberAddResult->MemberID)->setSubscriberGID($subscriber->SubscriberAddResult->SubscriberGID);
                    foreach ($data['subscriber']['dependents'] as $dependent) {
                        $outcomes[] = ['Aldera' => $outcome = $this->dependentAdd($dependent), 'member' => $dependent, 'subscriber'=> false];
                    }
                }
                if ($subscriber && isset($subscriber->SubscriberAddResult->SubscriberGID) && $subscriber->SubscriberAddResult->SubscriberGID) {
                    if (isset($data['subscriber']['vision']) && $data['subscriber']['vision']) {
                        $this->setMemberGID($subscriber->SubscriberAddResult->MemberGID);
                        $this->setSubscriberGID($subscriber->SubscriberAddResult->SubscriberGID);
                        $this->setMemberID($subscriber->SubscriberAddResult->MemberID);
                        $outcomes[0]['Aldera'] = array_merge((array)$outcomes[0]['Aldera'],['Vision'=>$this->getVisionCoverage()]);
                    }
                }                
            }
            $EVENT->update([$result=>$outcomes],true);
        }
    }

    /**
     * Was a subscriber added successfully
     * 
     * @workflow use(decision) configuration(/aldera/subscriber/added)
     * @param event $EVENT
     * 
     */    
    public function subscriberAdded($EVENT=false) {
        $added = false;
        if ($EVENT!==false) {
            $data = $EVENT->load(); 
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['field']])) {
                $members    = (array)$data[$cfg['field']];
                $added      = (isset($members[0]['Aldera']->SubscriberAddResult->StatusCode) && ($members[0]['Aldera']->SubscriberAddResult->StatusCode == 'Successful'));
            } else {
                die('Field not set');
            }
        }
        return $added;
    }

    /**
     * Test method for adding an additional coverage option to a member
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function addVis($EVENT=false) {
        if ($EVENT!==false) {
            
        }
    }
    
    /**
     * Will test whether we can connect to Aldera
     * 
     * @workflow use(process)
     */
    public function testConnection($EVENT=false) {
        $response = $this->getAlderaAuthentication();
        print(json_encode($response));
        $EVENT->update(['connection'=>$response]);
    }
    
    /**
     * Will add coverage to a subscriber based on fields in the event
     * 
     * @workflow use(process) configuration(/aldera/subscriber/coverage)
     * @param type $EVENT
     */
    public function addCoverage($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
    }
}
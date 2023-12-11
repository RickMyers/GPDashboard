<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Consultation Forms Methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Forms extends Model
{

    use \Code\Base\Humble\Event\Handler;

	/**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns a mixed-case alpha-numeric for use in things like generating passwords.  Default size is 6 letters, but you can make it any size you'd like
     *
     * @param type $size
     * @return string
     */
    public function userName($size = 6) {
        $token = '';
        $alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
        for ($i=0; $i<$size; $i++) {
            $token .= substr($alpha,rand(0,60),1);
        }
        return $token;
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
     * Finds any IPAs that dont have an assigned user ID and creates one for them...
     */
    public function createIpaUserIds() {
        $user   = Argus::getEntity('humble/users');
        $info   = Argus::getEntity('humble/user_identification');
        $ipa_orm = Argus::getEntity('vision/ipas');
        foreach (Argus::getEntity('vision/ipas')->setUserId(null)->fetch() as $ipa) {
            if (!$ipa['user_id']) {
                $uid = $user->reset()->setUserName($this->userName(13))->setResetPasswordToken($this->_uniqueId())->setPassword(MD5('argus1234'))->setAuthenticated('N')->save();
                $ipa_orm->reset()->setUserId($uid)->setId($ipa['id'])->save();
                $info->reset()->setEntityName($ipa['ipa'])->setId($uid)->save();
                
            }
        }
    }
    
    /**
     * This method takes the text value of the IPA name and gets the associated IPA ID (or creates it) and assigns it to the form
     */
    public function assignIpaId() {
        $form   = Argus::getEntity('vision/consultation/forms');
        $xref   = [];
        $ipa    = Argus::getEntity('vision/ipas');
        $user   = Argus::getEntity('humble/users');
        $info   = Argus::getEntity('humble/user_identification');
        foreach (Argus::getEntity('vision/consultation/forms')->fetch() as $obs) {
            if (isset($obs['ipa_id_combo']) && $obs['ipa_id_combo']) {
                $ipa_name = strtoupper($obs['ipa_id_combo']);
                if ($ipa_name == 'N/A') {
                    continue;
                }
                if (!isset($xref[$ipa_name])) {
                    $uid = $user->reset()->setUserName($this->userName(13))->setNewPasswordToken($this->_uniqueId())->setAuthenticated('N')->save();
                    $xref[$ipa_name] = $ipa->reset()->setUserId($uid)->setIpa($ipa_name)->save();
                    $info->reset()->setEntityName(ucwords($ipa_name))->setId($uid)->save();
                }
                $form->reset()->setId($obs['id'])->setIpaId($xref[$ipa_name])->save();
            }
        }        
    }
    
    /**
     * This process will total the number of vision records (forms) that are unassiged to an O.D. and sitting in a submitted state.
     * 
     * @workflow use(process) configuration(/vision/forms/unassigned)
     * @param type $EVENT
     */
    public function countUnassigned($EVENT=false) {
        $unassigned = 0;
        if ($EVENT!==false) {
            $cfg = $EVENT->fetch();
            $unassigned = Argus::getEntity('vision/consultation/forms')->unassigned();
        }
        $EVENT->update([$cfg['field']=>$unassigned]);
    }
    
    /**
     * Will get the name of the client and store that in the consultation form using the client id
     */
    public function screeningClient() {
        $form_id    = $this->getFormId();
        $client_id  = $this->getClientId();
        if ($form_id && $client_id) {
            if ($client = Argus::getEntity('vision/clients')->setId($client_id)->load()) {
                Argus::getEntity('vision/consultation/forms')->setId($form_id)->setScreeningClient($client['client'])->save();
            }
        }
    }
    
    /**
     * Checks to see if this form has been flagged as being "out of network", which means not handled by Aldera.  We will need to send this to administration to get it handled
     */
    public function checkWithholding() {
        if ($form_id = $this->getId()) {
            if ($data = Argus::getEntity('vision/consultation/forms')->setId($form_id)->load()) {
                if (isset($data['pcp_portal_withhold']) && ($data['pcp_portal_withhold']=='Y')) {
                    $this->referToAdministration($form_id,"Authorize to release to PCP Portal");
                }
            }
        }
    }
    
    /**
     * Checks to see if this forms fields were unlocked to allow write in information, if so refer to administration for address validation
     */
    public function checkFormLock() {
        if ($form_id = $this->getId()) {
            if ($data = Argus::getEntity('vision/consultation/forms')->setId($form_id)->load()) {
                if (isset($data['form_locked']) && ($data['form_locked']=='N')) {
                    $this->referToAdministration($form_id,"Unlocked Form. Check Information for Accuracy");
                }
            }
        }
    }
    
    /**
     * These are checks to make sure key fields have values.  These fields are used for the PCP and IPA portals
     * 
     * @TODO - Review this logic
     */
    public function checkForIpaAndLocationValues() {
        if ($form_id = $this->getId()) {
            $form = Argus::getEntity('vision/consultation/forms');
            if ($data = $form->setId($form_id)->load()) {
                if (!(isset($data['client_id']) && $data['client_id'])) {
                    //hmmm
                }
                if (!(isset($data['location_id']) && $data['location_id'])) {
                    //for future use
                }
                if (!$data['ipa_id']) {
                    $ipa = Argus::getEntity('vision/ipas')->setIpa($data['ipa_id_combo'])->load(true);
                    if ($ipa) {
                        $form->reset()->setId($form_id)->setIpaId($ipa['id'])->save();
                    } else {
                        //$this->referToAdministration($form_id,"New IPA Encountered");
                    }
                } else {
                    //check to make sure the IPA_ID matches whats in the text field
                    //review this
              //      if ($ipa = Argus::getEntity('vision/ipas')->setIpa($data['ipa_id_combo'])->load(true)) {
               //         if (!($ipa['id'] == $data['ipa_id'])) {
                //            $this->referToAdministration($form_id,"IPA Mismatch, redo the IPA Selection");
                      //  }
//                    } else {
                       // $this->referToAdministration($form_id,"New IPA Encountered");
                    //}
                }
            }
        }
    }
    
    /**
     * Releases the Form to the relevant PCP portal by setting the status to the previous status and removing the hold
     * 
     * @param int $form_id
     */
    public function releaseToPCPPortal($form_id=false) {
        $message    = 'Form was not released, contact support';
        $form_id    = ($form_id) ? $form_id : ($this->getFormId() ? $this->getFormId() : ($this->getId() ? $this->getId() : false));
        if ($data = Argus::getEntity('vision/consultation/forms')->setId($form_id)->load()) {
            if (Argus::getEntity('vision/consultation/forms')->setId($form_id)->setStatus($data['previous_status'])->setClaimStatus('Y')->setPcpPortalWithhold('N')->save()) {
                $message    = 'Form was released to portal';
            }
        }
        return $message;
    }
    
    /**
     * Will capture the current status of a form and save that while moving the form to the administration queue while recording the reason for the referral
     * 
     * @param type $form_id
     * @param type $reason
     */
    public function referToAdministration($form_id=false,$reason=false) {
        $reason     = ($reason)  ? $reason  : ($this->getReason() ? $this->getReason : false);
        $form_id    = ($form_id) ? $form_id : ($this->getFormId() ? $this->getFormId() : ($this->getId() ? $this->getId() : false));
        if ($reason && $form_id) {
            if ($data = Argus::getEntity('vision/consultation/forms')->setId($form_id)->load()) {
                Argus::getEntity('vision/consultation/forms')->setId($form_id)->setPreviousStatus($data['status'])->setReferralReason($reason)->setStatus('A')->save();
            }
        }
    }
    
    /**
     * Attaches the values set in the form to the event in a field identified in the configuration page
     * 
     * @workflow use(process) configuration(/vision/forms/load)
     * @param type $EVENT
     */
    public function load($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['form_id']) && ($cfg['form_id']) && isset($data[$cfg['form_id']])) {
                if (isset($cfg['field']) && $cfg['field']) {
                    $EVENT->update([ $cfg['field'] => Argus::getEntity('vision/consultation/forms')->setId($data[$cfg['form_id']])->load() ]);
                } else {
                    //throw exception for missing required fields
                }
            } else {
                //throw exception for missing required fields
            }
        }
    }
    
    /**
     * Retrieves current consultation forms workloads and does some pre processing
     * 
     * @return iterator
     */
    public function workloads() {
        $workloads = Argus::getEntity('vision/consultation/forms')->workloads();
        $this->setSubmitted(0);
        $this->setReviewed(0);
        $this->setQueued(0);
        foreach ($workloads as $workload) {
            switch ($workload['status']) {
                case "N"    : //NEW/Queued
                    $this->setQueued((int)$workload['count']);
                    break;
                case "R"    : //Reviewed
                    $this->setReviewed((int)$workload['count']);
                    break;
                case "S"    : //Submitted
                    $this->setSubmitted((int)$workload['count']);
                    break;
                default:
                    break;
            }
        }
        return $workloads;
    }
    
    /**
     * We have to map the fields coming in from the Health Plan Event to our very poorly named fields that are in the screening form.
     * 
     * This is the result of not having enough time to do proper design on the form...
     * 
     * "There are 2 hard problems in computer science: cache invalidation, naming things, and off-by-1 errors."
     * 
     */
    public function generate() {
        //during the creation of the form and generate process, the field names were not consistent.  Due to 2 years worth of "legacy" forms we have to support,
        //we have to do a cross reference with the field names between the import process and the display process.  This sux.
        $clients = []; $oclients = [];   //oclients is total cheese to fix a prod issue... this needs to be rethought...
        $PCP     = Argus::getModel('argus/PCP');
        foreach (Argus::getEntity('vision/clients')->fetch() as $client) {
            $clients[strtoupper($client['client'])] = $client['id'];                        //need to look this up, so we are just going to hash cache this 
            $oclients[$client['id']] = $client['client'];
        }
        if ($event_id = $this->getEventId()) {
            $form   = Argus::getEntity('vision/consultation/forms');
            $em     = Argus::getEntity('vision/event/members');
            $event  = Argus::getEntity('scheduler/events')->setId($event_id)->load();
            foreach (Argus::getEntity('vision/event/members')->setEventId($event_id)->setFormGenerated('N')->attendees() as $member) {
                foreach ($member as $field => $value) {
                    $member[$field] = is_array($value) ? $value : trim($value);
                }
                if (isset($member['form_generated']) && ($member['form_generated']=='Y')) {
                    continue;
                }
                $bom = pack('H*','EFBBBF');                                     //Due to the various ways we get this "stuff", there might be a byte-order-mark.  We have to remove it.
                foreach ($member as $var => $val) {
                    $member[preg_replace("/^$bom/", '', $var)] = $val;
                }
                $form->reset();
                $form->setTag($form->generateFormTag());
                $form->setNpiIdCombo(isset($event['npi_id_combo']) ? $event['npi_id_combo'] : '');
                $form->setEventId($member['event_id']);
                $form->setEventDate($member['start_date']);
                if (isset($member['time'])) {                //because different healthplans pass us the time differently, i gotta do this
                    if ($member['time']) {
                        $member['time'] = strtoupper($member['time']);
                        $time = explode(':',$member['time']);
                        if (count($time)>=3) {                                  //Removes the seconds if it detects them
                            unset($time[2]);
                        }
                        if (strpos($member['time'],'AM') || strpos($member['time'],'PM')) {
                            $time[0] = (int)$time[0]+(strpos($time[1],'PM') ? 12 : 0);
                        } else {
                            $time[0] = ((int)$time[0] === 0) ? '12' : $time[0];
                        }
                        $t = str_replace(['AM','PM',' '],['','',''],implode(':',$time).':00');
                        $form->setEventTime(str_replace(['AM','PM',' '],['','',''],implode(':',$time).':00'));
                    }
                }
                $form->setMemberName($member['last_name'].", ".$member['first_name']);
                $form->setDateOfBirth(date('m/d/Y',strtotime($member['date_of_birth'])));
                $location_id = isset($member['practice_group']) && $member['practice_group'] ? $member['practice_group'] : $event['location_id'];
                $form->setLocationIdCombo($event['location_id_combo'])->setLocationId($event['location_id']);
                $form->setAddressIdCombo($event['address_id_combo'])->setAddressId($event['address_id']);
                $form->setIpaIdCombo($event['ipa_id_combo'])->setIpaId($event['ipa_id']);
                $form->setMemberId($member['member_number']);
                $form->setMemberAddress($member['address_full'].', '.$member['city'].', '.$member['state'].', '.$member['zip_code']);
                $form->setClientId($clients[strtoupper($member['health_plan'])]);                
                $form->setScreeningClient($member['health_plan']);
                $form->setLastActivity(date('Y-m-d H:i:s'));
                $form->setCreated(date('Y-m-d H:i:s'));
                $form->setLastAction('Created Form For Event');
                $form->setHba1c(isset($member['hba1c']) ? $member['hba1c'] : '');
                if (isset($member['pcp_npi']) && $member['pcp_npi']) {
                    if ($data = $PCP->setNumber($member['pcp_npi'])->info()) {
                        if ($data = json_decode($data,true)) {
                            $member['pcp'] = $data['results'][0]['basic']['last_name'].', '.$data['results'][0]['basic']['first_name'];
                        }
                    }
                }
                $form->setPrimaryDoctorCombo(isset($member['pcp']) ? $member['pcp'] : '');
                $form->setPhysicianNpiCombo(isset($member['pcp_npi']) ? $member['pcp_npi'] : '');
                $form->setGender(isset($member['gender']) ? $member['gender'] : '');
                $form->setSubmitter(Environment::whoAmI());                                             
                $form->setCreatedBy(Environment::whoAmI());
                if (isset($member['hba1c']) && $member['hba1c']) {
                    if ((float)$member['hba1c'] >= 7.0) {
                        $form->setDmAlltype('uncontrolled');
                    } else {
                        $form->setDmAlltype('controlled');
                    }
                }
                if (isset($event['screening_technician']) && $event['screening_technician']) {                   
                    $form->setTechnician($event['screening_technician']);
                    $form->setFormType('scanning');                                        
                    $form->setStatus('N');
                } else if (isset($event['screening_od']) && $event['screening_od']) {
                    $form->setReviewer($event['screening_od']);
                    $form->setSubmitted(date('Y-m-d H:i:s'));
                    $form->setFormType('screening');
                    $form->setPcS3000('Y');
                    $form->setPc_2023f('Y');
                    $form->setStatus('S');
                }
                $form->setFbs(isset($member['fbs']) ? $member['fbs']: '');
                $form->setHba1cDate(isset($member['hba1c_date']) ? date('m/d/Y',strtotime($member['hba1c_date'])) : '');
                $form->setFbsDate(isset($member['fbs_date']) ? date('m/d/Y',strtotime($member['fbs_date'])) : '' );
               
                //fix this
                if (isset($member['diabetes_type'])) {
                    $form->setTypeDm(((int)$member['diabetes_type'] === 1) ? 't1' : 't2');
                } else {
                    $form->setTypeDm('');
                }
                $form->save();
                $em->reset()->setMemberId($member['member_number'])->setEventId($event_id)->setFormGenerated('Y')->save();
           }
       }
    }
}
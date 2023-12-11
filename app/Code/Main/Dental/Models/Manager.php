<?php
namespace Code\Main\Dental\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * HEDIS related methods
 *
 * Methods supporting HEDIS activities
 *
 * NOTE:  "Household" and "Contact" can and are used interchangeably.  Because a household has contact information (1 to 1), but we have a relationship of 1 to many participants in the household/contact
 * PHP version 5.6+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Manager extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $nc_payor = [
            'entity_type'   => '2',
            'name'          => 'PRESTIGE',
            'id_code'       => 'ARGUS',
            'street_address' => '4010 W STATE ST',
            'street_address_2' => '',
            'city'          => 'TAMPA',
            'state'         => 'FL',
            'zip_code'      => '33609'
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
     * Unassigned HEDIS related calls have been assigned to available hygenist consultant(s)
     * 
     * @workflow use(EVENT)
     */    
    public function assignments() {
        /**
         * Warning!  There's a very data dependent pre-processing that we have to do prior to actually trying to do the assignments
         */
        $input                = json_decode($this->getData(),true);
        $campaign_id          = $input['campaign_id'];
        $consultants          = [];
        $calls_per_consultant = [];
        $hygenist_calls       = [];
        foreach ($input as $token => $value) {
            $data = explode("_",$token);
            if (substr($token,0,18) == "hygenist_contacts_") {
                $calls_per_consultant[$data[2]] = $value;
            } else if (substr($token,0,11)  == "consultant_") {
               $data = explode("_",$token);
               $consultants[$data[1]] = $value;               
            }
        }
        $call       = Argus::getEntity('dental/contact_call_schedule');
        $calls      = $call->setCampaignId($campaign_id)->fetchUnassignedContacts();                  //returns the iterator
        $calls      = $calls->toArray();                            //I just want an array... it is easier
        $total      = $input['number_of_contacts'];
        $call_ctr   = 0;
        $eoc        = false;
        foreach ($consultants as $user_id => $active) {
            if ($active == 'Y') {
                $number_of_calls = $calls_per_consultant[$user_id];
                $hygenist_calls  = [];
                $hygenist_ctr    = 0;
                while ($hygenist_ctr < $number_of_calls && !($eoc)) {
                    $current_call    = $calls[$call_ctr];
                    $call->reset()->setId($current_call['id'])->setAssignee($user_id)->save();
                    $call_ctr++;
                    $hygenist_ctr++;
                    $eoc =  ($call_ctr >= $total) ;                    //end of call stack
                }
                $this->trigger('HEDISConsultantAssigned',__CLASS__,__METHOD__,[
                    "consultant"=> $user_id,
                    "date_assigned" => date('Y-m-d H:i:s'),
                    "calls"=>    $hygenist_calls
                ]);                
            }
            //check to see if we are throwing this twice...
            if ($eoc) {
                break;
            }
        }
    }
    
    /**
     * Returns a call to assignment queue, recording the reason why
     * 
     * @workflow use(EVENT)
     */
    public function returnCallToAssignment() {
        $contact_id = $this->getContactId();
        $call       = Argus::getEntity('dental/contact_call_schedule')->setId($contact_id);
        $log        = Argus::getEntity('dental/contact_call_log')->setContactId($contact_id)->setUserId($this->getUserId())->setComments($this->getComments());       
        $call->load();
        $attempts = $call->getNumberOfAttempts();
        $call->setAssignee(null)->setStatus(HEDIS_CONTACT_RETURNED);
        if ($this->getCallAttempted()=='Y') {
            $attempts += 1;
            $call->setNumberOfAttempts($attempts);
            $log->setTimeOfCall($this->getTimeOfCall());
        }
        $call->save();
        $log->setAttempt($attempts)->save();
    }
    
    /**
     * Sets the HEDIS Dental Contact status
     * 
     * @workflow use(process) configuration(/dental/contact/status)
     */
    public function setContactStatus($EVENT) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['contact_id_field']])) {
                Argus::getEntity('dental/contact_call_schedule')->setId($data[$cfg['contact_id_field']])->setStatus($cfg['status'])->save();
            }
        }
    }
    
    /**
     * Updates a contact with service information and the participants response who live at the contact address.  Also marks a contact "complete" if we have responses from each participant in the household
     * 
     * @workflow use(EVENT)
     */
    public function updateHedisContact() {
        $participants   = [];
        $contact_data   = json_decode($this->getData(),true);
        $contact_id     = $contact_data['contact_id'];
        $contact        = Argus::getEntity('dental/contact_call_schedule');
        //only update contact if call was attempted
        if ($contact_data['call_attempted']=='Y') {
            $original_contact = $contact->setId($contact_id)->load();
            $contact->setLastActivityDate(date('Y-m-d H:i:s'));
            $contact->setWorkingNumber(isset($contact_data['working_number']) ? $contact_data['wrong_number'] : null);
            $contact->setWrongNumber(isset($contact_data['wrong_number']) ? $contact_data['wrong_number'] : null);
            if (isset($contact_data['status']) && ($contact_data['status'])) {
                if ($contact->getStatus() !== $contact_data['status']) {
                    $contact->setStatus($contact_data['status']);
                    $contact->setStatusChangeDate(date('Y-m-d H:i:s'));
                }
            }
            $contact->setLeftMessage(isset($contact_data['left_message']) ? $contact_data['left_message'] : null);
            foreach ($contact_data as $field => $value) {
                if (substr($field,0,15)=='appt_requested_') {
                    $parts      = explode('_',$field);
                    $user_id    = $parts[2];
                    if (!isset($participants[$parts[2]])) {
                        $participants[$user_id]=[];
                    }
                    $participants[$user_id]['appointment_requested'] = $value;
                } else if (substr($field,0,19)=='yearly_dental_visit') {
                    $parts      = explode('_',$field);
                    $user_id    = $parts[3];
                    if (!isset($participants[$parts[3]])) {
                        $participants[$user_id]=[];
                    }
                    $participants[$user_id]['yearly_dental_visit'] = $value;
                } else if (substr($field,0,20)=='counseling_completed') {
                    $parts      = explode('_',$field);
                    $user_id    = $parts[2];
                    if (!isset($participants[$parts[2]])) {
                        $participants[$user_id]=[];
                    }
                    $participants[$user_id]['counseling_completed'] = $value; 
                }
            }
            $result     = Argus::getEntity('dental/campaign_results'); 
            foreach ($participants as $member_id => $participant) {
                $skip = false;                                                  //this is a fix for when a member was in a previous campaign
                foreach ($result->reset()->setMemberId($member_id)->fetch() as $obs) {
                    if ($obs['counseling_completed'] === 'Y') {
                        $skip = true;
                    }
                }
                if (!$skip) {
                    $result->reset();
                    $result->setContactId($contact_data['contact_id']);
                    $result->setCampaignId($contact_data['campaign_id']);
                    $result->setMemberId($member_id);
                    $result->setRequestedAppointment($participant['appointment_requested']);
                    $result->setCounselingCompleted($participant['counseling_completed']);
                    $result->setYearlyDentalVisit($participant['yearly_dental_visit']);
                    $result->save();
                }
            }
            $contact->save();
            $contact = Argus::getEntity('dental/contact_call_schedule')->setId($contact_id);
            $contact->load();
            if (($contact->getStatus()==='A') && ((int)$contact->getNumberOfAttempts() > 3 )) {
                $contact->setStatus(HEDIS_CONTACT_60DAYHOLD)->save();
            }
        } else {
            //no need to record since we didn't attempt call
        }
        //however, we do allow you to leave a comment
        if (trim($contact_data['additional_comments'])) {
            $log = Argus::getEntity('dental/contact_call_log');
            $log->setComments($contact_data['additional_comments']);
            $log->setContactId($contact_data['contact_id']);
            $log->setAttempt($contact->getNumberOfAttempts());
            $log->setTimeOfCall($contact_data['time_of_call']);
            $log->setUserId(Environment::whoAmI());
            $log->save();
        }
    }
    
    /**
     * Creates a random claim 9 digit claim id
     * 
     * @return type
     */
    private function generateClaimId() {
        $num = '';
        for ($i=0; $i<9; $i++) {
            $num .= rand(1,9);
        }
        return $num;
    }
    
    /**
     * Converts unclaimed Nutritional Counselings into 837 claims files
     * 
     * @workflow use(process) configuration(/dental/hedis/claims)
     * @param type $EVENT
     */
    public function createNutritionalCounselingClaims($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
        $exclude             = [];
        $provider_collection = Argus::getModel('edi/providers');
        $providers           = Argus::getEntity('edi/providers');
        $HL = 0;
        foreach ($providers->setIdCode('1568768489')->fetch() as $provider) {
            $subscribers            = Argus::getEntity('dental/campaign_results')->newClaims();   //First we get a list of people who we will file claims for
            $subscriber_collection  = Argus::getModel('edi/subscribers');                  //Then we allocate a "collection" object 
            $provider_phone         = Argus::getEntity('dental/phone_numbers')->setId($provider['phone_number_id'])->load();
            $address                = Argus::getEntity('dental/addresses')->setId($provider['address_id'])->load();
            $provider_metadata      = [
                'hierarchical_level' => ++$HL,
                'has_children'       => 1,
                'street_address'     => (isset($address['address']) ? $address['address'] : ''),
                'street_address_2'   => '',
                'city'               => (isset($address['city']) ? $address['city'] : ''),
                'state'              => (isset($address['state']) ? $address['state'] : ''),
                'zip_code'           => (isset($address['zip_code']) ? $address['zip_code'] : ''),
                'provider_name'      => $provider['first_name'].' '.$provider['last_name'],
                'phone_number'       => (($provider_phone) ? $provider_phone['phone_number'] : "")
            ];
            $provider    = array_merge($provider,$provider_metadata)    ;
            $provider_hl = $HL;
            foreach ($subscribers as $sub_idx => $subscriber) {
                if (isset($exclude[trim($subscriber['first_name']).' '.trim($subscriber['last_name'])])) {
                    print("Skipping ".$subscriber['first_name'].' '.$subscriber['last_name']."\n");
                    $skipped++;
                    continue;
                }
                $claim_collection   = Argus::getModel('edi/claims');                      //We get a claim collection per user        
                $claim_collection->setLineItemControlBase(date('Ymd'));
                $service_collection = Argus::getModel('edi/services');                    //Then we get a list of services, in this case, there's only one service
                $subscriber_hl = ++$HL;
                //We add our 1 service to the collection
                $service_collection->add('3',1,[
                    'procedure_code' => 'AD:D1310',
                    'amount' => '74',
                    'line_item_number' => $subscriber['id']
                ]);
                if (!$subscriber['state']) {
                    $subscriber['state'] = 'FL';
                }
                //Then add our service collection containing one service to our claim collection
                $claim_collection->add([
                'has_children'          => '0',
                'location_information'  => '11:B:1',
                'entity_code'           => '1',
                'claim_date'            => date('Ymd'),
                'amount'                => '74',
                'provider_name'         => $provider['provider_name'],
                'last_name'             => $provider['last_name'],
                'first_name'            => $provider['first_name'],
                'identification_code'   => $provider['id_code'],
                'specialty_code'        => $provider['specialty_code'],
                'license_number'        => $provider['license_number']
                ])->addServices($service_collection); 
                $subscriber_collection->add([
                    'hierarchical_level' => $subscriber_hl,
                    'parent_hierarchical_level' => $provider_hl,
                    'group_number' => 'PRESTIGE',
                    'member_id' => $subscriber['member_id'],
                    'last_name' => $subscriber['last_name'],
                    'first_name' => $subscriber['first_name'],
                    'street_address' => $subscriber['address'],
                    'date_of_birth' => date('Ymd',strtotime($subscriber['date_of_birth'])),
                    'street_address_2' => '',
                    'gender' => $subscriber['gender'],
                    'state' => $subscriber['state'],
                    'city'  => $subscriber['city'],
                    'zip_code' => $subscriber['zip_code']
                ],$this->nc_payor)->addClaims($claim_collection);                                // and then we add our claim containing one service to our subscriber collection
            }
            $provider_collection->add($provider)->addSubscribers($subscriber_collection);
        }

        $x837 = Argus::getModel('edi/x837');
        $claim_num = $this->generateClaimId();
        $x837->setHeader(Argus::getModel('edi/header')->create([
                'sender_id'                     => 'ARGUS          ',
                'receiver_id'                   => 'ARGUS          ',
                'control_number'                => $claim_num,
                'prod_flag'                     => 'P',   /* default to test */
                'receiving_partner_id'          => 'ARGUS',
                'sending_partner_id'            => 'ARGUS',
                'group_control_number'          => $claim_num,
                'transaction_control_number'    => '0001'
        ]));
        $x837->setSubmitter(Argus::getModel('edi/submitter')->create(Argus::getEntity('edi/submitters')->setIdCode('900117186')->load(true)));
        $x837->setReceiver(Argus::getModel('edi/receiver')->create(Argus::getEntity('edi/receivers')->setId(1)->load()));
        $x837->setFooter(Argus::getModel('edi/footer')->create([
            'transaction_control_number'    => '0001',
            'group_number'                  => $claim_num,
            'control_group_number'          => $claim_num
        ]));
        $x837->generate($provider_collection,'hedis_dental')->write('hedisclaims_20170710a.837');
    }
    
}
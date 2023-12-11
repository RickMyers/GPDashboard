<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Claim Generation
 *
 * A class for managing the generation of vision claims
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Claims.html
 * @since      File available since Release 1.0.0
 /* -----------------------------------------------------------------------------
 * 
 * INSTRUCTIONS:
 * 
 * This tool ultimately generates 837 files based upon a configurable templates
 * at the individual level.
 * 
 * The 837 is organized as the following:
 * 
 * - HEADER
 * |
 * + SUBMITTER
 * |
 * + RECEIVER
 * |
 * + PROVIDER
 *      |
 *      + SUBSCRIBER
 *      |
 *      + PAYOR
 *           |
 *           + -- + CLAIMS
 *                | 
 *                + SERVICES
 * 
 * Each Indentation above indicates a 1..n (one to many) relationship
 * 
 * Each one to many relationship is managed by a collection, so we have the following
 * relationships:
 * 
 *  Subscribers    <-- Collection to manage Subscribers
 *      |
 *      + Subcriber   <-- Persistant Object Per Subscriber
 *            |
 *          Claims    <-- Collection to manage Claims
 *            |
 *            + Claim           <-- Persistant Object Per Claim
 *                 | 
 *              Services    <-- Collection to manage Services
 *                 |
 *                 + Service    <-- Persistant Object Per Service
 */
class Claims extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private    $errors              = [];
    private    $unprocessed         = [];
    private    $no_diagnosis        = [];
    private    $bad_data            = [];
    private    $missing_npi         = [];
    private    $bad_address         = [];
    private    $location_id         = [];
    private    $unreadable          = [];
    private    $provider_collection = null;
    private    $processed           = [];
    private    $health_plans        = [];
    private    $payor = [
        'entity_type'       => '2',
        'name'              => 'ARGUS',
        'id_code'           => 'ARGUS',
        'street_address'    => '4010 W STATE ST',
        'street_address_2'  => '',
        'city'              => 'TAMPA',
        'state'             => 'FL',
        'zip_code'          => '33609'
    ];
    private    $modifiers = [
        '50' => 'H5',
        '40' => 'H4',
        '10' => 'H2',
        '5'  => 'H1',
        '0'  => ''
    ];
    private    $rates  = [
        'S3000' => [
            'local' => '40',
            'remote' => '50'
        ],
        '2022F' => [
            'local' => '0',
            'remote' => '0'
        ],    
        '2022F8P' => [
            'local' => '0',
            'remote' => '0'
        ],            
        '3072F' => [
            'local' => '0',
            'remote' => '0'
        ],            
        '5010F' => [
            'local' => '0',
            'remote' => '0'
        ],      
        'G8397' => [
            'local' => '0',
            'remote' => '0'
        ],            
        '92227' => [
            'local' => '10',
            'remote' => '10'
        ],    
        '92228' => [
            'local' => '10',
            'remote' => '10'
        ],    
        '2026F' => [
            'local' => '0',
            'remote' => '0'
        ],       
        '2033F' => [
            'local' => '0',
            'remote' => '0'
        ]
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
     * Sends a notification VIA sockets through the Argus Hub (Node.js server)
     */
    public function available() {
        Argus::emit('VisionClaimReady',['date' => date('Y-m-d'),'time'=>date('H:i:s'),'form_id'=>$this->getFormId()]);
    }
    
    /**
     * Sends a notification VIA sockets through the Argus Hub (Node.js server)
     */
    public function noncontractedClaimAvailable() {
        Argus::emit('NoncontractedClaimReady',['date' => date('Y-m-d'),'time'=>date('H:i:s'),'form_id'=>$this->getFormId()]);
    }
    
    /**
     * Will take the claims and organize them by the provider to more align with the sections of the 837
     * 
     * @return array
     */
    private function batchClaimsByProviders($number_to_run,$claim_list=false) {
        //------------------------------------------------------------------------------
        //First we group the forms by who reviewed them... the provider
        $provider_members = [];
        foreach (Argus::getEntity('vision/consultation/forms')->batchClaims($number_to_run,$claim_list) as $idx => $form) {
            if (isset($form['reviewer']) && $form['reviewer']) {
                if (!isset($provider_members[$form['reviewer']])) {
                    $provider_members[$form['reviewer']] = [];
                }
                $provider_members[$form['reviewer']][] = $form;
            } else {
                $this->errors[] = $form['id'];
            }
        }
        $claims = Argus::getEntity('argus/claims');
        if ($claim_list) {
            $claim_list = explode(',',str_replace('"','',$claim_list));
            foreach ($claim_list as $form_id) {
                if (count($data = $claims->reset()->setFormId($form_id)->load(true))) {
                    $claims->reset()->setId($data['id'])->setVerified('V')->save();
                }
            }
        }
        //if claim list, mark claims as voided:
        //
        //
        //
        return $provider_members;
    }
    
    /**
     * Will read through a screening/scanning form and try to pick out the diagnosis
     * 
     * @param array $subscriber
     * @return array
     */
    private function determineDiagnosis($subscriber=false) {
        $diagnosis  = [];
        $codes      = [];
        $labels     = [];
        $srch       = ['_',' ','.'];
        $repl       = ['','',''];
        $eyes       = [
            '1'     => 'RT',
            '2'     => 'LT',
            '3'     => '50',
            '9'     => ''
        ];
        if ($subscriber) {
            foreach ($subscriber as $field => $value) {
                if (substr($field,0,9) == "diag_code") {
                    $codes[substr($field,10)] = $value;
                } else if (substr($field,0,8) == "lbl_code") {
                    $labels[substr($field,9)] = $value;
                }
            }
        }
        foreach ($codes as $code => $enabled) {
            if ($enabled == 'Y') {
                $d = str_replace('_','',strtoupper($code));
                if (isset($labels[$code])) {
                    $d .= ':'.$eyes[substr($labels[$code],-1)];
                    $code = $labels[$code];
                }
                $tag = count($diagnosis) ? "ABF" : "ABK";
                $diagnosis[] = '*'.$tag.':'.strtoupper($code);
            }
        }
        return str_replace($srch,$repl,$diagnosis);
    }

    /**
     * Smooths out provider related information
     * 
     * @param type $HL
     * @param type $provider
     * @param type $address
     * @param type $provider_phone
     * @return type
     */
    private function scrubProviderData($HL,$provider=[],$address=[],$provider_phone=[]) {
        return [
                'hierarchical_level' => $HL,
                'has_children'       => 1,
                'street_address'     => (isset($address['address']) ? $address['address'] : ''),
                'street_address_2'   => '',
                'city'               => (isset($address['city']) ? $address['city'] : ''),
                'state'              => (isset($address['state']) ? $address['state'] : ''),
                'zip_code'           => (isset($address['zip_code']) ? $address['zip_code'] : ''),
                'provider_name'      => $provider['first_name'].' '.$provider['last_name'],
                'phone_number'       => (($provider_phone && $provider_phone['phone_number']) ? $provider_phone['phone_number'] : "8138640625")
            ];
    }
    
    /**
     * Determines the proper order a diagnosis should be if there is more than one diagnosis
     * 
     * @param array $diagnosis
     * @return string
     */
    private function determineCodeOrder($diagnosis=[]) {
        $code_order     = '';
        for ($i=1; $i<=count($diagnosis); $i++) {
            $code_order .= ($code_order) ? ':'.$i : $i;
        }        
        return $code_order;
    }

    /**
     * Based upon certain criteria, here we determine what modifiers to apply to the procedure to get the correct reimbursement rate
     * 
     * @param array $members
     * @param array $subscriber
     * @param date $service_date
     * @param string $code_order
     */
    private function determineServiceRate($subscriber,$services,$service_date,$code_order) {
        $s = [];
        foreach ($services as $service => $set) {
            $subscriber['event_type'] = isset($subscriber['event_type']) ? $subscriber['event_type'] : 'local';
            $rate     = isset($this->rates[$service][$subscriber['event_type']]) ? $this->rates[$service][$subscriber['event_type']] : '0';
            $modifier = isset($this->modifiers[$rate]) ? $this->modifiers[$rate] : false;
            $s[] = [
                'procedure_code'    => 'HC:'.$service.($modifier ? ':'.$modifier : ''),
                'amount'            => $rate,
                'line_item_number'  => $subscriber['id'],
                'service_date'      => $service_date,
                'code_order'        => $code_order
            ];
        }
        return $s;
    }

    /**
     * Looks through the various fields for set Procedure "PQRS" Codes... returns an array of any found
     * 
     * @param array $subscriber
     * @return array
     */
    protected function determineServicesRendered($subscriber = []) {
        $services   = [];
        foreach ($subscriber as $var => $val) {
            if ((substr($var,0,3)=='pc_') && ($val=='Y')) {
                $services[strtoupper(substr($var,3))] = $val;
            }
        }
        return $services;
    }
    
    /**
     * Simply records the results of this batch run
     */
    protected function recordBatchResults() {
        $exam = Argus::getEntity('vision/consultation/forms');
        $this->setTotals([
            'No Diagnosis'          => count($this->no_diagnosis),
            'Unreadable Images'     => count($this->unreadable),
            'Unable To Process'     => count($this->unprocessed),
            'Bad Member Information'=> count($this->bad_data),
            'Bad Address Format'    => count($this->bad_address),
            'Missing NPI Information'=> count($this->missing_npi),
            'Business Name/Location' => count($this->location_id),
            'Total Claims Processed'=> count($this->processed)
        ]);
        foreach ($this->no_diagnosis as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('No Diagnosis')->save();
        }
        foreach ($this->unreadable as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Images Unreadable')->save();
        }
        foreach ($this->unprocessed as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Form Error')->save();
        }
        foreach ($this->bad_data as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Member Data Missing or Incorrect')->save();
        }
        foreach ($this->bad_address as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Event Address Incorrect Format')->save();
        }
        foreach ($this->location_id as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Business Name or Location error')->save();
        }        
        foreach ($this->missing_npi as $form) {
            $exam->reset()->setId($form['id'])->setStatus('A')->setLastStatus('C')->setClaimStatus('E')->setReason('Missing Location or Physician NPI')->save();
        }        
        foreach ($this->processed as $form) {
            $exam->reset()->setId($form['id'])->setClaimStatus('Y')->save();
        }
    }
    
    /**
     * Xref a Health Plan name to get their ID value, caching it for later lookups
     * 
     * @param string $health_plan
     * @return int
     */
    protected function resolveHealthPlan($health_plan = false) {
        $health_plan_id = null;
        if ($health_plan) {
            if (isset($this->health_plans[$health_plan])) {
                $health_plan_id = $this->health_plans[$health_plan];
            } else {
                if (count($data = Argus::getEntity('vision/clients')->setClient($health_plan)->load(true))) {
                    $health_plan_id = $this->health_plans[$health_plan] = $data['id'];
                }
            }
        }
        return $health_plan_id;
    }
    
    /**
     * Goes through the provider->subscriber->claim->service relationships logging all of the individual parts
     * 
     * @param accumulator $provider_collection
     */
    protected function logProcessedClaims($provider_collection,$claim_file) {
        $claim_log      = Argus::getEntity('argus/claims');
        $service_log    = Argus::getEntity('argus/claim_services');
        $report         = ['providers'=>[],'claims'=>0,'totals'=>$this->getTotals(),'claim_totals'=>[]];
        //This records the results... but what else can we do with it?
        foreach ($provider_collection->providers() as $provider) {
            $provider_name = $provider->parameters()['last_name'].', '.$provider->parameters()['first_name'];
            $report['providers'][$provider_name] = [];
            $provider_claim_total = 0;
            foreach ($provider->subscribers() as $subscriber) {
                foreach ($subscriber->claims() as $claim) {
                    ++$report['claims'];
                    $report['providers'][$provider_name][] = [
                        'claim_number'  => $claim->getClaimNumber(),
                        'member_number' => $subscriber->getMemberId(),
                        'form_id'       => $claim->getFormId(),
                        'date'          => $claim->getClaimDate(),
                        'claim_total'   => $claim->getTotal()
                    ];
                    $provider_claim_total += $claim->getTotal();
                    $claim_id = $claim_log->reset()->setClaimFile($claim_file)->setHealthPlanId($claim->getHealthPlanId())->setFormId($claim->getFormId())->setClaimNumber($claim->getClaimNumber())->setMemberNumber($subscriber->getMemberId())->setProviderId($provider->getUserId())->setDate($claim->getClaimDate())->setTotal($claim->getTotal())->save();
                    foreach ($claim->services() as $service) {
                        $service_log->reset()->setClaimId($claim_id)->setService($service->getParameter('procedure_code'))->setAmount($service->getParameter('amount'))->setDate($service->getParameter('service_date'))->save();
                    }
                }
            }
            $report['claim_totals'][$provider_name] = $provider_claim_total;
        }
        //file_put_contents('claim.txt',print_r($report,true));
        return $report;
    }
    
    private function updateStatus($message) {
        file_put_contents('../claim_status.txt',$message);
    }
    
    private function markClaimInProgress($form,$subscriber=false) {
        if ($subscriber) {
            $form->reset()->setId($subscriber['id'])->setClaimStatus(CLAIM_INPROGRESS)->save();
        }
    }
    /**
     * This step aggregates data into iterators that are then pushed through 837 file generation process... based on templates.  A "play-dough" approach
     * 
     * @workflow use(EVENT)
     */
    public function run() {
        $number_to_run             = $this->getNumber() ? $this->getNumber() : 0;
        $this->updateStatus('Gathering Data...');
        if ($claim_list            = $this->getClaimList() ? $this->getClaimList() : false) {
            $claim_list = '"'.implode('","',json_decode($claim_list)).'"';
        }
        $this->provider_collection = Argus::getModel('edi/providers');
        $provider                  = Argus::getEntity('edi/providers');
        $HL                        = 0;
        $out                       = [];
        $out_claims                = [];
        $run_counter               = 0;
        $form_orm                  = Argus::getEntity('vision/consultation/forms');
        $claim_file                = 'HEDIS_VISION_'.date('ymdhis').'.837';
        //------------------------------------------------------------------------------
        foreach ($this->batchClaimsByProviders($number_to_run,$claim_list) as $provider_userid => $member_list) {
            
            if (!$provider_userid) {
                print('skipping');
                continue;
            }
           
            // o Get the provider data ready
            // o Provider members is an array of all members from the processed list above this 

            $provider               = Argus::getEntity('edi/providers')->setUserId($provider_userid)->load(true);
            $subscriber_collection  = Argus::getModel('edi/subscribers');                  //Then we allocate a "collection" object 
            $phone                  = Argus::getEntity('edi/phone_numbers')->setId($provider['phone_number_id'])->load();
            $address                = Argus::getEntity('edi/addresses')->setId($provider['address_id'])->load();
            $provider               = array_merge($provider,$this->scrubProviderData(++$HL,$provider,$address,$phone));    
            $provider_hl            = $HL;
            foreach ($member_list as $subscriber) {
                if ($run_counter >= $number_to_run) {
                    break 2;  //breaks out of both loops
                }
                $this->updateStatus('Processing Claim: '.$run_counter."/".$number_to_run);
                $claim_collection   = Argus::getModel('edi/claims');                      //We get a claim collection per user        
                $claim_collection->setLineItemControlBase(date('Ymd'));
                $service_collection = Argus::getModel('edi/services');                    //Then we get a list of services, in this case, there's only one service
                
                //some basic data sanity checking -------------------------------------------------------
                if (isset($subscriber['images_unreadable']) && ($subscriber['images_unreadable']=='Y')) {
                    $this->unreadable[] = $subscriber;
                    continue;
                }
                if (!isset($subscriber['form_type']) || !$subscriber['member_id']) {
                    $this->unprocessed[] = $subscriber;
                    continue;
                }
                if (!isset($subscriber['last_name']) || !isset($subscriber['street_address'])) {
                    $this->bad_data[] = $subscriber;
                    continue;
                }
                if (!count($diagnosis = $this->determineDiagnosis($subscriber))) {
                    $this->no_diagnosis[] = $subscriber;
                    continue;
                }
                if (isset($subscriber['address_id_combo'])) {
                    //this prioritizes what they entered in the combo over what might have been selected.
                    $subscriber['address_id'] = (strtoupper($subscriber['address_id']) == strtoupper($subscriber['address_id_combo'])) ? $subscriber['address_id'] : $subscriber['address_id_combo'];
                }
                if (isset($subscriber['address_id']) && $subscriber['address_id'] && (count(explode(',',$subscriber['address_id']))<4)) {
                    $this->bad_address[] = $subscriber;
                    continue;
                }
                
                //##############################################################
                $service_date       = date('Ymd',strtotime($subscriber['event_date'] ? $subscriber['event_date'] : ($subscriber['submitted'] ? $subscriber['submitted'] : $subscriber['modified'])));               
                if ($services = $this->determineServiceRate($subscriber,$this->determineServicesRendered($subscriber),$service_date,$this->determineCodeOrder($diagnosis))) {
                    foreach ($services as $idx => $service) {
                        $service_collection->add('3',$idx+1,$service);
                    }
                } else {
                    $this->unprocessed[] = $subscriber;
                    continue;
                }
                if (!isset($subscriber['location_id']) || !$subscriber['location_id']) {
                    $subscriber['location_id'] = isset($subscriber['location_id']) && $subscriber['location_id'] ? $subscriber['location_id'] : (isset($subscriber['location_id_combo']) ? $subscriber['location_id_combo'] : "");
                }
                if (!$provider['location_id'] = isset($subscriber['location_id']) && $subscriber['location_id'] ? $subscriber['location_id'] : ((isset($subscriber['location_id']) && $subscriber['location_id'])? $subscriber['location_id'] : '')) {
                    //We couldn't determine a business name (possibly left blank), so let's see if we can use the IPA name
                    $provider['location_id'] = (isset($subscriber['ipa_id_combo']) && ($subscriber['ipa_id_combo'])) ? $subscriber['ipa_id_combo'] : (isset($subscriber['ipa_box']) && $subscriber['ipa_box'] ? $subscriber['ipa_box'] : false);
                };
                if ($provider['location_id']) {
                    $provider['location_id'] = (strlen($provider['location_id'])<60) ? $provider['location_id'] : substr($provider['location_id'],0,59);
                    if (isset($subscriber['address_id']) && $subscriber['address_id']) {
                        $p = explode(',',strtoupper($subscriber['address_id']));
                        if (strpos(trim($p[count($p)-1])," ")) {
                            $this->bad_address[] = $subscriber;;
                            continue;
                        }
                        $offset = (count($p)==5);
                        $provider['address_id'] = trim($p[0]);
                        $provider['address_id_2'] = trim($offset ? $p[1] : '');
                        $provider['event_city']    = trim($p[1+$offset]);
                        $provider['event_state']   = trim($p[count($p)-2]);
                        $provider['event_zipcode'] = trim($p[count($p)-1]);
                    } else {
                        $provider['address_id'] = '';
                        $provider['address_id_2'] = '';
                        $provider['event_city']    = '';
                        $provider['event_state']   = '';
                        $provider['event_zipcode'] = '';
                    } 
                } else {
                    $this->location_id[] = $subscriber;
                    continue;
                }
                if (!(trim($provider['address_id']) && ($provider['city']) && ($provider['state']) && ($provider['zip_code']))) {
                    $this->bad_address[] = $subscriber;
                    continue;
                }
                //End Data Sanity Checking -------------------------------------------------------------
                //Now we need to add some information into our array objects
                //We add our 1 service to the collection
                
                //Now record that we are processing this claim so it doesn't get run again
                $this->markClaimInProgress($form_orm,$subscriber);
                
                $this->processed[]  = $subscriber;                
                $subscriber = array_merge($subscriber,['hierarchical_level'         => ++$HL,
                                                       'parent_hierarchical_level'  => $provider_hl,
                                                       'group_number'               => 'ARGUS',
                                                       'street_address_2'           => '',
                                                       'date_of_birth'              => date('Ymd',strtotime($subscriber['date_of_birth']))
                                                      ]);
                if (!$location_npi = (isset($subscriber['location_npi']) && $subscriber['location_npi']) ? $subscriber['location_npi'] : ((isset($subscriber['npi_id_combo']) && $subscriber['npi_id_combo']) ? $subscriber['npi_id_combo'] : $subscriber['npi_id'])) {
                    $this->missing_npi[] = $subscriber;
                    continue;                    
                }
                $claim     = array_merge($provider,  ['location_information'       => '11:B:1',
                                                       'entity_code'                => '1',
                                                       'diagnosis_codes'            => $diagnosis,
                                                       'claim_date'                 => date('Ymd',strtotime($subscriber['event_date'])),
                                                       'amount'                     => $service['amount'],
                                                       'location_npi'               => $location_npi,
                                                       'form_id'                    => $subscriber['id'],
                                                       'health_plan_id'             => $this->resolveHealthPlan($subscriber['screening_client'])
                                                      ]);
                $claim_collection->add($claim)->addServices($service_collection); 
                $subscriber_collection->add($subscriber,$this->payor)->addClaims($claim_collection);                                // and then we add our claim containing one service to our subscriber collection
            }
            $this->provider_collection->add($provider)->addSubscribers($subscriber_collection);
        }
        //Now we put it all together
        if ($number_to_run) {
            $x837 = Argus::getModel('edi/X837');
            $this->updateStatus('Generating Claim File...');
            $num_num = '';
            for ($i=0; $i<9; $i++) {
                $num_num .= rand(1,9);
            }

            $x837->setHeader(Argus::getModel('edi/header')->create([
                    'sender_id'                     => str_pad('ARGUS',15),
                    'receiver_id'                   => str_pad('ARGUS',15),
                    'sending_partner_id'            => 'ARGUS',
                    'receiving_partner_id'          => 'ARGUS',
                    'control_number'                => $num_num,
                    'prod_flag'                     => 'P',   /* default to test */
                    'group_control_number'          => $num_num
            ]));
            $x837->setSubmitter(Argus::getModel('edi/submitter')->create(Argus::getEntity('edi/submitters')->setIdCode('SDS')->load(true)));
            $x837->setTransactionManager(Argus::getModel('edi/transaction'));
            $x837->setReceiver(Argus::getModel('edi/receiver')->create(Argus::getEntity('edi/receivers')->setId(1)->load()));
            $x837->setFooter(Argus::getModel('edi/footer')->create([
                'number_of_transactions'        => $number_to_run,
                'group_number'                  => $num_num,
                'group_control_number'          => $num_num
            ]));
            $cfg = json_decode(file_get_contents('../../claims_config.json'));
            $x837->generate($this->provider_collection,'vision_screening')->write($cfg->source.'/'.$claim_file);
            $this->recordBatchResults();
            $this->trigger(
                    'createdClaimFile',__CLASS__,__METHOD__,$this->logProcessedClaims($this->provider_collection,$claim_file)
            );
            Argus::emit('VisionClaimReady',['date' => date('Y-m-d'),'time'=>date('H:i:s')]);
            $this->updateStatus('Done.');
        }
    }
}
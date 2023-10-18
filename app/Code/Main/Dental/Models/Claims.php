<?php
namespace Code\Main\Dental\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * The Claims Generator
 *
 * This program  generates a claim file and puts it in a specific
 * directory for Aldera to batch process
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Claims.html
 * @since      File available since Release 1.0.0
 */
class Claims extends Model
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

    /**-----------------------------------------------------------------------------
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
     *      + Subcriber             <-- Persistant Object Per Subscriber
     *            |
     *          Claims    <-- Collection to manage Claims
     *            |
     *            + Claim           <-- Persistant Object Per Claim
     *                 | 
     *              Services    <-- Collection to manage Services
     *                 |
     *                 + Service    <-- Persistant Object Per Service
     */    
    public function run() {
        $payor = [                                                              //we only have 1 payor for this project, AND you can only have one PAYOR per SUBSCRIBER so this should work
            'entity_type'   => '2',
            'name'          => 'PRESTIGE',
            'id_code'       => 'ARGUS',
            'street_address' => '4010 W STATE ST',
            'street_address_2' => '',
            'city'          => 'TAMPA',
            'state'         => 'FL',
            'zip_code'      => '33609'
        ];
        $provider_collection = Argus::getModel('edi/providers');
        $providers           = Argus::getEntity('edi/providers');
        $HL = 0;                                                                //EDI Heirarchical Level
        $result = Argus::getEntity('argus/hedis_campaign_results');
        foreach ($providers->setIdCode('1568768489')->fetch() as $provider) {
            $subscribers            = Argus::getEntity('argus/hedis_campaign_results')->newClaims();    //First we get a list of people who we will file claims for
            $subscriber_collection  = Argus::getModel('edi/subscribers');                               //Then we allocate a "collection" object 
            $provider_phone         = Argus::getEntity('argus/phone_numbers')->setId($provider['phone_number_id'])->load();
            $address                = Argus::getEntity('argus/addresses')->setId($provider['address_id'])->load();
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
                $claim_collection   = Argus::getModel('edi/claims');            //We get a claim collection per user        
                $claim_collection->setLineItemControlBase(date('Ymd'));
                $service_collection = Argus::getModel('edi/services');          //Then we get a list of services, in this case, there's only one service
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
                
                $claim_collection->add([                                        //Then add our service collection containing one service to our claim collection
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
                ],$payor)->addClaims($claim_collection);                        // and then we add our claim containing one service to our subscriber collection
                $result->reset()->setId($subscriber['id'])->setClaimStatus('Y')->save();  
            }
            $provider_collection->add($provider)->addSubscribers($subscriber_collection);
        }

        $num_num = '';                                                          //we are going to create a random 9 digit number for ccntrol number
        for ($i=0; $i<9; $i++) {
            $num_num .= rand(1,9);
        }
        
        $x837 = Argus::getModel('edi/x837');
        $x837->setHeader(Argus::getModel('edi/header')->create([
                'sender_id'                     => 'ARGUS          ',
                'receiver_id'                   => 'ARGUS          ',
                'control_number'                => $num_num,
                'prod_flag'                     => 'P',                         //set to 'T' for test, 'P' for prod
                'receiving_partner_id'          => 'ARGUS',
                'sending_partner_id'            => 'ARGUS',
                'group_control_number'          => $num_num,
                'transaction_control_number'    => '0001'
        ]));
        $x837->setSubmitter(Argus::getModel('edi/submitter')->create(Argus::getEntity('edi/submitters')->setIdCode('900117186')->load(true)));
        $x837->setReceiver(Argus::getModel('edi/receiver')->create(Argus::getEntity('edi/receivers')->setId(1)->load()));
        $x837->setFooter(Argus::getModel('edi/footer')->create([
            'transaction_control_number'    => '0001',
            'group_number'                  => $num_num,
            'control_group_number'          => $num_num
        ]));
        $x837->generate($provider_collection,'hedis_dental')->write('hedis_dental_claims'.time().'.837'); 
    }
    
    
    
}
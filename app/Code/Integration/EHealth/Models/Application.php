<?php
namespace Code\Integration\EHealth\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Application Form Manager
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Application.html
 * @since      File available since Release 1.0.0
 */
class Application extends Model
{

    use \Code\Base\Humble\Event\Handler;

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
        \Event::register('ehealth','NewEhealthApplication','A new eHealth application has arrived');
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    public function status($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
    }
    
    /**
     * Will update eHealth with the new application status
     * 
     * @workflow use(process) configuration(/ehealth/application/remoteupdate)
     * @param \Event $EVENT
     */
    public function updateEhealthStatus($EVENT=false) {
        if ($EVENT!==false) {
            $data    = $EVENT->load();
            $cfg     = $EVENT->fetch();
            $app     = $data[$cfg['appfield']];
            $history = (isset($data['ehealh_application_status_change'])) ? $data['ehealth_application_status_change'] : [];
            if (isset($cfg['status_source'])) {
                $val = false;
                switch ($cfg['status_source']) {
                    case "value"    :
                        $val    = $cfg['status'];
                        break;
                    case "field"    :
                        $field  = $app[$cfg['field']];
                        $val    = (isset($app[$field]) ? $app[$field] : false);
                        break;
                    default         :  break;
                }
                if ($val) {
                    $response  = '';
                    $effdate   = ((isset($app['start-date']) && $app['start-date']) ? $app['start-date'] : date('Y-m-d'));
                    //Comment out the next line during testing to stop this from updating e-health status, so you can re-run the test multiple times
                    $response  = $this->setEffectiveDate($effdate)->setStatus($val)->setApplicationId($app['application-id'])->getUpdateApplicationStatus();
                    $history[] = array_merge($history, [
                        'status'   => $val,
                        'response' => $response
                    ]);
                }
            }
            $EVENT->update(['ehealth_application_status_change'=>$history]);
        }
    }
    
    /**
     * Takes just the required fields from the E-Health form and moves them to our internal "common" form
     * 
     * @param type $member
     * @return type
     */
    protected function mapMember($member=false) {
        $map = [];
        if ($member) {
            $map['first-name'] = $member['first-name'];
            $map['last-name']  = $member['last-name'];
            $map['SSN']        = $map['ssn']        = (isset($member['ssn']) && ($member['ssn'])) ? $member['ssn'] : '000000000';
            $map['DOB']        = $member['DOB'];
            $map['phone']      = isset($member['phone']) ? $member['phone'] : '';
            $map['relation']   = $member['relation'];
            $map['gender']     = isset($member['gender']) ? $member['gender'] : '';
            $map['email']      = isset($member['email']) ? $member['email'] : '';
        }
        return $map;
    }
    
    /**
     * This step will pull the relevant information out of the ehealth XML application and populate our internal source-neutral data format
     * 
     * @workflow use(process) configuration(/ehealth/application/extract)
     * @param type $EVENT
     */
    public function extract($EVENT=false) {
        //
        //@TODO: We need to set the coverage start date to the first day of the next month, and for the recurring billing to start the 15th of the next month
        //
        if ($EVENT!==false) {
            $data  = $EVENT->load();
            $cfg   = $EVENT->fetch();
            if ($application = isset($data['application']) ? $data['application'] : false) {
                $subscriber      = false;
                $dependents      = [];
                $entry           = Argus::getEntity('argus/online_applications')->setApplicationId($data['application_id']);
                $entry->load(true);
                $xml             = simplexml_load_string((string)$application,null,false,'app',true);
                $extract         = $cfg['field'];
                $date            = $xml->application->{'core-data'}->{'requested-effective-date'};
                $requested_date  = $date->year.'-'.str_pad($date->month,2,'0',STR_PAD_LEFT).'-'.str_pad($date->day,2,'0',STR_PAD_LEFT);
                $ctr = 0;
                foreach ($xml->application->{'core-data'}->members->member as $member) {
                    $members[$ctr] = (array)$member;
                    $members[$ctr] = array_merge($members[$ctr],(array)$members[$ctr]['name']);
                    $members[$ctr]['DOB'] = str_pad($member->birthdate->month,2,'0',STR_PAD_LEFT).'/'.str_pad($member->birthdate->day,2,'0',STR_PAD_LEFT).'/'.$member->birthdate->year;
                    if (!$subscriber) {
                        $subscriber     = $this->mapMember($members[$ctr]);
                    } else {
                        $dependents[]   = $this->mapMember($members[$ctr]);
                    }
                    $ctr++;
                }                
                $app   = simplexml_load_string((string)$application,null,false,'app',true);          
                $plan  = simplexml_load_string((string)$application,null,false,'plan',true);
                $apr   = simplexml_load_string((string)$application,null,false,'apr',true);
                $rider = simplexml_load_string((string)$application,null,false,'rider',true);
                $addr  = simplexml_load_string((string)$application,null,false,'addr',true);
                $subscriber['phone'] = (isset($app->application->{'core-data'}->{'home-phone'}->number) && $app->application->{'core-data'}->{'home-phone'}->number) ? $app->application->{'core-data'}->{'home-phone'}->{'area-code'}.$app->application->{'core-data'}->{'home-phone'}->number : '1234567890';            
                $subscriber['email'] = (isset($app->application->{'core-data'}->email) && $app->application->{'core-data'}->email) ? $app->application->{'core-data'}->email : 'unknown@someemail.com';            
                $subscriber['dependents'] = $dependents;
                $initial_quote = 0; $ongoing_quote = 0;
                foreach ($apr->{'application-process'}->{'initial-quote'} as $rates) {
                    foreach ($rates as $rate) {
                        $x = (array)$rate->attributes();
                        $initial_quote += $x['@attributes']['amount'];
                    }
                }

                foreach ($apr->{'application-process'}->{'ongoing-quote'} as $rates) {
                    foreach ($rates as $rate) {
                        $x = (array)$rate->attributes();
                        $ongoing_quote += $x['@attributes']['amount'];
                    }
                }

                //we are sending both the original XML and an extract of the application. As long as other sources of applications share the same extract format,
                //  our workflows can be used for all of them
                $home = (array)$app->application->{'core-data'}->{'home-address'};
                $home['address1'] = (string)$home['apt-number-or-suite'].' '.$home['street'];
                $home['zip-code'] = isset($home['zip']) ? $home['zip'] : (isset($home['zip-code']) ? $home['zip-code'] : '');
                $bill = (array)$app->application->{'core-data'}->{'billing-address'};
                $home['zip-code'] = isset($bill['zip']) ? $bill['zip'] : (isset($bill['zip-code']) ? $bill['zip-code'] : '');
                $bill['address1'] = (string)$bill['apt-number-or-suite'].' '.$bill['street'];
                $mail = (array)$app->application->{'core-data'}->{'mailing-address'};
                $mail['zip-code'] = isset($mail['zip']) ? $mail['zip'] : (isset($mail['zip-code']) ? $mail['zip-code'] : '');
                $mail['address1'] = (string)$mail['apt-number-or-suite'].' '.$mail['street'];
                $app_extract = [
                    'application-id'    => $entry->getApplicationId(),
                    'start-date'        => $requested_date,
                    'end-date'          => '9999-12-31',
                    'subscriber'        => $subscriber,
                    'email'             => (string)$app->application->{'core-data'}->email,
                    'addresses'         => [
                        'home'          => $home,
                        'billing'       => $bill,
                        'mailing'       => $mail
                    ],
                    'payment'           => [
                        'credit-card'   => [
                            'name'      => [
                                    'first' => (string)$app->application->{'core-data'}->{'credit-card'}->name->{'first-name'},
                                    'last'  => (string)$app->application->{'core-data'}->{'credit-card'}->name->{'last-name'}
                                ],
                            'number'      => (string)$app->application->{'core-data'}->{'credit-card'}->{'card-number'},
                            'last-digits' => (string)$app->application->{'core-data'}->{'credit-card'}->{'cc-last-digits'},
                            'type'        => (string)$app->application->{'core-data'}->{'credit-card'}->{'type'},
                            'expiration'  => [
                                        'month' => (string)$app->application->{'core-data'}->{'credit-card'}->{'expiration-date'}->month,
                                        'year'  => (string)$app->application->{'core-data'}->{'credit-card'}->{'expiration-date'}->year
                                    ]
                        ],
                        'charges'       => [
                            'initial'   => (string)number_format($initial_quote, 2, '.', ''),
                            'recurring' => (string)number_format($ongoing_quote, 2, '.', '')
                        ]
                    ],
                    'optional'          => [
                        'address'       => (array)$addr->{'address-block'},                                                
                    ]
                ];
                $entry->setMongoId($EVENT->_id())->setExtractedData(json_encode($app_extract))->setNumberOfMembers(count($members))->setLastName($subscriber['last-name'])->setRequestedEffectiveDate($requested_date)->save();
                $EVENT->update([$extract =>$app_extract]);
            }
        }
    }
    
    /**
     * Looks for new applications on the eHealth ESB and retrieves the XML and PDF representation. Will throw an event of 'NewEhealthApplication' for each application downloaded. 
     * 
     * @workflow use(process) configuration(/ehealth/application/retrieve)
     */
    public function retrieve($EVENT=false) {
        if ($EVENT!==false) {
            $now            = new \DateTime(date('Y-m-d'));
            $this->setEndDate($now->add(new \DateInterval("P1D"))->format('Y-m-d'));   //It is not an inclusive less than so we need tomorrows date
            $this->setStartDate($now->sub(new \DateInterval("P46D"))->format('Y-m-d'));//And go back 45 days
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            $status = (isset($cfg['status']) && $cfg['status']) ? $cfg['status'] : 'R1';
            $e_name = (isset($cfg['event']) && $cfg['event']) ? $cfg['event'] : 'NewEhealthApplication';
            $applications   = $this->getAppByStatus();
            if (isset($applications->response)) {
                $downloaded = [];
                $entry      = Argus::getEntity('argus/online_applications');
                foreach ($applications->response as $apps) {
                    $apps   = (is_array($apps) ? $apps : [$apps]);  //if there's only one app, it comes across as a scalar object.  This converts the scalar to an array
                    
                    //first we download and record them
                    foreach ($apps as $application) {
                        if (isset($application->{'application-xml'})) {
                            $xml  = simplexml_load_string((string)$application->{'application-xml'},null,false,'app',true);                    
                            $downloaded[] = $xml;
                            $entry->reset();
                            $PDF = $this->setApplicationId($application->{'application-id'})->getApplicationPdf();
                            //@TODO:  I should probably do some check to see what I got back rather than just write it to disk...
                            @mkdir('../../lib/online/applications/ehealth',0775,true);
                            @file_put_contents('../../lib/online/applications/ehealth/app_'.(string)$application->{'application-id'}.".pdf",$PDF->response->pdf);
                            $entry->setApplicationMimeType('application/pdf')->setBroker('ehealth')->setLastAction('Download')->setLastActionDate(date('Y-m-d H:i:s'))->setApplicationId($application->{'application-id'})->setData((string)$application->{'application-xml'})->setStatus(EHEALTH_APPLICATION_NEW)->save();
                            $this->fire('ehealth',
                                        $e_name,
                                        [
                                            'application_id'        => (string)$application->{'application-id'},
                                            'application'           => (string)$application->{'application-xml'},
                                            'broker'                => 'E-Health',
                                            'download' => [
                                                'date'  => date('Y-m-d'),
                                                'time'  => date('H:i:s')
                                                ]
                                        ]);
                        }
                    }
                }
            }
            $EVENT->update(['applications_downloaded'=>count($downloaded),'applications'=>$downloaded]);
        }
    }
   
    /**
     * Will create an 834 EDI file and attach it to the event
     * 
     * @workflow use(process) configuration(/ehealth/application/x834)
     * @param object $EVENT
     */
    public function to834File($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            //Will keep this around for now...
            $EVENT->update([$cfg['field']=>'scaramucci: bada bing!']);
        }
    }
    
    /**
     * Acknowledges receipt of an application
     */
    public function receive() {
        $app = Argus::getEntity('ehealth/application_forms');
        $app->setId($this->getId())->load();
        if ($application_id = $app->getApplicationId()) {
            $this->setApplicationId($application_id);
            $this->setStatus('Pending');  //Pending - Carrier Received
            $response = $this->getUpdateApplicationStatus();
        }
    }
    
    /**
     * Sets the status of the ehealth application to approved
     */
    public function approve() {
        $app = Argus::getEntity('ehealth/application_forms');
        $app->setId($this->getId())->load();
        if ($application_id = $app->getApplicationId()) {
            $this->setApplicationId($application_id);
            $this->setStatus('Approved');  
            $response = $this->getUpdateApplicationStatus();
        }
    }
    
    /**
     * Sets the status of the ehealth application to approved
     */
    public function deny() {
        $app = Argus::getEntity('ehealth/application_forms');
        $app->setId($this->getId())->load();
        if ($application_id = $app->getApplicationId()) {
            $this->setApplicationId($application_id);
            $this->setStatus('Declined');  
            $response = $this->getUpdateApplicationStatus();
        }
    }
    
    /**
     * There's a Byte Order Mark on some UTF8 strings.  This removes it if it is present. 
     * 
     * @param UTF8-String $text
     * @return UTF8-String
     */
    public function remove_utf8_bom($text)  {
        $bom  = pack('H*','EFBBBF');
        return  preg_replace("/^$bom/", '', $text);
    } 
}
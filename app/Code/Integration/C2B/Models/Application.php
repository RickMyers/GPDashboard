<?php
namespace Code\Integration\C2B\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Commercial methods
 *
 * Special functionality for our processing commercial applications
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
     * Updates the MySQL online application table with information from the C2B data feed
     * 
     * @param array $app
     */
    private function recordReceipt($app=false,$extract=[]) {
        if ($app) {
            $entry = Argus::getEntity('argus/online_applications')
                     ->setApplicationId($app['application-id'])
                     ->setData(json_encode($app))
                     ->setBroker($app['broker'])
                     ->setApplicationMimeType('application/json')
                     ->setRequestedEffectiveDate($app['start-date'])
                     ->setLastName($app['subscriber']['last-name'])
                     ->setLastAction('Received')
                     ->setNumberOfMembers(count($app['subscriber']['dependents'])+1)
                     ->setExtractedData($extract)
                     ->setLastActionDate(date('Y-m-d H:i:s'))
                     ->save();
            $a = 1;
        }
    }
    
    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline
     * 
     * @param array $app
     * @return array
     */
    private function mapApplicationHeader($app=false) {
        return (!$app) ? [] : [
                    'application-id'    => $app['application-id'],
                    'start-date'        => $app['start-date'],
                    'end-date'          => $app['end-date'],
                    'broker'            => $app['broker'],
                    'e-mail'            => $app['subscriber']['email']
                ];
    }
    
    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline
     * 
     * @param array $app
     * @return array
     */
    private function mapSubscriber($app=false) {
        //'subscriber'        => $subscriber,
        return (!$app) ? [] : [
                    'first-name' => $app['subscriber']['first-name'],
                    'last-name'  => $app['subscriber']['last-name'],
                    'ssn'        => isset($app['subscriber']['SSN']) ? $app['subscriber']['SSN'] : '000000000',
                    'SSN'        => isset($app['subscriber']['SSN']) ? $app['subscriber']['SSN'] : '000000000',
                    'DOB'        => $app['subscriber']['DOB'],
                    'gender'     => $app['subscriber']['gender'],
                    'phone'      => $app['subscriber']['phone'],
                    'email'      => $app['subscriber']['email'],
                    'dependents' => $app['subscriber']['dependents'],
                    'relation'   => $app['subscriber']['relation']
                ];
    }
    
    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline
     * 
     * @param array $app
     * @return array
     */
    private function mapDependents($app=false) {
        $dependents = [];
        if ($app) {
            foreach ($app['subscriber']['dependents'] as $dependent) {
                $dependents[] = array_merge([
                    'first-name'=> $dependent['first-name'],
                    'last-name' => $dependent['last-name'],
                    'gender'    => $dependent['gender'],
                    'DOB'       => $dependent['DOB'],
                    'ssn'       => '000-00-0000',
                    'relation'  => $dependent['relation']
                ],$app['addresses']['home']);
            }
        }
        return $dependents;
    }
    
    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline
     * 
     * @param array $app
     * @return array
     */
    private function mapPlan($app=false) {
        return (!$app) ? [] : ((isset($app['plan']) ? $app['plan'] : []));
    }

    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline.  Handles multiple ways to pass zip code
     * 
     * @param array $app
     * @return array
     */    
    private function mapAddresses($app=false) {
        $addresses = (!$app) ? [] : [
                    'home'          => (isset($app['addresses']['home']) ? $app['addresses']['home'] : []),
                    'billing'       => (isset($app['addresses']['billing']) ? $app['addresses']['billing'] : []),
                    'mailing'       => []
                ];
        $addresses['home']['zip-code']    = (isset($app['addresses']['home']['zip-code']))    ? $app['addresses']['home']['zip-code']    : ((isset($app['addresses']['home']['zip']) ? $app['addresses']['home']['zip']: ''));
        $addresses['billing']['zip-code'] = (isset($app['addresses']['billing']['zip-code'])) ? $app['addresses']['billing']['zip-code'] : ((isset($app['addresses']['billing']['zip']) ? $app['addresses']['billing']['zip']: ''));
        return $addresses;
    }    
    
    /**
     * Maps the C2B section to our internal format suitable for the B2B pipeline
     * 
     * @param array $app
     * @return array
     */
    private function mapPayment($app=false) {
        return (!$app) ? [] : [
                'credit-card'   => [
                    'name'      => [
                            'first' => $app['payment']['credit-card']['first-name'],
                            'last'  => $app['payment']['credit-card']['last-name']
                        ],
                    'number'      => $app['payment']['credit-card']['number'],
                    'last-digits' => '',
                    'type'        => isset($app['payment']['credit-card']['type']) ? $app['payment']['credit-card']['type'] : '',
                    'expiration'  => [
                                'month' => $app['payment']['credit-card']['expiration']['month'],
                                'year'  => $app['payment']['credit-card']['expiration']['year']
                            ]
                ],
                'charges'       => [
                    'initial'   => (string)number_format($app['payment']['charges']['initial'], 2, '.', ''),
                    'recurring' => (string)number_format($app['payment']['charges']['recurring'], 2, '.', '')
                ]            
            ];
    }
    
    /**
     * Will take data sent to us from the commercial online application process and extract the information we need to funnel the application into our B2B intake pipeline
     * 
     * @workflow use(process) configuration(/c2b/application/extract)
     * @param type $EVENT
     */
    public function extract($EVENT) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (isset($cfg['input_field']) && $cfg['input_field'] && isset($data[$cfg['input_field']])) {
                $application = $data[$cfg['input_field']];
                $extract     = array_merge($this->mapApplicationHeader($application),
                                            [
                                                'payment'    => $this->mapPayment($application),
                                                'addresses'  => $this->mapAddresses($application),
                                                'subscriber' => $this->mapSubscriber($application),
                                                'dependents' => $this->mapDependents($application),
                                                'plan'       => $this->mapPlan($application)
                                            ]
                                        );
                $this->recordReceipt($application,json_encode($extract));
                $EVENT->update([$cfg['output_field']=>$extract]);
            }
        }
    }

    /**
     * Will reply back to the caller with data stored on the event object.
     * 
     * @workflow use(process) configuration(/c2b/application/response)
     * @param type $EVENT
     */
    public function response($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (isset($cfg['fields']) && $cfg['fields']) {
                $output             = [];
                $fields = explode(',',str_replace(["\n","\t","\r"," "],["","","",""],$cfg['fields']));
                $output['RC']       = $cfg['return_code'];
                $output['message']  = $cfg['message'];
                foreach ($fields as $field) {
                    $val    = '';                    
                    $parts  = explode('=',$field);
                    if (count($parts)>1) {
                        $field = $parts[0];
                        if (strpos($parts[1],'.')!==false) {
                            $x = str_replace(".",'"]["',$parts[1]);
                            $statement = '$val = isset($data["'.$x.'"]) ? $data["'.$x.'"] : null ;';
                            eval($statement);
                        } else {
                            $val = isset($data[$parts[1]]) ? $data[$parts[1]] : null;
                        }
                        $output[$field] = json_decode(json_encode($val),true);
                    }
                }
                $x = json_encode($output);
                \Humble::response($x);
            }
        }
    }
}
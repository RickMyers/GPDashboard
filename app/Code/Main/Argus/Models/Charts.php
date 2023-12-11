<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * General Charts Functionality
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Framework
 * @author     Rick Myers <rmyers@aflac.com>
 */
class Charts extends Model
{

    private $providers  = [];
    private $status     = [];
    private $monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    private $months     = [
        'Scanning'      => 0,
        'Screening'     => 0
    ];
    private $form_types = [
        'Scanning'      => 0,
        'Screening'     => 0
    ];
    private $payout     = [
        'Scanning'      => 0,
        'Screening'     => 0
    ];    
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     * 
     * @return string
     */
    public function monthNames() {
        return "'".implode("','",$this->monthNames)."'";
    }
    
    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    private function initializeProvider() {
        return  [  
                    'status' => [
                        
                    ],
                    'form_types' => [
                        'Scanning' => 0,
                        'Screening' => 0
                    ],
                    'payout' => [
                        'Scanning' => 0,
                        'Screening' => 0
                    ],
                    'months' => [
                        1 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        2 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        3 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        4 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        5 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        6 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        7 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        8 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        9 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        10 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        11 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ],
                        12 => [
                            'Scanning' => 0,
                            'Screening' => 0
                        ]
                    ]
                ];
    }
    
    /**
     * Rather than run a bunch of queries, we are going to run one query, get all the data, and then manipulate it here for the charts
     */
    public function claimsCharts() {
        $this->setYear($this->getYear() ? $this->getYear() : date('Y'));
        foreach (Argus::getEntity('argus/claims')->yearlyClaimData($this->getYear()) as $obs) {
            $provider_name = $obs['provider_name'];
            $obs['status'] = ($obs['status']) ? $obs['status'] : 'N/A';
            if (!isset($this->providers[$provider_name])) {
                $this->providers[$provider_name] = $this->initializeProvider();
            }
            if (!isset($this->status[$obs['status']])) {
                $this->status[$obs['status']] = 0;
            }
            if (!isset($this->providers[$provider_name]['status'][$obs['status']])) {
                $this->providers[$provider_name]['status'][$obs['status']] = 0;
            }
            $this->status[$obs['status']]++;
            $this->form_types[$obs['form_type']]++;
            $this->months[$obs['form_type']]++;
            $this->payout[$obs['form_type']]+=$obs['cost'];
            $this->providers[$provider_name]['months'][(int)$obs['mm']][$obs['form_type']]++;
            $this->providers[$provider_name]['payout'][$obs['form_type']]+=$obs['cost'];
            $this->providers[$provider_name]['form_types'][$obs['form_type']]++;
            $this->providers[$provider_name]['status'][$obs['status']]++;
        }
        print_r($this->providers);
    }
}
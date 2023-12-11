<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Demographics methods
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Rick Myers <rmyers@aflac.com>
 */
class Demographics extends Model
{

    
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
     * Will attempt to retrieve member information from EIS, and if nothing is returned, fall back to Aldera
     * 
     * @param string $member_id
     * @return array
     */
    public function memberData($member_id=false) {
        $results = [
            'total_count' => 0,
            'member_id' => '',
            'health_plan' => '',
            'demographics' => [
                'first_name'    => '',
                'last_name'     => '',
                'date_of_birth' => '',
                'address'       => '',
                'gender'        => ''
            ],
            'source' => 'EIS',
            'data' => []
        ];
        
        if ($member_id = ($member_id ? $member_id : ($this->getMemberId() ? $this->getMemberId() : false))) {
            $results['member_id'] = $member_id;
            if ( ($eis_data = Argus::getModel('eis/model')->setUniqueMemberId($member_id)->memberLookup()) || ($eis_data = Argus::getModel('eis/model')->setMemberId($member_id)->memberLookup())) {
                if ($demographics = $eis_data['members'][0]['memberDemographics'] ?? false) {
                    $results['health_plan']                     = $demographics['groupName'];
                    $results['data']                            = $eis_data;                    
                    $results['total_count']                     = $eis_data['totalCount'];
                    $results['demographics']['first_name']      = $demographics['firstName'];
                    $results['demographics']['last_name']       = $demographics['lastName'];
                    $results['demographics']['date_of_birth']   = date('Y-m-d',strtotime(str_replace('-','/',$demographics['dateOfBirth'])));
                    $results['demographics']['gender']          = $demographics['gender'];
                    if ($address = $demographics['addresses'][0] ?? false) {
                        $results['demographics']['address'] = $address['line1'].', '.$address['city'].', '.$address['state'].', '.$address['zip'];
                    }
                } else {
                    $results['source'] = 'Aldera';
                    if ($aldera_data = json_decode(Argus::getModel('vision/model')->setMemberId($member_id)->demographicInformation(),true)) {
                        $results['data']                            = $aldera_data[0];                    
                        $results['health_plan']                     = strtoupper($results['data']['group_id']);
                        $results['total_count']                     = 1;
                        $results['demographics']['first_name']      = $results['data']['first_name'];
                        $results['demographics']['last_name']       = $results['data']['last_name'];
                        $results['demographics']['date_of_birth']   = date('Y-m-d',strtotime($results['data']['date_of_birth']['date']));
                        $results['demographics']['gender']          = $results['data']['gender'];
                        $results['demographics']['address'] = $results['data']['address_full'].', '.$results['data']['city'].', '.$results['data']['state'].', '.$results['data']['zip_code'];
                    }
                    $results['data'] = $aldera_data;
                }
            }
        }
        return json_encode($results);
    }
}
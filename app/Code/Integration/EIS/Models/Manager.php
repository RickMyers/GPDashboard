<?php
namespace Code\Integration\EIS\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * EIS Manager
 *
 * A collection of helper methods for EIS
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Rick Myers <rmyers@aflac.com>
 */
class Manager extends Model
{

    private $xref = [
        'first_name' => 'firstName',
        'last_name'  => 'lastName',
        'date_of_birth' => '',
        'gender' => 'gender'
        
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
/*
 [
    {
        "group_id": "CarePlus",
        "default_lob": "VIS",
        "member_id": "3959331",
        "last_name": "WINTERS",
        "first_name": "MARTHA",
        "middle_name": "",
        "date_of_birth": {
            "date": "1946-04-03 00:00:00.000000",
            "timezone_type": 3,
            "timezone": "UTC"
        },
        "gender": "F",
        "address_1": "6701 CYPRESS RD",
        "address_2": "APT 311",
        "address_full": "6701 CYPRESS RD APT 311",
        "city": "PLANTATION",
        "state": "FL",
        "zip_code": "33317",
        "phone_number": "",
        "effective_date": {
        "date": "2022-04-01 00:00:00.000000",
        "timezone_type": 3,
        "timezone": "UTC"
        },
        "termination_date": {
            "date": "2022-12-31 00:00:00.000000",
            "timezone_type": 3,
            "timezone": "UTC"
        },
        "record_status": "A",
        "email_address": ""
    }
]
 */
    public function performLookup() {
        if ($details = $this->memberLookup()) {
            print_r($details);
            $member = $details['members'][0] ?? [];
            print_r($member);
            die();
            $member = [
                'dmg' => ($details['members'])
            ];
        } else {
            //now hit aldera
        }
        return $this->memberLookup();
    }
}
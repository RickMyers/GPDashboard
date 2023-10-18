<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * EDI x834 Generation methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 */
class X834Old extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $document           = [];

    private $loops  = [
        '2000' => [
            'description' => '',
            'occurs' => ''
        ]
    ];
    private $annotations = [
        'ST' => [
            'description' => 'TRANSACTION SET HEADER'
        ],
        'BGN' => [
            'description' => 'BEGINNING SEGMENT'
        ],
        'REF' => [
            '38' => [
                'loop' => 'HEADER',
                'description' => 'TRANSACTION SET POLICY NUMBER'
            ], 
            '0F' => [
                'loop' => '2000',
                'description' => 'SUBSCRIBER IDENTIFIER'
            ],
            '1L' => [
                'loop' => '2000',
                'description' => 'MEMBER POLICY NUMBER'
            ],
            '17' => [
                'loop' => '2000',
                'description' => 'CLIENT REPORTING CATEGORY'
            ],
            '23' => [
                'loop' => '2000',
                'description' => 'CLIENT NUMBER'
            ],            
            '3H' => [
                'loop' => '2000',
                'description' => 'CASE NUMBER'
            ], 
            '4A' => [
                'loop' => '2000',
                'description' => 'PERSONAL IDENTIFICATION NUMBER'
            ],
            '6O' => [
                'loop' => '2000',
                'description' => 'CROSS REFERENCE NUMBER'
            ],
            'ABB' => [
                'loop' => '2000',
                'description' => 'PERSONAL ID NUMBER'
            ],
            'D3' => [
                'loop' => '2000',
                'description' => 'PHARMACY NUMBER'
            ],
            'DX' => [
                'loop' => '2000',
                'description' => 'DEPARTMETN/AGENCY NUMBER'
            ],
            'F6' => [
                'loop' => '2000',
                'description' => 'HEALTH INSURANCE CLAIM (HIC) NUMBER'
            ], 
            'P5' => [
                'loop' => '2000',
                'description' => 'POSITION CODE'
            ], 
            'Q4' => [
                'loop' => '2000',
                'description' => 'PRIOR IDENTIFIER NUMBER'
            ],
            'QQ' => [
                'loop' => '2000',
                'description' => 'UNIT NUMBER'
            ], 
            'ZZ' => [
                'loop' => '2000',
                'description' => 'MUTUALLY DEFINED'
            ],            
            '60' => [
                'loop' => '2320',
                'description' => 'ACCOUNT SUFFIX CODE'
            ],
            '6P' => [
                'loop' => '2320',
                'description' => 'GROUP NUMBER'
            ],
            'SY' => [
                'loop' => '2320',
                'description' => 'SOCIAL SECURITY NUMBER'
            ],
            'ZZ' => [
                'loop' => '2320',
                'description' => 'MUTUALLY DEFINED'
            ],            
            
            '00' => [
                'loop' => '2750',
                'description' => 'CONTRACTING DISTRICT NUMBER'
            ],  
            '17' => [
                'loop' => '2750',
                'description' => 'CLIENT REPORTING CATEGORY'
            ], 
            '18' => [
                'loop' => '2750',
                'description' => 'PLAN NUMBER'
            ], 
            '19' => [
                'loop' => '2750',
                'description' => 'DIVISION IDENTIFIER'
            ], 
            '26' => [
                'loop' => '2750',
                'description' => 'UNION NUMBER'
            ], 
            '3L' => [
                'loop' => '2750',
                'description' => 'BRANCH IDENTIFIER'
            ], 
            '6M' => [
                'loop' => '2750',
                'description' => 'APPLICATION NUMBER'
            ], 
            '9V' => [
                'loop' => '2750',
                'description' => 'PAYMENT CATEGORY'
            ], 
            '9X' => [
                'loop' => '2750',
                'description' => 'ACCOUNT CATEGORY'
            ], 
            'GE' => [
                'loop' => '2750',
                'description' => 'GEOGRAPHIC NUMBER'
            ], 
            'LU' => [
                'loop' => '2750',
                'description' => 'LOCATION NUMBER'
            ], 
            'PID' => [
                'loop' => '2750',
                'description' => 'PROGRAM IDENTIFICATION NUMBER'
            ], 
            'XX1' => [
                'loop' => '2750',
                'description' => 'SPECIAL PROGRAM CODE'
            ], 
            'XX2' => [
                'loop' => '2750',
                'description' => 'SERVICE AREA CODE'
            ],
            'YY' => [
                'loop' => '2750',
                'description' => 'GEOGRAPHIC KEY'
            ], 
            'ZZ' => [
                'loop' => '2750',
                'description' => 'MUTUALLY DEFINED'
            ],             
        ],
        'DTP' => [
            '007' => [
                'loop' => 'HEADER',
                'description' => 'FILE EFFECTIVE DATE'
            ],
            '090' => [
                'loop' => 'HEADER',
                'description' => 'REPORT START'
            ],
            '091' => [
                'loop' => 'HEADER',
                'description' => 'REPORT END'
            ],
            '303' => [
                'loop' => 'HEADER',
                'description' => 'MAINTENANCE EFFECTIVE'
            ],
            '382' => [
                'loop' => 'HEADER',
                'description' => 'ENROLLMENT'
            ],
            '388' => [
                'loop' => 'HEADER',
                'description' => 'PAYMENT COMMENCEMENT'
            ],            
            '050' => [
                'loop' => '2000',
                'description' => 'RECEIVED'
            ],
            '286' => [
                'loop' => '2000',
                'description' => 'RETIREMENT'
            ],
            '296' => [
                'loop' => '2000',
                'description' => 'INITIAL DISABILITY PERIOD RETURN TO WORK'
            ],
            '297' => [
                'loop' => '2000',
                'description' => 'INITIAL DISABILITY PERIOD LAST DAY WORKED'
            ],
            '300' => [
                'loop' => '2000',
                'description' => 'ENROLLMENT SIGNATURE DATE'
            ],
            '301' => [
                'loop' => '2000',
                'description' => 'CORBA QUALIFYING EVENT'
            ],
            '303' => [
                'loop' => '2000',
                'description' => 'MAINTENANCE EFFECTIVE'
            ],
            
            '348' => [
                'loop' => '2300',
                'description' => 'BENEFIT BEGIN'
            ],
            '349' => [
                'loop' => '2300',
                'description' => 'BENEFIT END'
            ],
            '543' => [
                'loop' => '2300',
                'description' => 'LAST PREMIUM PAID DATE'
            ],
            '695' => [
                'loop' => '2300',
                'description' => 'PREVIOUS PERIOD'
            ],
            
            
            '336' => [
                'loop' => '2000',
                'description' => 'EMPLOYMENT BEGIN'
            ],
            '337' => [
                'loop' => '2000',
                'description' => 'EMPLOYMENT END'
            ],
            '338' => [
                'loop' => '2000',
                'description' => 'MEDICARE BEGIN'
            ],
            '339' => [
                'loop' => '2000',
                'description' => 'MEDICARE END'
            ],
            '340' => [
                'loop' => '2000',
                'description' => 'COBRA BEGIN'
            ],
            '341' => [
                'loop' => '2000',
                'description' => 'COBRA END'
            ],
            '350' => [
                'loop' => '2000',
                'description' => 'EDUCATION BEGIN'
            ],
            '351' => [
                'loop' => '2000',
                'description' => 'EDUCATION END'
            ],
            '356' => [
                'loop' => '2000',
                'description' => 'ELIGIBILITY BEGIN'
            ],
            '357' => [
                'loop' => '2000',
                'description' => 'ELIGIBILITY END'
            ],
            '383' => [
                'loop' => '2000',
                'description' => 'ADJUSTED HIRE'
            ],
            '385' => [
                'loop' => '2000',
                'description' => 'CREDITED SERVICE BEGIN'
            ],
            '386' => [
                'loop' => '2000',
                'description' => 'CREDITED SERVICE END'
            ],
            '393' => [
                'loop' => '2000',
                'description' => 'PLAN PARTICIPATION SUSPENSION'
            ],
            '394' => [
                'loop' => '2000',
                'description' => 'REHIRE'
            ],
            '473' => [
                'loop' => '2000',
                'description' => 'MEDICAID BEGIN'
            ],
            '474' => [
                'loop' => '2000',
                'description' => 'MEDICAID END'
            ],
            '360' => [
                'loop' => '2200',
                'description' => 'INITIAL DISABILITY PERIOD START'
            ],
            '361' => [
                'loop' => '2200',
                'description' => 'INITIAL DISABILITY PERIOD END'
            ],  
            '344' => [
                'loop' => '2320',
                'description' => 'COORDINATION OF BENEFITS BEGIN'
            ],
            '345' => [
                'loop' => '2320',
                'description' => 'COORDINATION OF BENEFITS END'
            ],            
            
            '007' => [
                'loop' => '2750',
                'description' => 'REPORTING CATEGORY EFFECTIVE DATE'
            ],
        ],
        'QTY' => [
            'DT' => [
                'loop' => 'HEADER',
                'description' => 'DEPENDENT TOTAL'
            ],
            'ET' => [
                'loop' => 'HEADER',
                'description' => 'EMPLOYEE TOTAL'
            ],
            'TO' => [
                'loop' => 'HEADER',
                'description' => 'TOTAL'
            ],            
        ],
        'N1' => [
            'P5' => [
                'loop' => '1000A',
                'description' => 'SPONSOR NAME'
            ],
            'IN' => [
                'loop' => '1000B',
                'description' => 'PAYER'
            ],
            'BO' => [
                'loop' => '1000C',
                'description' => 'BROKER OR SALES OFFICE'
            ],            
            'TV' => [
                'loop' => '1000C',
                'description' => 'THIRD PARTY ADMINISTRATOR (TPA)'
            ],
            '75' => [
                'loop' => '2750',
                'description' => 'PARTICIPANT'
            ],
        ],
        'ACT' => [
            'loop' => '1100C',
            'description' => 'TPA/BROKER ACCOUNT INFORMATION'
        ],
        'INS' => [
            'loop' => '2000',
            'description' => 'MEMBER LEVEL DETAIL'
        ],
        'NM1' => [
            '74' => [
                'loop' => '2100A',
                'description' => 'CORRECTED INSURED'
            ],
            'IL' => [
                'loop' => '2100A',
                'description' => 'INSURED OR SUBSCRIBER'
            ],            
            '70' => [
                'loop' => '2100B',
                'description' => 'INCORRECT MEMBER NAME'
            ],
            '31' => [
                'loop' => '210C',
                'description' => 'MEMBER MAILING ADDRESS'
            ],
            '36' => [
                'loop' => '2100D',
                'description' => 'MEMBER EMPLOYER'
            ],
            'M8' => [
                'loop' => '2100E',
                'description' => 'MEMBER SCHOOL'
            ],
            'S3' => [
                'loop' => '2100F',
                'description' => 'CUSTODIAL PARENT'
            ],
            '6Y' => [
                'loop' => '2100G',
                'description' => 'CASE MANAGER'
            ],
            '9K' => [
                'loop' => '2100G',
                'description' => 'KEY PERSON'
            ],
            'E1' => [
                'loop' => '2100G',
                'description' => 'PERSON OR ENTITY LEGALLY RESPONSIBLE'
            ],
            'EL' => [
                'loop' => '2100G',
                'description' => 'EXECUTOR OF ESTATE'
            ],
            'EXS' => [
                'loop' => '2100G',
                'description' => 'EX-SPOUSE'
            ],
            'GB' => [
                'loop' => '2100G',
                'description' => 'OTHER INSURED'
            ],
            'GD' => [
                'loop' => '2100G',
                'description' => 'GUARDIAN'
            ],
            'J6' => [
                'loop' => '2100G',
                'description' => 'POWER OF ATTORNEY'
            ],
            'LR' => [
                'loop' => '2100G',
                'description' => 'LEGAL REPRESENTATIVE'
            ],
            'QD' => [
                'loop' => '2100G',
                'description' => 'RESPONSIBLE PARTY'
            ],
            'S1' => [
                'loop' => '2100G',
                'description' => 'PARENT'
            ],
            'TZ' => [
                'loop' => '2100G',
                'description' => 'SIGNIFICANT OTHER'
            ],
            'X4' => [
                'loop' => '2100G',
                'description' => 'SPOUSE'
            ],
            '45' => [
                'loop' => '2100H',
                'description' => 'DROP OFF LOCATION'
            ],
            '1X' => [
                'loop' => '2310',
                'description' => 'LABORATORY'
            ],
            '3D' => [
                'loop' => '2310',
                'description' => 'OBSETRICS AND GYNECOLOGY FACILITY'
            ],
            '80' => [
                'loop' => '2310',
                'description' => 'HOSPITAL'
            ],
            'FA' => [
                'loop' => '2310',
                'description' => 'FACILITY'
            ],
            'OD' => [
                'loop' => '2310',
                'description' => 'DOCTOR OF OPOMETRY'
            ],
            'P3' => [
                'loop' => '2310',
                'description' => 'PRIMARY CARE PROVIDER'
            ],
            'QA' => [
                'loop' => '2310',
                'description' => 'PHARMACY'
            ],
            'QN' => [
                'loop' => '2310',
                'description' => 'DENTIST'
            ],
            'Y2' => [
                'loop' => '2310',
                'description' => 'MANAGED CARE ORGANIZATION'
            ],
            '36' => [
                'loop' => '2330',
                'description' => 'EMPLOYER'
            ],
            'GW' => [
                'loop' => '2330',
                'description' => 'GROUP'
            ],
            'IN' => [
                'loop' => '2330',
                'description' => 'INSURER'
            ]
        ],
        'PER' => [
            'IP' => [
                'loop' => '2100A',
                'description' => 'INSURED PARTY'
            ],
            'EP' => [
                'loop' => '2100D',
                'description' => 'MEMBER EMPLOYER COMMUNICATIONS NUMBERS'
            ],
            'SK' => [
                'loop' => '2100E',
                'description' => 'MEMBER SCHOOL COMMUNICATIONS NUMBERS'
            ],
            'PQ' => [
                'loop' => '2100F',
                'description' => 'CUSTODIAL PARENT COMMUNICATIONS NUMBERS'
            ],
            'RP' => [
                'loop' => '2100G',
                'description' => 'RESPONSIBLE PERSON COMMUNICATIONS NUMBERS'
            ],
            
            'IC' => [
                'loop' => '2310',
                'description' => 'PROVIDER INFORMATION CONTACT'
            ],
            'CN' => [
                'loop' => '2330',
                'description' => 'GENERAL CONTACT'
            ],            
        ],
        'N3' => [
            'loop' => '*',
            'description' => 'STREET ADDRESS'
        ], 
        'N4' => [
            'loop' => '*',
            'description' => 'CITY, STATE, ZIP CODE'
        ],
        'DMG' => [
            'loop' => '*',
            'description' => 'MEMBER DEMOGRAPHICS'
        ],
        'EC' => [
            'loop' => '2100A',
            'description' => 'EMPLOYMENT CLASS'
        ],
        'ICM' => [
            'loop' => '2100A',
            'description' => 'MEMBER INCOME'
        ],
        'AMT' => [
            'B9' => [
                'loop' => '2100A',
                'description' => 'CO-INSURANCE ACTUAL'
            ],
            'C1' => [
                'loop' => '2100A',
                'description' => 'CO-PAYMENT AMOUNT'
            ],
            'D2' => [
                'loop' => '2100A',
                'description' => 'DEDUCTIBLE AMOUNT'
            ],
            'EBA' => [
                'loop' => '2100A',
                'description' => 'EXPECTED EXPENDITURE AMOUNT'
            ],
            'FK' => [
                'loop' => '2100A',
                'description' => 'OTHER UNLISTED AMOUNT'
            ],
            'P3' => [
                'loop' => '2100A',
                'description' => 'PREMIUM AMOUNT'
            ],
            'R' => [
                'loop' => '2100A',
                'description' => 'SPEND DOWN'
            ],            
            '' => [
                'loop' => '2300',
                'description' => 'HEALTH COVERAGE POLICY'
            ],
        ],
        'HLH' => [
            'loop' => '2100A',
            'description' => 'MEMBER HEALTH INFORMATION'
        ],
        'LUI' => [
            'LD' => [
                'loop' => '2100A',
                'description' => 'NISO Z39.53 LANGUAGE CODES'
            ],
            'LE' => [
                'loop' => '2100A',
                'description' => 'ISO 639 LANGUAGE CODES'
            ],            
        ],
        'DSB' => [
            '1' => [
                'loop' => '2200',
                'description' => 'SHORT TERM DISABILITY'
            ],
            '2' => [
                'loop' => '2200',
                'description' => 'LONG TERM DISABILITY'
            ],
            '3' => [
                'loop' => '2200',
                'description' => 'PERMANENT OR TOTAL DISABILITY'
            ],
            '4' => [
                'loop' => '2200',
                'description' => 'NO DISABILITY'
            ],            
        ],
        'HD' => [
            '001' => [
                'loop' => '2300',
                'description' => 'CHANGE'
            ],
            '002' => [
                'loop' => '2300',
                'description' => 'DELETE'
            ],
            '021' => [
                'loop' => '2300',
                'description' => 'ADDITION'
            ],
            '024' => [
                'loop' => '2300',
                'description' => 'CANCELLATION OR TERMINATION'
            ],
            '025' => [
                'loop' => '2300',
                'description' => 'REINSTATEMENT'
            ],
            '026' => [
                'loop' => '2300',
                'description' => 'CORRECTION'
            ],
            '030' => [
                'loop' => '2300',
                'description' => 'AUDIT OR COMPARE'
            ],
            '032' => [
                'loop' => '2300',
                'description' => 'EMPLOYEE INFORMATION NOT APPLICABLE'
            ],            
        ],
        'IDC' => [
            'loop' => '2300',
            'description' => 'IDENTIFICATION CARD'
        ],
        'LX' => [
            '#' => [
                'loop' => '2310',
                'description' => 'PROVIDER INFORMATION'
            ],
            '#' => [
                'loop' => '2710',
                'description' => 'MEMBER REPORTING CATEGORIES'
            ],
        ],
        'PLA' => [
            '2' => [
                'loop' => '2310',
                'description' => 'PROVIDER CHANGE (UPDATE)'
            ],
        ],
        'COB' => [
            'P' => [
                'loop' => '2320',
                'description' => 'PRIMARY'
            ],
            'S' => [
                'loop' => '2320',
                'description' => 'SECONDARY'
            ],
            'T' => [
                'loop' => '2320',
                'description' => 'TERTIARY'
            ],
            'U' => [
                'loop' => '2320',
                'description' => 'UNKNOWN'
            ],            
        ],
        'LS' => [
            '2700' => [
                'loop' => '2330',
                'description' => 'ADDITINAL REPORTING CATEGORIES'
            ],
        ],
        'LE' => [
            '2700' => [
                'loop' => '2330',
                'description' => 'ADDITIONAL REPORTING CATEGORIES LOOP TERMINATION'
            ],            
            
        ],
        'SE' => [
            'description' => 'TRANSACTION SET TRAILER'
        ],
        'GS' => [
            'description' => 'FUNCTIONAL GROUP HEADER'
        ],
        'GE' => [
            'description' => 'FUNCTIONAL GROUP TRAILER'
        ],
        'IEA' => [
            'description' => 'INTERCHANGE CONTROL TRAILER'
        ],
        'ISA' => [
            'description' => 'INTERCHANGE CONTROL HEADER'
        ]        
    ];
    
    private $sections           = [
        'header'     => [
            'root'      => '/lib/EDI/834/header',
            'templater' => null,
            'template'  => 'default.rain'
        ],        
        'footer'       => [
            'root'      => '/lib/EDI/834/footer',
            'templater' => null,
            'template'  => 'default.rain'
        ]        
    ];
    
    private $data   = [];
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
     * If found in the annotations array, will return the description of the 834 segment
     * 
     * @param string $seg_0
     * @param string $seg_1
     * @return string
     */
    public function insertAnnotation($seg_0,$seg_1) {
        return (isset($this->annotations[$seg_0][$seg_1])) ? $this->annotations[$seg_0][$seg_1]['description'] : ((isset($this->annotations[$seg_0]['description'])) ? $this->annotations[$seg_0]['description'] : "UNKNOWN");
    }
    
    /**
     * Adds a description of the segment in front of the segment itself
     * 
     * @param filename $file
     * @return array
     */
    public function annotate($file=false) {
        $lines = [];
        if ($file = ($file) ? $file : ($this->getFile() ? $this->getFile() : false )) {
            foreach(explode('~',file_get_contents($file)) as $line) {
                $segment = explode('*',$line);
                $lines[] = str_pad($this->insertAnnotation($segment[0],$segment[1]),50).$line;
            }
        }
        return $lines;
    }

    protected function generateSection($rain,$template,$data) {
        foreach ($data as $field => $value) {
            $rain->assign($field,$value);
        }
        return $rain->draw($template,true);    
    }
    
    public function generate($template='default',$data=[]) {
        $root   = Environment::getRoot('edi').'/lib/EDI/834/';
        $header = file_exists($root.'header/'.$template.'.rain') ? $template : 'default';
        $body   = file_exists($root.'body/'.$template.'.rain') ? $template : 'default';
        $footer = file_exists($root.'footer/'.$template.'.rain') ? $template : 'default';
        $document = $this->generateSection(Environment::getInternalTemplater($root.'header/'),$header,$data[0]);
        foreach ($data as $member) {
            $document .= $this->generateSection(Environment::getInternalTemplater($root.'body/'),$body,$member);
        }
        return $document.$this->generateSection(Environment::getInternalTemplater($root.'footer/'),$footer,array_merge($data[0],['segments'=>count(explode("\n",$document))]));
    }
}

<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 * 
 * EDI Functions
 *
 * Support for EDI 834 data format
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dental and Vision
 * @since      File available since Release 1.0.0
 */
class Edi extends \Code\Main\Argus\Models\Model
{

    protected $loops = [
        '834' => [
            '1000' => [
                "description" => "",
                "repeats"  => "1",
                "segments" => ["BGN","REF","DTP","QTY"],
                "detail" => [
                    "BGN" => ["BGN01","BGN02","BGN03","BGN04","BGN05","BNG06","****","BGN08"],
                    "REF" => ["REF01","REF02"],
                    "DTP" => ["DTP01","DTP02","DTP03"],
                    "QTY" => ["QTY01","QTY02"]
                ],
                "loops" => [
                    '1000A' => [
                        "description" => "Sponsor Name",
                        "repeats"  => "1",
                        "segments" => [["N1","P5"]],
                        "detail" => [
                            "N1" => ["N101","N102","N103","N104"]
                        ],
                        "loops" => false
                    ],
                    '1000B' => [
                        "description" => "Payer",
                        "repeats"  => "1",
                        "segments" => [["N1"]],
                        "detail" => [
                            "N1" => ["N101","N102","N103","N104"]
                        ],
                        "loops" => false
                    ],
                    '1100C' => [
                        "description" => "TPA/Broker Name",
                        "repeats" => "2",
                        "segments" => [["N1",["BO","TV"]]],
                        "detail" => [
                            "N1" => ["N101","N102","N103","N104"]
                        ],
                        "loops" => [
                            '1000A' => [
                                "description" => "TPA/Broker Account",
                                "repeats"  => "1",
                                "segments" => ["ACT"],
                                "detail" => [
                                    "ACT" => ["ACT01","ACT02"]
                                ],
                                "loops" => false
                            ]
                        ]
                    ]
                ]
            ],
            '2000' => [
                "description" => "Member Level Detail",
                "repeats"  => ">1",
                "segments" => ["INS",["REF","0F"],["REF","1L"],["REF",["17","23","3H","4A","6O","ABB","D3","DX","F6","F5","Q4","QQ","ZZ"]],"DTP"],
                "detail" => [
                    "INS" => [],
                    "REF" => [],
                    "DTP" => []
                ],
                "loops" => [
                    '2100A' => [
                        "description" => "Member Name",
                        "repeats"  => "1",
                        "segments" => [["NM1",["74","IL"]],"PER","N3","N4","DMG","EC","ICM","AMT","HLH","LUI"],
                        "detail" => [
                            "NM1" => [],
                            "PER" => [],
                            "N3"  => [],
                            "N4"  => [],
                            "DMG" => [],
                            "EC"  => [],
                            "ICM" => [],
                            "AMT" => [],
                            "HLH" => [],
                            "LUI" => []
                        ],
                        "loops" => false
                    ],
                    '2100B' => [
                        "description" => "Incorrect Member Name",
                        "repeats"  => "1",
                        "segments" => [["NM1","70"],"DMG"],
                        "detail" => [
                            "NM1" => [],
                            "DMG" => []
                        ],
                        "loops" => false                            
                    ],
                    '2100C' => [
                        "description" => "Member Mailing Address",
                        "repeats"  => "1",
                        "segments" => [["NM1","31"],"N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "N3"  => [],
                            "N4"  => []
                        ],
                        "loops" => false                            
                    ],
                    '2100D' => [
                        "description" => "Member Employer",
                        "repeats"  => "3",
                        "segments" => [["NM1","36"],"PER","N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "PER" => [],
                            "N3"  => [],
                            "N4"  => []
                        ],
                        "loops" => false
                    ],
                    '2100E' => [
                        "description" => "Member School",
                        "repeats"  => "3",
                        "segments" => [["NM1","M8"],"PER","N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "PER" => [],
                            "N3"  => [],
                            "N4"  => []
                        ],
                        "loops" => false
                    ],
                    '2100F' => [
                        "description" => "Custodial Parent",
                        "repeats"  => "1",
                        "segments" => [["NM1","S3"],"PER","N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "PER" => [],
                            "N3"  => [],
                            "N4"  => []  
                        ],
                        "loops" => false
                    ],
                    '2100G' => [
                        "description" => "Responsible Parent",
                        "repeats"  => "13",
                        "segments" => [["NM1",["6Y","9K","E1","EI","EXS","GB","GD","J6","LR","QD","S1","TZ","X4"]],"PER","N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "PER" => [],
                            "N3"  => [],
                            "N4"  => []
                        ],
                        "loops" => false
                    ],
                    '2100H' => [
                        "description" => "Drop-Off Location",
                        "repeats"  => "1",
                        "segments" => [["NM1","45"],"N3","N4"],
                        "detail" => [
                            "NM1" => [],
                            "N3"  => [],
                            "N4"  => []  
                        ],
                        "loops" => false
                    ],
                    '2200' => [
                        "description" => "Disability Information",
                        "repeats"  => ">1",
                        "segments" => [["DSB",["1","2","3","4"]],"DTP"],
                        "detail" => [
                            "DSB" => [],
                            "DTP" => []
                        ],
                        "loops" => false
                    ],
                    '2300' => [
                        "description" => "Health Coverage",
                        "repeats"  => "99",
                        "segments" => [["HD",["001","002","021","024","025","026","030","032"]],"DTP","AMT",["REF",['17','1L',"9V","CE","E8","M7","PID","RB","X9","XM","XX1","XX2","ZX","ZZ"]],["REF","QQ"],"IDC"],
                        "detail" => [
                            "HD"  => [],
                            "DTP" => [],
                            "AMT" => [],
                            "REF" => [],
                            "IDC" => []
                        ],
                        'loops' => [
                            '2310' => [
                                "description" => "Provider Information",
                                "repeats"  => "30",
                                "segments" => ["LX","NM1","N3","N4","PER","PLA"],
                                "detail" => [
                                    "LX"  => [],
                                    "NM1" => [],
                                    "N3"  => [],
                                    "N4"  => [],
                                    "PER" => [],
                                    "PLA" => [],
                                ],
                                "loops" => false
                            ],                            
                            '2320' => [
                                "description" => "Coordination of Benefits",
                                "repeats"  => "5",
                                "segments" => [["COB",["P","S","T","U"]],["REF",["60","6P","SY","ZZ"]],"DTP"],
                                "detail" => [
                                    "COB" => [],
                                    "REF" => [],
                                    "DTP" => []
                                ],
                                "loops" => [
                                    '2330' => [
                                        "description" => "Coordination of Benefits Related Entity",
                                        "repeats"  => "1",
                                        "segments" => [["NM1",["36","GW","IN"]],"N3","N4","PER"],
                                        "detail" => [
                                            "NM1" => [],
                                            "PER" => [],
                                            "N3"  => [],
                                            "N4"  => []
                                        ],
                                        "loops" => false
                                    ]                                    
                                ]
                            ]
                        ]
                    ],
                    '2710' => [
                        "description" => "Member Reporting Categories",
                        "repeats"  => ">1",
                        "segments" => ["LX"],
                        "detail" => [
                            "LX" => []
                        ],
                        "loops" => [
                            '2750' => [
                                "description" => "Reporting Category",
                                "repeats"  => "1",
                                "segments" => [["N1","75"],["REF",["00","17","18","19","26","3L","6M","9V","9X","GE","LU","PID","XX1","XX2","YY","ZZ"]],"DTP"],
                                "detail" => [
                                    "N1"  => [],
                                    "REF" => [],
                                    "DTP" => []
                                ],
                                "loops" => false
                            ]
                        ]
                    ]
                ]
            ]
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

    protected function extract834BodySections($data=false) {
        $stack = [];   //push the loop section name on to the stack to know where you are at in the structure
    }
    
    /**
     * Breaks an EDI file up into its sections
     * 
     * @param type $data
     * @return boolean
     */
    protected function extractSections($data=false) {
        $sections = ["header"=>[],"body"=>[],"footer"=>[]];
        $triggers = [
            "header" => ["begin"=>"ISA", "end"=>"ST"],
            "body"   => ["begin"=>"BGN", "end"=>"LE"],
            "footer" => ["begin"=>"SE", "end"=>"IEA"]];
        $ctr = 0;
        if ($data) {
            $data = explode('~',$data);
            foreach ($sections as $section => $flag) {
                do {
                    $sections[$section][] = $data[$ctr];
                    $segments = explode('*',$data[$ctr]);
                    $ctr++;
                } while ($segments[0] != $triggers[$section]['end']);
            }
        }
        return $sections;
    }
    
    /**
     * Extracts data from an 834 and puts it into a CSV format
     * 
     * @workflow use(process) configuration(/argus/edi/csv834)
     * @param type $EVENT
     */
    public function convertToCSV($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (is_set($data[$cfg['event_field']])) {
                if (file_exists($file = $data[$cfg['event_field']])) {
                    $sections = $this->extractSections(file_get_contents($file));
                }
            }
        }
    }
    
    /**
     * 
     * 
     * @param type $sections
     * @return type
     */
    private function recurseEDILoop($sections) {
        $boundries = [];
        foreach ($sections as $loop_id => $section) {
            $segments = $section['segments'];
            if (is_array($segments[0])) {
                if (is_array($segments[0][1])) {
                    foreach ($segments[0][1] as $segment) {
                         $boundaries[$segments[0][0].'*'.$segment] = $loop_id." - ".$section['description'];
                    } 
                } else {
                    $boundaries[$segments[0][0].'*'.$segments[0][1]] = $loop_id." - ".$section['description'];
                }
            } else {
                $boundaries[$segments[0]] = $loop_id." - ".$section['description'];
            }
            if ($section['loops']) {
                $boundaries = array_merge($boundaries,$this->recurseEDILoop($section['loops']));
            }
        }
        return $boundaries;
    }
    
    /**
     * Explains the sections of the 834
     * 
     * @param type $filename
     * @return string
     */
    public function annotate834($filename=false) {
        $report = []; $current_section = '';
        if ($filename && file_exists($filename)) {
            $sections   = $this->extractSections(file_get_contents($filename));
            $boundaries = $this->recurseEDILoop($this->loops['834']);
            foreach ($sections['body'] as $idx => $row) {
                $segments = explode('*',$row);
                $current_section = (isset($boundaries[$segments[0].'*'.$segments[1]])) ? $boundaries[$segments[0].'*'.$segments[1]] : ($boundaries[$segments[0]] ? $boundaries[$segments[0]]: $current_section);
                $report[] = str_pad($current_section,45).$sections['body'][$idx];
            }
        }
        return $report;
    }
    
    
}